package com.chaosTK.battle
{
    import com.chaosTK.action.FunctorAction;
    import com.chaosTK.battle.controller.BattleSideController;
    import com.chaosTK.game.FightingState;
    import com.chaosTK.game.GameStateMgr;
    import com.chaosTK.game.Scene;
    import com.chaosTK.resource.BattleDesc;
    import com.chaosTK.resource.BattleResMgr;
    import com.chaosTK.script.SArenaSide;
    import com.chaosTK.script.SBattle;
    import com.chaosTK.script.SBattleSide;
    import com.chaosTK.util.AnchoredSprite;
    import com.chaosTK.util.Disposable;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.geom.Point;

    public class Battle implements Disposable,SBattle
    {
        private const SceneSlideTimeInSec : Number = 1;
        private var _userSideController : BattleSideController;
        private var _otherSideController : BattleSideController;
        private var _playerSideBattle : BattleSide;
        private var _otherSideBattle : BattleSide;
        private var _battleScene : AnchoredSprite = new AnchoredSprite();
        private var _arena : Arena;
		
		public function getArenaPlayerSide() : SArenaSide
		{
			return _arena.playerSideArenaLayout;
		}
		
		public function getArenaOtherSide() : SArenaSide
		{
			return _arena.otherSideArenaLayout;
		}
		
		public function getPlayerBattleSide() : SBattleSide
		{
			return _playerSideBattle;	
		}
		
		public function getOtherBattleSide() : SBattleSide
		{
			return _otherSideBattle;	
		}
		
        public function Battle(operationController : BattleSideController, otherSideController : BattleSideController)
        {
            _userSideController = operationController;
            _otherSideController = otherSideController;
        }

        public function dispose() : void
        {
            try
            {
                for (var i : int = 0; true; i++)
                {
                    battleScene.removeChildAt(i);
                }
            }
            catch(e : Error)
            {
            }
			_userSideController.dispose();
			_otherSideController.dispose();
            _playerSideBattle.dispose();
            _otherSideBattle.dispose();
			
			_battleScene = null;
			_arena = null;
			_otherSideBattle = null;
			_playerSideBattle = null;
			_otherSideController = null;
			_userSideController = null;
        }

        public function get battleScene() : AnchoredSprite
        {
            return _battleScene;
        }

        public function get playerSideBattle() : BattleSide
        {
            return _playerSideBattle;
        }

        public function get otherSideBattle() : BattleSide
        {
            return _otherSideBattle;
        }

        private var cachingContent : BitmapData;
        private var cachingScene : Bitmap;

        public function start() : void
        {
            _arena = new Arena(this);
            _battleScene.addChild(BattleResMgr.instance.battleBackGround);
            cachingContent = new BitmapData(BattleResMgr.instance.battleDesc.width, _battleScene.height, true, 0);
            cachingScene = new Bitmap(cachingContent);
            Scene.instance.clear();
            Scene.instance.setCurrentScene(battleScene);

            _playerSideBattle = new BattleSide(_userSideController.instancedPlayer, this);
            _otherSideBattle = new BattleSide(_otherSideController.instancedPlayer, this);
            _otherSideController.battle = _userSideController.battle = this;
            _otherSideController.battleSide = _otherSideBattle;
            _userSideController.battleSide = _playerSideBattle;

            _userSideController.start();
            _otherSideController.start();

            _battleScene.addChild(_userSideController.battleSide);
            _userSideController.startRound();
        }

        public function switchBackBattle(someGuyDead : Boolean) : void
        {
            if (someGuyDead)
            {
                GameStateMgr.instance.switchTo(new FightingState());
                return;
            }
            Scene.instance.setCurrentScene(_battleScene);
            _playerSideBattle.resetArenaLayout();
            _otherSideBattle.resetArenaLayout();

            _battleScene.addChild(_playerSideBattle);
            _playerSideBattle.alpha = 1.0;
            _battleScene.removeChild(_otherSideBattle);
            _userSideController.startRound();
        }

        public function onEndOfRound(controller : BattleSideController) : void
        {
            var battleDesc : BattleDesc = BattleResMgr.instance.battleDesc;
            var currentController : BattleSideController;
            var prevController : BattleSideController = controller;
            var destPos : Point = new Point();
            if (controller == _userSideController)
            {
                destPos.x = -battleDesc.otherSideStartX + (battleDesc.gridDimensionX * battleDesc.gridSizeX);
                currentController = _otherSideController;
            }
            else
            {
                destPos.x = -battleDesc.playerSideStartX;
                currentController = _userSideController;
            }

            if (currentController == _userSideController)
            {
                _arena.start();
            }
            else
            {
                Scene.fadeTo(prevController.battleSide, currentController.battleSide, _battleScene, SceneSlideTimeInSec, new FunctorAction(function(args : Array) : void
                {
                    args[0]["startRound"]();
                }, currentController));
            }
        }
    }
}