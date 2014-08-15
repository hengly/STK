package com.chaosTK.battle.events
{
    import flash.events.Event;

    public class ReadyForOperationEvent extends Event
    {
        public static const Type : String = "ReadyForOperationEvent";

        public function ReadyForOperationEvent()
        {
            super(Type);
        }
    }
}
