package com.chaosTK.battle.controller
{
    import com.chaosTK.battle.Fighter;
    import com.chaosTK.battle.InstancedPlayer;
    import com.chaosTK.battle.controller.BattleSideController;
    import com.chaosTK.battle.events.ReadyForOperationEvent;
    import com.chaosTK.battle.events.SetFighterEvent;
    import com.chaosTK.logic.AI;
    import com.chaosTK.logic.SLogicModule;
    import com.chaosTK.logic.engineSide;
    import com.chaosTK.resource.BattleDesc;
    import com.chaosTK.resource.BattleResMgr;
    import com.chaosTK.script.SController;
    
    import de.polygonal.ds.Array2;

    public class BaseAIBattleSideController extends BattleSideController implements SController
    {
        protected var fighterTypeMirror : Array2;
        private var _w : int;
        private var _h : int;
		private var _ai : AI;
		
        public function BaseAIBattleSideController(instancedPlayer : InstancedPlayer)
        {
            super(instancedPlayer);
        }
		
		public function set ai(value : AI) : void
		{
			_ai = value;
		}
		
		public function get ai() : AI
		{
			return _ai;
		}
		
		public function get h():int
		{
			return _h;
		}

		public function set h(value:int):void
		{
			_h = value;
		}

		public function get w():int
		{
			return _w;
		}

		public function set w(value:int):void
		{
			_w = value;
		}

        private function onSetFighter(fighter : Fighter, x : int, y : int) : Fighter
        {
            fighterTypeMirror.set(x, y, fighter != null ? fighter.wipeOffIdentifier : -1);
            return fighter;
        }

        private function onReceiveSetFighterEvent(e : SetFighterEvent) : void
        {
            onSetFighter(e.fighter, e.x, e.y);
        }

        override public function start() : void
        {
            super.start();
            var battleDesc : BattleDesc = BattleResMgr.instance.battleDesc;
            fighterTypeMirror = new Array2(battleDesc.gridSizeX, battleDesc.gridSizeY);
            _battleSide.fighterLayout.foreach(onSetFighter);
            _battleSide.fighterLayout.addEventListener(SetFighterEvent.Type, onReceiveSetFighterEvent);
            w = battleDesc.gridDimensionX;
            h = battleDesc.gridDimensionY;
        }

        override public function startRound() : void
        {
            super.startRound();
			SLogicModule.instance.engineSide::controller = this;
            doOperate();
        }

        override public function dispose() : void
        {
            _battleSide.fighterLayout.removeEventListener(SetFighterEvent.Type, onReceiveSetFighterEvent);
            super.dispose();
        }

        override protected function onOperationFinished(e : ReadyForOperationEvent) : void
        {
            super.onOperationFinished(e);
            if (availMove > 0)
            {
                operate();
            }
        }
		
		override protected function doOperate() : void
		{
			if(_ai != null)
			{
				availMove = ai.operate(availMove);
			}
			else
			{
				super.doOperate();
			}
		}
		
		private function isValidPlacing(x : int, y : int) : Boolean
		{
			var type : int = fighterTypeMirror.get(x, y) as int;
			var start : int = y - 1;
			while (start >= 0 && (fighterTypeMirror.get(x, start) == type))
			{
				start -= 1;
			}
			start += 1;
			
			var end : int = y + 1;
			while (end < h && (fighterTypeMirror.get(x, end) == type))
			{
				end += 1;
			}
			if (end - start > 2)
			{
				return false;
			}
			start = x - 1;
			while (start >= 0 && (fighterTypeMirror.get(start, y) == type))
			{
				start -= 1;
			}
			start += 1;
			
			end = x + 1;
			while (end < w && (fighterTypeMirror.get(end, y) == type))
			{
				end += 1;
			}
			return (end - start > 2);
		}

		public function tryMove(x : int, y : int, isVertical : Boolean) : Boolean
		{
			var ret : Boolean = false;
			var destX : int;
			var destY : int;
			if (isVertical)
			{
				destX = x;
				destY = y + 1;
			}
			else
			{
				destX = x + 1;
				destY = y;
			}
			var t : int = fighterTypeMirror.get(x, y) as int;
			fighterTypeMirror.set(x, y, fighterTypeMirror.get(destX, destY));
			fighterTypeMirror.set(destX, destY, t);
			
			if (isValidPlacing(x, y) || isValidPlacing(destX, destY))
			{
				ret = true;
			}
			
			t = fighterTypeMirror.get(x, y) as int;
			fighterTypeMirror.set(x, y, fighterTypeMirror.get(destX, destY));
			fighterTypeMirror.set(destX, destY, t);
			
			if (ret)
			{
				_battleSide.move(x, y, destX, destY);
			}
			return ret;
		}
    }
}
