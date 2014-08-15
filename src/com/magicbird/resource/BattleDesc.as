package com.chaosTK.resource
{
    public class BattleDesc extends ObjectSerialable
    {
        public var gridSizeX : int;
        public var gridSizeY : int;
        public var gridDimensionX : int;
        public var gridDimensionY : int;
        public var playerSideStartX : int;
        public var playerSideStartY : int;
        public var otherSideStartX : int;
        public var otherSideStartY : int;
        public var colorCount : int;
        public var typeIndexCount : int;
        public var propOfGeneral : Number;

        public function get wippedIndexCount() : int
        {
            return colorCount * typeIndexCount;
        }

        public var colorArray : Array;

        public function BattleDesc(obj : Object)
        {
            super(obj);
        }

        public function get width() : int
        {
            return (gridSizeX * gridDimensionX) + otherSideStartX;
        }
    }
}
