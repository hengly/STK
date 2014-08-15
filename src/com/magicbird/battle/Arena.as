package com.chaosTK.battle
{
    import com.chaosTK.action.ActionMgr;
    import com.chaosTK.action.FunctorAction;
    import com.chaosTK.action.IAction;
    import com.chaosTK.action.MoveAction;
    import com.chaosTK.action.SequenceAction;
    import com.chaosTK.game.Scene;
    import com.chaosTK.resource.BattleResMgr;
    import com.chaosTK.util.assert;
    
    import flash.display.Sprite;

    public class Arena
    {
        private static const GongbingIndex : int = 0;
        private static const QibingIndex : int = 1;
        private static const JianbingIndex : int = 2;
        private static const AttackingIndexArray : Array = new Array(QibingIndex, JianbingIndex, GongbingIndex);
        private static const AttackedIndexArray : Array = new Array(GongbingIndex, QibingIndex, JianbingIndex);
        private static const DefaultAnimationTimeInSecs : int = 1;
        private var battle : Battle;
        private var scene : Sprite;
        private var _playerSideArenaLayout : ArenaSideLayout;
        private var _otherSideArenaLayout : ArenaSideLayout;
        private var playerSideWorking : Boolean;
        private var procedingGrid : ArenaGrid;

        public function Arena(battle : Battle)
        {
            scene = new Sprite();
            this.battle = battle;
        }

		public function get otherSideArenaLayout():ArenaSideLayout
		{
			return _otherSideArenaLayout;
		}

		public function set otherSideArenaLayout(value:ArenaSideLayout):void
		{
			_otherSideArenaLayout = value;
		}

		public function get playerSideArenaLayout():ArenaSideLayout
		{
			return _playerSideArenaLayout;
		}

		public function set playerSideArenaLayout(value:ArenaSideLayout):void
		{
			_playerSideArenaLayout = value;
		}

        public function start() : void
        {
            battle.playerSideBattle.arenaLayout.x = 50;
            battle.playerSideBattle.arenaLayout.y = 0;
            scene.addChild(battle.playerSideBattle.arenaLayout);

            battle.otherSideBattle.arenaLayout.x = BattleResMgr.instance.battleDesc.otherSideStartX - battle.otherSideBattle.arenaLayout.width;
            scene.addChild(battle.otherSideBattle.arenaLayout);

            Scene.instance.setCurrentScene(scene);

            playerSideArenaLayout = battle.otherSideBattle.arenaLayout;
            otherSideArenaLayout = battle.playerSideBattle.arenaLayout;

            fightOn(0, 0);
        }

        private function fightOn(row : int, index : int) : void
        {
            if (index >= AttackingIndexArray.length)
            {
                if (row >= BattleResMgr.instance.battleDesc.gridDimensionY)
                {
                    finish(false);
                }
                else
                {
                    fightOn(row + 1, 0);
                }
                return;
            }
            var playerGrid : ArenaGrid = playerSideArenaLayout.getArenaGrid(row, AttackingIndexArray[index]) as ArenaGrid;
            var otherGrid : ArenaGrid = otherSideArenaLayout.getArenaGrid(row, AttackingIndexArray[index]) as ArenaGrid;
            if (playerGrid == null && otherGrid == null)
            {
                fightOn(row, index + 1);
                return;
            }
            var startGrid : ArenaGrid = playerGrid;
            procedingGrid = otherGrid;
            if (startGrid == null || (otherGrid != null && startGrid.speed < otherGrid.speed))
            {
                startGrid = otherGrid;
                procedingGrid = playerGrid;
                playerSideWorking = false;
            }
            else
            {
                playerSideWorking = true;
            }

            triggerAttack(row, index, startGrid);
        }

        private function triggerAttack(row : int, index : int, grid : ArenaGrid) : void
        {
            var diffX : Number = BattleResMgr.instance.battleDesc.gridSizeX * 4;
            if (grid.referee.revert)
            {
                diffX = -diffX;
            }
            assert(grid.referee.parent != null);
            var attackAnimationAction : IAction = new MoveAction(DefaultAnimationTimeInSecs, grid.referee, grid.referee.x + diffX, grid.referee.y);
            var attackBackAnimation : IAction = new MoveAction(DefaultAnimationTimeInSecs, grid.referee, grid.referee.x, grid.referee.y);
            var attackFunctor : IAction = new FunctorAction(function(args : Array) : void
            {
                attackCalc(args[0], args[1], args[2]);
            }, row, index, grid);

            var actions : IAction = new SequenceAction().register(attackAnimationAction, attackBackAnimation, attackFunctor);
            ActionMgr.instance.registerAction(actions);
        }

        private function attackCalc(row : int, index : int, grid : ArenaGrid) : void
        {
            var otherSide : ArenaSideLayout;
            var selfSide : ArenaSideLayout;
            if (playerSideWorking)
            {
                otherSide = otherSideArenaLayout;
                selfSide = playerSideArenaLayout;
            }
            else
            {
                otherSide = playerSideArenaLayout;
                selfSide = otherSideArenaLayout;
            }

            for each (var i : int in AttackedIndexArray)
            {
                var attacked : ArenaGrid = otherSide.getArenaGrid(row, AttackedIndexArray[i]) as ArenaGrid;
                if (attacked == null)
                {
                    continue;
                }
                var selfDamage : int = grid.atk * (1 - attacked.def);
                var selfOrgiReferee : Fighter = grid.referee;
                assert(selfSide.contains(selfOrgiReferee));
                var otherOrgiReferee : Fighter = attacked.referee;
                assert(otherSide.contains(otherOrgiReferee));
                var killed : int = attacked.onDamage(grid.atk);
                var lost : int = grid.onDamage(selfDamage);
                trace((playerSideWorking ? "player" : "ai") + " (" + row + "," + AttackingIndexArray[index] + ")" + "attack " + "(" + row + "," + AttackedIndexArray[i] + ")" + ", lost:" + lost + ",killed:" + killed);

                if (attacked.size == 0)
                {
                    otherSide.removeChild(otherOrgiReferee);
                    otherSide.clearArenaGrid(row, AttackedIndexArray[i]);
                }
                else
                {
                    otherSide.removeChild(otherOrgiReferee);
                    attacked.referee.x = otherOrgiReferee.x;
                    attacked.referee.y = otherOrgiReferee.y;
                    attacked.referee.alpha = 1.0;
					attacked.referee.removeColorMask();
                    otherSide.addChild(attacked.referee);
                    attacked.referee.showTextInfo(attacked.size.toString());
                }

                if (grid.size == 0)
                {
                    selfSide.removeChild(selfOrgiReferee);
                    selfSide.clearArenaGrid(row, AttackingIndexArray[index]);
                    break;
                }
                else
                {
                    selfSide.removeChild(selfOrgiReferee);
                    grid.referee.x = selfOrgiReferee.x;
                    grid.referee.y = selfOrgiReferee.y;
                    grid.referee.alpha = 1.0;
					grid.referee.removeColorMask();
                    selfSide.addChild(grid.referee);
                    grid.referee.showTextInfo(grid.size.toString());
                }
            }
            if (grid.size > 0)
            {
                var instancedPlayer : InstancedPlayer = (playerSideWorking ? battle.playerSideBattle.instancedPlayer : battle.otherSideBattle.instancedPlayer) as InstancedPlayer;
                if (!instancedPlayer.onDamage(grid.atk))
                {
                    finish(true);
                    return;
                }
            }
            if (procedingGrid != null)
            {
                var nextGrid : ArenaGrid = procedingGrid;
                procedingGrid = null;
                if (nextGrid.size > 0)
                {
                    playerSideWorking = !playerSideWorking;
                    triggerAttack(row, index, nextGrid);
                    return;
                }
            }
            fightOn(row, index + 1);
        }

        public function finish(someGuyDead : Boolean) : void
        {
            battle.switchBackBattle(someGuyDead);
        }
    }
}
