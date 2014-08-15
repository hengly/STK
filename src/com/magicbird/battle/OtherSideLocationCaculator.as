package com.chaosTK.battle
{
    import com.chaosTK.resource.BattleResMgr;

    import flash.geom.Point;

    public class OtherSideLocationCaculator extends BattleLocationCaculator
    {
        protected var typeIndexCount : int;

        public function OtherSideLocationCaculator(startX : Number, startY : Number)
        {
            super(startX, startY);
            typeIndexCount = BattleResMgr.instance.battleDesc.typeIndexCount;
        }

        override public function toGridLocation(x : Number, y : Number, check : Boolean = true) : Point
        {
            var ret : Point = new Point();
            ret.x = int((startX - x) / gridSizeX);
            ret.y = int((y - startY) / gridSizeY);
            if (check)
            {
                if (ret.x < 0 || ret.y < 0 || ret.x >= gridDimensionX || ret.y >= gridDimensionY)
                {
                    return null;
                }
            }
            return ret;
        }

        override public function toSpriteLocation(x : int, y : int, check : Boolean = true) : Point
        {
            if (check)
            {
                if (x < 0 || y < 0 || x >= gridDimensionX || y >= gridDimensionY)
                {
                    return null;
                }
            }
            var ret : Point = new Point();
            ret.x = startX - (x * gridSizeX);
            ret.y = (y * gridSizeY) + startY;
            return ret;
        }

        override public function toArenaLocation(y : int, typeIndex : int) : Point
        {
            if (y < 0 || y >= gridDimensionY)
            {
                return null;
            }
            var ret : Point = new Point();
            ret.y = (y * gridSizeY);
            ret.x = ((typeIndexCount - typeIndex - 1) * gridSizeX);
            return ret;
        }

        override public function get areanStartPoint() : Point
        {
            var ret : Point = new Point();
            ret.x = startX - ((BattleResMgr.instance.battleDesc.gridDimensionX + BattleResMgr.instance.battleDesc.typeIndexCount + 1) * gridSizeX);
            ret.y = 0;
            return ret;
        }
    }
}