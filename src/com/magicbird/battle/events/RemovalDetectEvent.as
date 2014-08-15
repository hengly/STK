package com.chaosTK.battle.events
{
    import com.chaosTK.battle.LocaledFighter;

    import de.polygonal.ds.Itr;
    import de.polygonal.ds.LinkedDeque;

    import flash.events.Event;

    public class RemovalDetectEvent extends Event
    {
        public static const Type : String = "RemovalDetectEvent";
        [TypeHint(LocaledFighter)]
        private var _removalList : LinkedDeque;

        public function RemovalDetectEvent(removalList : LinkedDeque)
        {
            super(Type);
            _removalList = removalList;
            var str : StringBuf = new StringBuf();
            str.add("remove detected:");
            var itr : Itr = removalList.iterator();
            while (itr.hasNext())
            {
                var fighter : LocaledFighter = itr.next() as LocaledFighter;
                str.add("(" + fighter.battleX + "," + fighter.battleY + ")");
            }
            trace(str);
        }

        public function get removalList() : LinkedDeque
        {
            return _removalList;
        }
    }
}