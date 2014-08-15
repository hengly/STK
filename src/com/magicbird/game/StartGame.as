package com.chaosTK.game
{
    import br.com.stimuli.loading.BulkLoader;
    import br.com.stimuli.loading.BulkProgressEvent;

    import de.polygonal.ds.LinkedQueue;

    import com.chaosTK.action.ActionMgr;
    import com.chaosTK.animation.FramedAnimationMgr;
    import com.chaosTK.resource.AnimationBubbleMgr;
    import com.chaosTK.resource.FighterInfo;
    import com.chaosTK.resource.FighterInfoDB;
    import com.chaosTK.resource.Player;

    import flash.events.ProgressEvent;

    public class StartGame implements GameState
    {
        private var loader : BulkLoader;

        public function start() : void
        {
            loader = new BulkLoader("commonResources");
            loader.add(GameStateMgr.UserConfigFileName);
            loader.add(GameStateMgr.FighterConfigFileName);
            loader.addEventListener(BulkProgressEvent.PROGRESS, onReadingConfigsProgress);
            loader.addEventListener(BulkProgressEvent.COMPLETE, onReadingConfigsComplete);
            loader.start();
        }

        private function onReadingConfigsProgress(e : ProgressEvent) : void
        {
        }

        private function onReadingConfigsComplete(e : ProgressEvent) : void
        {
            loader.removeEventListener(BulkProgressEvent.COMPLETE, onReadingConfigsComplete);
            loader.removeEventListener(BulkProgressEvent.PROGRESS, onReadingConfigsProgress);
            {
                FighterInfoDB.instance.parse(loader.getText(GameStateMgr.FighterConfigFileName));
                Player.instance.load(loader.getText(GameStateMgr.UserConfigFileName));
            }
            loader.clear();
            loader = null;

            var fighters : Vector.<FighterInfo> = Player.instance.availFighters;
            var loadingAnimationResources : LinkedQueue = new LinkedQueue();
            for each (var fighter : FighterInfo in fighters)
            {
                loadingAnimationResources.enqueue(fighter.animationDesc);
            }
            AnimationBubbleMgr.instance.load(loadingAnimationResources, onPlayerFightersLoaded, onPlayerFightersLoading, true);
        }

        private function onPlayerFightersLoading(e : ProgressEvent) : void
        {
        }

        private function onPlayerFightersLoaded(e : ProgressEvent) : void
        {
            GameStateMgr.instance.switchTo(new SelectLevel());
        }

        public function finish() : void
        {
            FramedAnimationMgr.instance.start(FramedAnimationMgr.TimerInterval);
            ActionMgr.instance.start(ActionMgr.TimerInterval);
        }
    }
}