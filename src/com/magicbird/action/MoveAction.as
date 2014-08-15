package com.chaosTK.action
{
    import com.chaosTK.battle.Fighter;
    import com.chaosTK.util.linearLerp;

    import flash.display.DisplayObject;

    public class MoveAction extends DelayedAction
    {
        private var target : DisplayObject;
        private var destX : Number;
        private var destY : Number;
        private var startX : Number;
        private var startY : Number;
        private var lerpFunc : Function;

        public function MoveAction(timeInSecs : Number, target : DisplayObject, destX : Number, destY : Number, lerpFunc : Function = null)
        {
            super(timeInSecs);
            this.target = target;
            this.destX = destX;
            this.destY = destY;
            this.lerpFunc = lerpFunc == null ? linearLerp : lerpFunc;
        }

        override public function start() : void
        {
            super.start();
            if (target is Fighter)
            {
                (target as Fighter).pause();
            }
            startX = target.x;
            startY = target.y;
        }

        override public function tick(timeInMills : Number) : Boolean
        {
            var shouldContinue : Boolean = super.tick(timeInMills);
            if (shouldContinue)
            {
                var x : Number = lerpFunc(progress, startX, destX);
                var y : Number = lerpFunc(progress, startY, destY);
                target.x = x;
                target.y = y;
                return true;
            }
            else
            {
                target.x = lerpFunc(1, startX, destX);
                target.y = lerpFunc(1, startY, destY);
                if (target is Fighter)
                {
                    (target as Fighter).resume();
                }
            }
            return false;
        }
    }
}