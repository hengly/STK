package com.chaosTK.battle
{
    import com.chaosTK.action.ActionMgr;
    import com.chaosTK.action.FadeoutAction;
    import com.chaosTK.action.FunctorAction;
    import com.chaosTK.action.MoveAction;
    import com.chaosTK.action.ParalellAction;
    import com.chaosTK.action.SequenceAction;
    import com.chaosTK.battle.events.GapDetectedEvent;
    import com.chaosTK.battle.events.ReadyForOperationEvent;
    import com.chaosTK.battle.events.RemovalDetectEvent;
    import com.chaosTK.resource.BattleDesc;
    import com.chaosTK.resource.BattleResMgr;
    import com.chaosTK.script.SBattleSide;
    import com.chaosTK.script.SFighter;
    import com.chaosTK.script.SInstancedPlayer;
    import com.chaosTK.util.AnchoredSprite;
    import com.chaosTK.util.Disposable;
    import com.chaosTK.util.LinkedUniqIdentifierSet;
    import com.chaosTK.util.Random;
    
    import de.polygonal.ds.Itr;
    import de.polygonal.ds.LinkedDeque;
    
    import flash.geom.Point;
    import flash.utils.Dictionary;

    public class BattleSide extends AnchoredSprite implements Disposable, SBattleSide
    {
        private static const MovalDelayInSecs : Number = 0.5;
        private static const DisappearDelayInSecs : Number = 0.5;
        private var _fighterLayout : FightersLayout;
        private var _arenaLayout : ArenaSideLayout;
        private var _instancedPlayer : InstancedPlayer;
        private var _locationCaculator : BattleLocationCaculator;
        private var battleState : BattleState = new BattleState();
        private var battle : Battle;
        private var additionalTestPoint : LinkedDeque = new LinkedDeque();
		
		public function getFighter(x : int, y : int) : SFighter
		{
			return _fighterLayout.getFighter(x, y);
		}
		
        public function get instancedPlayer() : SInstancedPlayer
        {
            return _instancedPlayer;
        }

        public function get arenaLayout() : ArenaSideLayout
        {
            return _arenaLayout;
        }

        public function get availableForOperation() : Boolean
        {
            return battleState.current == BattleState.IDLE;
        }

        public function BattleSide(instancedPlayer : InstancedPlayer, battle : Battle)
        {
            _fighterLayout = new FightersLayout(instancedPlayer, battle);

            this._instancedPlayer = instancedPlayer;
            var battleDesc : BattleDesc = BattleResMgr.instance.battleDesc;
            if (instancedPlayer.isPlayerSide)
            {
                _locationCaculator = new PlayerSideLocationCaculator(battleDesc.playerSideStartX, battleDesc.playerSideStartY);
            }
            else
            {
                _locationCaculator = new OtherSideLocationCaculator(battleDesc.otherSideStartX, battleDesc.otherSideStartY);
            }

            _arenaLayout = new ArenaSideLayout(instancedPlayer.isPlayerSide, _locationCaculator);
            resetArenaLayout();

            fighterLayout.addEventListener(RemovalDetectEvent.Type, onRemovalDetected);
            fighterLayout.addEventListener(GapDetectedEvent.Type, onGapDetected);
            this.battle = battle;
        }

        public function resetArenaLayout() : void
        {
            var arenaLayoutPos : Point = _locationCaculator.areanStartPoint;
            _arenaLayout.x = arenaLayoutPos.x;
            _arenaLayout.y = arenaLayoutPos.y;
            addChild(_arenaLayout);
        }
		
		public function onShow() : void
		{
			fighterLayout.foreach(function(fighter : Fighter, x : int, y : int) : Fighter{
				fighter.resume();
				return fighter;
			});
		}
		
		public function onHide() : void
		{
			fighterLayout.foreach(function(fighter : Fighter, x : int, y : int) : Fighter{
				fighter.pause();
				return fighter;
			});
		}
		
        public function registerReadyForOperationListener(listner : Function) : void
        {
            battleState.addEventListener(ReadyForOperationEvent.Type, listner);
        }

        public function removeReadyForOperationListener(listner : Function) : void
        {
            battleState.removeEventListener(ReadyForOperationEvent.Type, listner);
        }

        public function get locationCaculator() : BattleLocationCaculator
        {
            return _locationCaculator;
        }

        private function placeFighter(fighter : Fighter, x : int, y : int) : Fighter
        {
            var location : Point = locationCaculator.toSpriteLocation(x, y);
            fighter.x = location.x;
            fighter.y = location.y;
            fighter.play("idle");
			fighter.pause();
            this.addChild(fighter);
            return fighter;
        }

        public function start() : void
        {
            _fighterLayout.fill();
            _fighterLayout.foreach(placeFighter);
        }

        public function get fighterLayout() : FightersLayout
        {
            return _fighterLayout;
        }

        public function move(x1 : int, y1 : int, x2 : int, y2 : int) : void
        {
            if (Math.abs(x1 - x2) + Math.abs(y1 - y2) != 1)
            {
                return;
            }
            var fighter1 : Fighter = fighterLayout.getFighter(x1, y1);
            var fighter2 : Fighter = fighterLayout.getFighter(x2, y2);

            var spriteLocation1 : Point = locationCaculator.toSpriteLocation(x1, y1);
            var spriteLocation2 : Point = locationCaculator.toSpriteLocation(x2, y2);

            var move1 : MoveAction = new MoveAction(MovalDelayInSecs, fighter1, spriteLocation2.x, spriteLocation2.y);
            var move2 : MoveAction = new MoveAction(MovalDelayInSecs, fighter2, spriteLocation1.x, spriteLocation1.y);
            var parallelMove : ParalellAction = new ParalellAction();
            parallelMove.register(move1, move2);

            var callSwapOnBattleSide : FunctorAction = new FunctorAction(function(args : Array) : void
            {
                fighterLayout.swap(args[0], args[1], args[2], args[3]);
            }, x1, y1, x2, y2);

            var endOfMove : FunctorAction = new FunctorAction(onEndOfMove);
            var actions : SequenceAction = new SequenceAction();

            battleState.switchTo(BattleState.MOVING);
            actions.register(parallelMove, callSwapOnBattleSide, endOfMove);
            ActionMgr.instance.registerAction(actions);
        }

        private function onEndOfMove(_ : Array) : void
        {
            _;
            battleState.switchToIdle(BattleState.MOVING);
        }

        private function addToArenaLayout(removalList : LinkedDeque) : void
        {
            var itr : Itr = removalList.iterator();
            while (itr.hasNext())
            {
                var fighter : LocaledFighter = (itr.next() as LocaledFighter);
                _arenaLayout.addFighter(fighter.battleY, fighter.fighter.typeIndex, fighter.fighter);
            }
        }

        private function processRemovalList(removalList : LinkedDeque) : void
        {
            battleState.switchTo(BattleState.REMOVING);
            var fadeOutActions : ParalellAction = new ParalellAction();
            var itr : Itr = removalList.iterator();
            while (itr.hasNext())
            {
                var fighter : Fighter = (itr.next() as LocaledFighter).fighter;
                fadeOutActions.register(new FadeoutAction(DisappearDelayInSecs, fighter));
            }
            var removeFighters : FunctorAction = new FunctorAction(function(args : Array) : void
            {
                fighterLayout.remove(args[0]);
                addToArenaLayout(args[0]);
                onEndOfRemoval();
            }, removalList);

            var removeFromSceen : FunctorAction = new FunctorAction(function(args : Array) : void
            {
                args;
                var itr : Itr = removalList.iterator();
                while (itr.hasNext())
                {
                    var itrfighrer : LocaledFighter = (itr.next() as LocaledFighter);
                    removeChild(itrfighrer.fighter);
                }
            }, removalList);

            var actions : SequenceAction = new SequenceAction();
            actions.register(fadeOutActions, removeFromSceen, removeFighters);
            ActionMgr.instance.registerAction(actions);
        }

        private function onRemovalDetected(e : RemovalDetectEvent) : void
        {
            var removalList : LinkedDeque = e.removalList;
            processRemovalList(removalList);
        }

        private function onEndOfRemoval() : void
        {
            battleState.switchToIdle(BattleState.REMOVING);
        }

        private function supplyNewFighters(gapMap : Dictionary, moveActions : ParalellAction) : void
        {
            var wippedIndexCount : int = BattleResMgr.instance.battleDesc.wippedIndexCount;
            for (var idxRow : * in gapMap)
            {
                var gapInfo : GapInfo = gapMap[idxRow] as GapInfo;
                for (var i : int = 0; i < gapInfo.movalGrid; i++)
                {
                    var idxCol : int = gapInfo.movalGrid - 1 - i;
                    var idxType : int;
                    var tryCount : int = 20;
                    do
                    {
                        idxType = Random.nextInt(wippedIndexCount);
                        tryCount -= 1;
                    }
                    while (tryCount > 0 && !fighterLayout.isValidPlacing(idxCol, idxRow, idxType));
                    if (tryCount < 0)
                    {
                        additionalTestPoint.pushBack(new IntPoint(idxCol, idxRow));
                    }

                    var fighter : Fighter = (instancedPlayer as InstancedPlayer).createFighter(idxType);
                    fighter.play("idle");
                    this.addChild(fighter);
                    var tmpPos : Point = _locationCaculator.toSpriteLocation(-1 - i, idxRow, false);
                    fighter.x = tmpPos.x;
                    fighter.y = tmpPos.y;
                    tmpPos = _locationCaculator.toSpriteLocation(idxCol, idxRow);
                    var move : MoveAction = new MoveAction(MovalDelayInSecs, fighter, tmpPos.x, tmpPos.y);
                    moveActions.register(move);

                    fighterLayout.setFighter(idxCol, idxRow, fighter);
                }
            }
        }

        private function getIdentifierByRowCols(object : LocaledFighter) : int
        {
            return object.battleY * BattleResMgr.instance.battleDesc.gridDimensionX + object.battleX;
        }

        private function testMerge(merginNodes : Dictionary) : void
        {
            var mergedQueue : LinkedUniqIdentifierSet = new LinkedUniqIdentifierSet(getIdentifierByRowCols);
            for (var idx : * in merginNodes)
            {
                if (!mergedQueue.containsKey(idx))
                {
                    var pos : IntPoint = merginNodes[idx] as IntPoint;
                    fighterLayout.tryMergeAtPos(pos.x, pos.y, mergedQueue);
                }
            }
            var itrAditionaCheckList : Itr = additionalTestPoint.iterator();
            while (itrAditionaCheckList.hasNext())
            {
                pos = itrAditionaCheckList.next() as IntPoint;
                fighterLayout.tryMergeAtPos(pos.x, pos.y, mergedQueue);
            }
            additionalTestPoint.clear(true);

            if (mergedQueue.size() > 0)
            {
                processRemovalList(mergedQueue.asLinkedDeque());
            }
        }

        private function onGapDetected(e : GapDetectedEvent) : void
        {
            battleState.switchTo(BattleState.SUPPLYING);
            var alligningActions : ParalellAction = new ParalellAction();
            var setPosActions : ParalellAction = new ParalellAction();
            var checkingList : Dictionary = new Dictionary();
            var battleDesc : BattleDesc = BattleResMgr.instance.battleDesc;

            for (var idxRow : * in e.gapMap)
            {
                var gapInfo : GapInfo = e.gapMap[idxRow] as GapInfo;
                var fighter : Fighter;
                var move : MoveAction;
                var setPos : FunctorAction;
                var itrMovalInfo : Itr = gapInfo.movalInfo.iterator();
                while (itrMovalInfo.hasNext())
                {
                    var moveInfo : GapRow = itrMovalInfo.next() as GapRow;
                    fighter = fighterLayout.getFighter(moveInfo.idx, idxRow) as Fighter;
                    var destPos : Point = locationCaculator.toSpriteLocation(moveInfo.idx + moveInfo.step, idxRow);
                    move = new MoveAction(MovalDelayInSecs, fighter, destPos.x, destPos.y);
                    alligningActions.register(move);

                    setPos = new FunctorAction(function(args : Array) : void
                    {
                        fighterLayout.setFighter(args[0], args[1], args[2]);
                    }, moveInfo.idx + moveInfo.step, idxRow, fighter);
                    setPosActions.register(setPos);

                    checkingList[idxRow * battleDesc.gridDimensionX + moveInfo.idx + moveInfo.step] = new IntPoint(moveInfo.idx + moveInfo.step, idxRow);
                }
            }
            var supplyingNewActions : FunctorAction = new FunctorAction(function(args : Array) : void
            {
                supplyNewFighters(args[0], args[1]);
            }, e.gapMap, alligningActions);

            var testMergeAction : FunctorAction = new FunctorAction(function(args : Array) : void
            {
                testMerge(args[0]);
                battleState.switchToIdle(BattleState.SUPPLYING);
            }, checkingList);

            var actions : SequenceAction = new SequenceAction();
            actions.register(setPosActions, supplyingNewActions, alligningActions, testMergeAction);
            ActionMgr.instance.registerAction(actions);
        }

        public function dispose() : void
        {
            fighterLayout.removeEventListener(RemovalDetectEvent.Type, onRemovalDetected);
            fighterLayout.removeEventListener(GapDetectedEvent.Type, onGapDetected);
			
			_fighterLayout = null;
			_arenaLayout.dispose();
			_arenaLayout = null;
			_instancedPlayer = null;
			_locationCaculator = null;
			battle = null;
			additionalTestPoint.clear(true);
        }
    }
}
import com.chaosTK.util.assert;
import com.chaosTK.battle.events.ReadyForOperationEvent;

import flash.events.EventDispatcher;

class BattleState extends EventDispatcher
{
    internal static const IDLE : int = 0;
    internal static const MOVING : int = 1;
    internal static const REMOVING : int = 2;
    internal static const SUPPLYING : int = 3;
    internal var current : int = 0;

    internal function switchToIdle(from : int) : void
    {
        if (current == from)
        {
            current = IDLE;
            dispatchEvent(new ReadyForOperationEvent());
        }
    }

    internal function switchTo(state : int) : void
    {
        assert(state != IDLE);

        if (current == state - 1 || current == SUPPLYING || (state == REMOVING))
        {
            current = state;
        }
        else
        {
            assert(false);
        }
    }
}
class IntPoint
{
    internal var x : int;
    internal var y : int;

    public function IntPoint(x : int, y : int)
    {
        this.x = x;
        this.y = y;
    }
}