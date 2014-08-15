package com.chaosTK.battle.events
{
    import flash.events.Event;
    import flash.utils.Dictionary;

    public class GapDetectedEvent extends Event
    {
        public static const Type : String = "GapDetectedEvent";
        private var _gapMap : Dictionary;

        public function GapDetectedEvent(gapMap : Dictionary)
        {
            super(Type);
            _gapMap = gapMap;
        }

        public function get gapMap() : Dictionary
        {
            return _gapMap;
        }
    }
}
