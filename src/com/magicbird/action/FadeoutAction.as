package com.chaosTK.action
{
    import com.chaosTK.action.DelayedAction;
    import com.chaosTK.util.linearLerp;

    import flash.display.DisplayObject;

    public class FadeoutAction extends DelayedAction
    {
        private var target : DisplayObject;
        private var lerpFunc : Function;
        private var fromAlpha : Number;
        private var toAlpha : Number;

        public function FadeoutAction(timeInSecs : Number, target : DisplayObject, toAlpha : Number = 0.0, lerpFunc : Function = null)
        {
            super(timeInSecs);
            this.target = target;
            this.lerpFunc = lerpFunc == null ? linearLerp : lerpFunc;
            this.toAlpha = toAlpha;
        }

        override public function start() : void
        {
            super.start();
            this.fromAlpha = target.alpha;
        }

        override public function tick(timeInMills : Number) : Boolean
        {
            var shouldContinue : Boolean = super.tick(timeInMills);
            if (shouldContinue)
            {
                target.alpha = lerpFunc(progress, fromAlpha, toAlpha);
                return true;
            }
            else
            {
                target.alpha = toAlpha;
            }
            return false;
        }
    }
}
