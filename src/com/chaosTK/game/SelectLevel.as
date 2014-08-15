package com.chaosTK.game
{
    import de.polygonal.ds.LinkedQueue;

    import com.chaosTK.resource.AnimationBubbleMgr;
    import com.chaosTK.resource.BattleResMgr;
    import com.chaosTK.resource.FighterInfo;
    import com.chaosTK.resource.Level;

    import flash.events.Event;
    import flash.events.ProgressEvent;
    import flash.net.URLLoader;
    import flash.net.URLRequest;

    public class SelectLevel implements GameState
    {
        private var selectedLevel : Level;
        private var loadedResourceCount : int;

        public function start() : void
        {
            onLevelSelected(1);
        }

        private function onLevelSelected(level : int) : void
        {
            var levelResourceFilename : String = "level_" + level + ".json";
            var urlLoader : URLLoader = new URLLoader();
            urlLoader.addEventListener(Event.COMPLETE, onLevelResourceFileLoaded);
            urlLoader.load(new URLRequest(levelResourceFilename));
        }

        private function onLevelResourceFileLoaded(e : Event) : void
        {
            var urlLoader : URLLoader = e.target as URLLoader;
            urlLoader.removeEventListener(Event.COMPLETE, onLevelResourceFileLoaded);

            var levelConfig : String = urlLoader.data as String;
            selectedLevel = new Level(levelConfig);

            var fighters : Vector.<FighterInfo> = selectedLevel.availFighters;
            var loadingAnimationResources : LinkedQueue = new LinkedQueue();
            for each (var fighter : FighterInfo in fighters)
            {
                loadingAnimationResources.enqueue(fighter.animationDesc);
            }
            AnimationBubbleMgr.instance.load(loadingAnimationResources, onLevelLoaded, onLevelLoading);
            BattleResMgr.instance.load(selectedLevel.battleDescObject, onLevelLoaded, onLevelLoading);
        }

        private function onLevelLoading(e : ProgressEvent) : void
        {
        }

        private function onLevelLoaded(e : ProgressEvent) : void
        {
            if (++loadedResourceCount == 2)
            {
                GameStateMgr.instance.switchTo(new FightingState());
            }
        }

        public function finish() : void
        {
            Level.currentLevel = selectedLevel;
        }
    }
}