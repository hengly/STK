package com.chaosTK.battle.events
{
    import flash.events.Event;

    import com.chaosTK.battle.Fighter;

    public class SetFighterEvent extends Event
    {
        public static const Type : String = "SetFighterEvent";
        public var x : int;
        public var y : int;
        public var fighter : Fighter;

        public function SetFighterEvent(x : int, y : int, fighter : Fighter)
        {
            super(Type);
            this.x = x;
            this.y = y;
            this.fighter = fighter;
        }
    }
}
