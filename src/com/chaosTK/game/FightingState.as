package com.chaosTK.game
{
    import com.chaosTK.action.ActionMgr;
    import com.chaosTK.animation.FramedAnimationMgr;
    import com.chaosTK.battle.Battle;
    import com.chaosTK.battle.InstancedPlayer;
    import com.chaosTK.battle.controller.BaseAIBattleSideController;
    import com.chaosTK.battle.controller.SimplestAiBattleSideController;
    import com.chaosTK.resource.BattleResMgr;
    import com.chaosTK.resource.Level;
    import com.chaosTK.resource.Player;
    
    import flash.net.getClassByAlias;
    import flash.utils.getDefinitionByName;

    public class FightingState implements GameState
    {
        public function FightingState()
        {
        }

        private var battle : Battle;

        public function start() : void
        {
            var playerController : SimplestAiBattleSideController = new SimplestAiBattleSideController(new InstancedPlayer(Player.instance, true, BattleResMgr.instance.battleDesc.propOfGeneral));
            var otherSideController : BaseAIBattleSideController = new BaseAIBattleSideController(new InstancedPlayer(Level.currentLevel, false, BattleResMgr.instance.battleDesc.propOfGeneral));
			
			var aiclzz : Class = Class(getDefinitionByName(Level.currentLevel.aiClazzName));
			otherSideController.ai = new aiclzz;
			
            battle = new Battle(playerController, otherSideController);

            battle.start();
        }

        public function finish() : void
        {
			ActionMgr.instance.clear();
			FramedAnimationMgr.instance.clear();
            battle.dispose();
        }
    }
}