package com.chaosTK.battle
{
    public class LocaledFighter
    {
        public var fighter : Fighter;
        public var battleX : int;
        public var battleY : int;

        public function LocaledFighter(fighter : Fighter, battleX : int, battleY : int)
        {
            this.fighter = fighter;
            this.battleX = battleX;
            this.battleY = battleY;
        }
    }
}