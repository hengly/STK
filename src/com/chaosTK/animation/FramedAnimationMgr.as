package com.chaosTK.animation
{
    import com.chaosTK.util.TimerControler;

    import de.polygonal.ds.Itr;
    import de.polygonal.ds.LinkedDeque;

    import flash.events.TimerEvent;

    public class FramedAnimationMgr extends TimerControler
    {
        private static const _instance : FramedAnimationMgr = new FramedAnimationMgr();
        public static const TimerInterval : Number = 100;

        public static function get instance() : FramedAnimationMgr
        {
            return _instance;
        }

        private var animatorUpdatingList : LinkedDeque = new LinkedDeque();

        public function clear() : void
        {
            animatorUpdatingList.clear(true);
        }

        override protected function onTick(e : TimerEvent) : void
        {
            var itr : Itr = animatorUpdatingList.iterator();
            var curTimeInMills : Number = new Date().time;
            while (itr.hasNext())
            {
                var animator : FramedAnimator = (itr.next()) as FramedAnimator;
				if(animator.playing)
				{
					if (!animator.tick(curTimeInMills))
					{
						itr.remove();
					}	
				}
            }
        }

        internal function registerTick(animator : FramedAnimator) : void
        {
            animatorUpdatingList.pushBack(animator);
        }
    }
}