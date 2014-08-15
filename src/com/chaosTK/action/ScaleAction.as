package com.chaosTK.action
{
    import com.chaosTK.util.AnchoredSprite;

    import flash.geom.Point;

    import com.chaosTK.util.linearLerp;

    public class ScaleAction extends DelayedAction
    {
        private var target : AnchoredSprite;
        private var destScale : Point;
        private var startScale : Point;
        private var anchorPoint : Point;
        private var startDimention : Point;
        private var lerpFunc : Function;

        public function ScaleAction(timeInSecs : Number, target : AnchoredSprite, destScaleX : Number, destScaleY : Number, lerpFunc : Function = null)
        {
            super(timeInSecs);
            this.target = target;
            this.destScale = new Point(destScaleX, destScaleY);
            this.anchorPoint = anchorPoint;
            this.lerpFunc = lerpFunc == null ? linearLerp : lerpFunc;
        }

        override public function start() : void
        {
            super.start();
            startScale = new Point(target.scaleX, target.scaleY);
            startDimention = new Point(target.width, target.height);
        }

        override public function tick(timeInMills : Number) : Boolean
        {
            var shouldContinue : Boolean = super.tick(timeInMills);
            if (shouldContinue)
            {
                target.scaleX = lerpFunc(progress, startScale.x, destScale.x);
                target.scaleY = lerpFunc(progress, startScale.y, destScale.y);
                return true;
            }
            else
            {
                target.scaleX = lerpFunc(1, startScale.x, destScale.x);
                target.scaleY = lerpFunc(1, startScale.y, destScale.y);
            }
            return false;
        }
    }
}