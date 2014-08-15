package com.chaosTK.resource
{
    import br.com.stimuli.loading.BulkLoader;

    import de.polygonal.ds.Itr;
    import de.polygonal.ds.LinkedQueue;

    import flash.display.BitmapData;
    import flash.errors.IllegalOperationError;
    import flash.events.ProgressEvent;

    public class AnimationBubbleMgr implements ResourceLoadedListener
    {
        private static const _instance : AnimationBubbleMgr = new AnimationBubbleMgr();

        public function AnimationBubbleMgr()
        {
            if (_instance != null)
            {
                throw new IllegalOperationError();
            }
            loadingState = new LoadingState(this);
        }

        public static function get instance() : AnimationBubbleMgr
        {
            return _instance;
        }

        private var persistMode : Boolean;
        private var animationBubblesMap : Object = new Object();
        private var loadingResInfo : LinkedQueue;
        private var loadingState : LoadingState;

        public function getAnimationBubbleByName(name : String) : AnimationBubble
        {
            var ret : AnimationBubbleResHolder = animationBubblesMap[name] as AnimationBubbleResHolder;
            return ret != null ? ret.res : null;
        }

        public function remove(name : String) : void
        {
            delete animationBubblesMap[name];
        }

        private function clear(loadingResInfo : LinkedQueue) : void
        {
            for each (var animationBubble : AnimationBubbleResHolder in animationBubblesMap)
            {
                animationBubble.reffered = false;
            }
            var itr : Itr = loadingResInfo.iterator();
            while (itr.hasNext())
            {
                var resInfo : Object = itr.next();
                var bubbleName : String = resInfo["name"];
                animationBubble = animationBubblesMap[bubbleName] as AnimationBubbleResHolder;
                if (animationBubble != null)
                {
                    animationBubble.reffered = true;
                    itr.remove();
                }
            }
            for (var animationName : String in animationBubblesMap)
            {
                animationBubble = (animationBubblesMap[animationName] as AnimationBubbleResHolder);
                if (!(animationBubble.persist || animationBubble.reffered))
                {
                    delete animationBubblesMap[animationName];
                }
            }
        }

        public function load(loadingResInfo : LinkedQueue, complete : Function, processing : Function = null, persist : Boolean = false) : void
        {
            clear(loadingResInfo);
            if (loadingResInfo.size() == 0)
            {
                complete(null);
                return;
            }
            loadingState.onStart(processing, complete);

            this.loadingResInfo = loadingResInfo;
            persistMode = persist;
            var itr : Itr = this.loadingResInfo.iterator();
            var loader : BulkLoader = new BulkLoader("animationRes");
            while (itr.hasNext())
            {
                var resInfo : Object = itr.next();

                var animations : Array = resInfo["animations"] as Array;
                var bubbleName : String = resInfo["name"];
                for each (var animation : * in animations)
                {
                    var frameCount : int = animation["count"];
                    var prefix : String = bubbleName + "/" + animation["name"];
                    for (var i : int = 0; i < frameCount; i++)
                    {
                        var framePictureName : String = prefix + "/" + i + ".png";
                        loader.add(framePictureName);
                    }
                }
            }
            loadingState.bindLoadingListeners(loader);
            loader.start();
        }

        public function onLoaded(e : ProgressEvent) : void
        {
            var loader : BulkLoader = e.target as BulkLoader;

            var itr : Itr = this.loadingResInfo.iterator();
            while (itr.hasNext())
            {
                var resInfo : Object = itr.next();

                var animations : Array = resInfo["animations"] as Array;
                var bubbleName : String = resInfo["name"];
                var animationBubble : AnimationBubble = new AnimationBubble(bubbleName);
                for each (var animation : * in animations)
                {
                    var frameCount : int = animation["count"];
                    var subFramesName : String = animation["name"];
                    var prefix : String = bubbleName + "/" + subFramesName;
                    var frames : Vector.<BitmapData> = new Vector.<BitmapData>();
                    for (var i : int = 0; i < frameCount; i++)
                    {
                        var framePictureName : String = prefix + "/" + i + ".png";
                        frames.push(loader.getBitmapData(framePictureName, true));
                    }
                    animationBubble.addSubFrames(subFramesName, frames);
                }
                animationBubblesMap[bubbleName] = new AnimationBubbleResHolder(animationBubble, persistMode);
            }
            loadingResInfo.clear(true);
        }
    }
}
import com.chaosTK.resource.AnimationBubble;

class AnimationBubbleResHolder
{
    public var persist : Boolean;
    public var reffered : Boolean;
    public var res : AnimationBubble;

    public function AnimationBubbleResHolder(res : AnimationBubble, persist : Boolean)
    {
        this.res = res;
        this.persist = persist;
        reffered = true;
    }
}