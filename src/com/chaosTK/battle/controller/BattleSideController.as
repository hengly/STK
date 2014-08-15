package com.chaosTK.battle.controller
{
    import com.chaosTK.battle.Battle;
    import com.chaosTK.battle.BattleSide;
    import com.chaosTK.battle.InstancedPlayer;
    import com.chaosTK.battle.events.ReadyForOperationEvent;
    import com.chaosTK.logic.SLogicModule;
    import com.chaosTK.logic.engineSide;
    import com.chaosTK.util.Disposable;
    import com.chaosTK.util.NotImplementedError;
    import com.chaosTK.util.assert;
	
    public class BattleSideController implements Disposable
    {
        protected var _battleSide : BattleSide;
        protected var _battle : Battle;
        protected var _instancedPlayer : InstancedPlayer;
        protected var availMove : int;

        public function get instancedPlayer() : InstancedPlayer
        {
            return _instancedPlayer;
        }

        public function set battleSide(value : BattleSide) : void
        {
            this._battleSide = value;
        }

        public function get battleSide() : BattleSide
        {
            return _battleSide;
        }

        public function set battle(value : Battle) : void
        {
            this._battle = value;
        }

        public function BattleSideController(instancedPlayer : InstancedPlayer)
        {
            this._instancedPlayer = instancedPlayer;
        }

        protected function onOperationFinished(e : ReadyForOperationEvent) : void
        {
            if (availMove == 0)
            {
                _battle.onEndOfRound(this);
				_battleSide.onHide();
            }
        }

        public function start() : void
        {
            assert(_battle != null && _battleSide != null);
            _battleSide.start();
            _battleSide.registerReadyForOperationListener(onOperationFinished);
        }

        public function dispose() : void
        {
            _battleSide.removeReadyForOperationListener(onOperationFinished);
			_battleSide = null;
			_battle = null;
			_instancedPlayer = null;
        }

		private function setupScriptModule() : void
		{
			SLogicModule.instance.engineSide::battle = _battle;
			SLogicModule.instance.engineSide::myBattleSide = _battleSide;
			SLogicModule.instance.engineSide::isPlayerSide = _instancedPlayer.isPlayerSide;
			if(this._instancedPlayer.isPlayerSide)
			{
				SLogicModule.instance.engineSide::myArenaSide = _battle.getArenaPlayerSide();
				SLogicModule.instance.engineSide::theirBattleSide = _battle.getOtherBattleSide();
				SLogicModule.instance.engineSide::theirArenaSide = _battle.getArenaOtherSide();
			}
			else
			{
				SLogicModule.instance.engineSide::myArenaSide = _battle.getArenaOtherSide();
				SLogicModule.instance.engineSide::theirBattleSide = _battle.getPlayerBattleSide();
				SLogicModule.instance.engineSide::theirArenaSide = _battle.getArenaPlayerSide();
			}
		}
		
        public function startRound() : void
        {
			setupScriptModule();
			_battleSide.onShow();
            availMove = 3;
        }

        protected function operate() : void
        {
            if (!_battleSide.availableForOperation || availMove <= 0)
            {
                return;
            }
            availMove -= 1;
            doOperate();
        }

        protected function doOperate() : void
        {
            throw new NotImplementedError();
        }
    }
}
