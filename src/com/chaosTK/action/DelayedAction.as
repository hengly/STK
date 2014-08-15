package com.chaosTK.action
{
    public class DelayedAction implements IAction
    {
        private var timeInMills : Number;
        private var startTimeInMills : Number;
        private var endTimeInMills : Number;
        protected var progress : Number;

        public function DelayedAction(timeInSecs : Number)
        {
            timeInMills = timeInSecs * 1000;
        }

        public function start() : void
        {
            startTimeInMills = new Date().time;
            endTimeInMills = timeInMills + startTimeInMills;
            progress = 0;
        }

        public function tick(timeInMills : Number) : Boolean
        {
            progress = (timeInMills - startTimeInMills) / (endTimeInMills - startTimeInMills);
            return (endTimeInMills >= timeInMills);
        }

        public function end() : void
        {
        }
    }
}