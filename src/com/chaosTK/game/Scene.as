package com.chaosTK.game
{
    import com.chaosTK.animation.FramedAnimationMgr;
    import com.chaosTK.action.ActionMgr;
    import com.chaosTK.action.FadeoutAction;
    import com.chaosTK.action.FunctorAction;
    import com.chaosTK.action.IAction;
    import com.chaosTK.action.ParalellAction;
    import com.chaosTK.action.SequenceAction;

    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.events.EventDispatcher;

    public class Scene extends EventDispatcher
    {
        private var _mainSprite : Sprite = new Sprite();
        private var _stage : Stage;
        private static const _instance : Scene = new Scene();
        private var _addedToStage : Boolean;

        public static function get instance() : Scene
        {
            return _instance;
        }

        public function get stage() : Stage
        {
            return _stage;
        }

        public function init(stage : Stage, mainSprite : Sprite) : void
        {
            _stage = stage;
            _mainSprite = mainSprite;
        }

        public function clear() : void
        {
            _currentScene = null;
            _mainSprite.graphics.clear();
            try
            {
                for (var i : int = 0; true; i++)
                {
                    _mainSprite.removeChildAt(0);
                }
            }
            catch(e : Error)
            {
                e;
            }
        }

        private var _currentScene : DisplayObject;

        public function setCurrentScene(scene : DisplayObject) : void
        {
            removeCurrentScene();
            _currentScene = scene;
            _mainSprite.addChild(scene);
            if (!_addedToStage)
            {
                _addedToStage = true;
            }
        }

        public function removeCurrentScene() : void
        {
            if (_currentScene != null)
            {
                _mainSprite.removeChild(_currentScene);
            }
            _currentScene = null;
        }

        public static function fadeTo(from : Sprite, to : Sprite, parent : Sprite, timeInsecs : Number, callback : IAction = null) : void
        {
            FramedAnimationMgr.instance.pause();
            from.cacheAsBitmap = true;
            to.cacheAsBitmap = true;
            to.alpha = 0;
            parent.addChild(to);

            var fadeOut : FadeoutAction = new FadeoutAction(timeInsecs, from);
            var fadeIn : FadeoutAction = new FadeoutAction(timeInsecs, to, 1.0);
            var fade : ParalellAction = new ParalellAction().register(fadeOut, fadeIn);
            var fadeEnded : FunctorAction = new FunctorAction(function(args : Array) : void
            {
                args[2]["removeChild"](args[0]);
                args[0]["cacheAsBitmap"] = false;
                args[1]["cacheAsBitmap"] = false;
                 FramedAnimationMgr.instance.resume();
            }, from, to, parent);
            var action : SequenceAction = new SequenceAction().register(fade, fadeEnded);
            if (callback != null)
            {
                action.register(callback);
            }
            ActionMgr.instance.registerAction(action);
        }
    }
}