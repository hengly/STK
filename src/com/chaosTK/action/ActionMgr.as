package com.chaosTK.action
{
    import com.chaosTK.game.Scene;
    import com.chaosTK.util.TimerControler;

    import de.polygonal.ds.Itr;
    import de.polygonal.ds.LinkedDeque;

    import flash.events.Event;
    import flash.events.TimerEvent;

    public class ActionMgr extends TimerControler
    {
        private static const _instance : ActionMgr = new ActionMgr();
        public static const TimerInterval : Number = 20;

        public static function get instance() : ActionMgr
        {
            return _instance;
        }

        private var tickingList : LinkedDeque = new LinkedDeque();
        private var newAddedList : LinkedDeque = new LinkedDeque();

        override public function pause() : void
        {
            Scene.instance.stage.removeEventListener(Event.ENTER_FRAME, _tick);
        }

        override public function resume() : void
        {
            Scene.instance.stage.addEventListener(Event.ENTER_FRAME, _tick);
        }

        override public function start(intervalInMills : Number) : void
        {
            intervalInMills;
            Scene.instance.stage.addEventListener(Event.ENTER_FRAME, _tick);
        }

        private function _tick(_ : *) : void
        {
            _;
            var curTimeInMills : Number = new Date().time;
            var itr : Itr = newAddedList.iterator();
            var action : IAction;
            while (itr.hasNext())
            {
                action = (itr.next() as IAction);
                action.start();
                tickingList.pushBack(action);
            }
            newAddedList.clear(true);
            itr = tickingList.iterator();
            while (itr.hasNext())
            {
                action = (itr.next() as IAction);
                if (!action.tick(curTimeInMills))
                {
                    itr.remove();
                }
            }
        }

        public function clear() : void
        {
            tickingList.clear(true);
            newAddedList.clear(true);
        }

        public function registerAction(action : IAction) : void
        {
            newAddedList.pushBack(action);
        }

        override protected function onTick(e : TimerEvent) : void
        {
            _tick(e);
        }
    }
}