package com.chaosTK.util
{
    import flash.events.TimerEvent;
    import flash.utils.Timer;

    public class TimerControler
    {
        private var timer : Timer;

        protected function onTick(e : TimerEvent) : void
        {
            throw new NotImplementedError();
        }

        public function pause() : void
        {
            if (timer != null)
            {
                timer.stop();
                timer.reset();
            }
        }

        public function resume() : void
        {
            if (timer != null)
            {
                timer.start();
            }
        }

        public function start(intervalInMills : Number) : void
        {
            if (timer == null)
            {
                timer = new Timer(intervalInMills);
                timer.addEventListener(TimerEvent.TIMER, onTick);
                timer.start();
            }
            else
            {
                timer.reset();
                timer.start();
            }
        }
    }
}