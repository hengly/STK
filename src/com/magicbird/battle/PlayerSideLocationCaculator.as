package com.chaosTK.battle
{
    import com.chaosTK.resource.BattleResMgr;

    import flash.geom.Point;

    public class PlayerSideLocationCaculator extends BattleLocationCaculator
    {
        public function PlayerSideLocationCaculator(startX : Number, startY : Number)
        {
            super(startX, startY);
        }

        override public function toGridLocation(x : Number, y : Number, check : Boolean = true) : Point
        {
            var ret : Point = new Point();
            ret.x = int((x - startX) / gridSizeX);
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
            ret.x = (x * gridSizeX) + startX;
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
            ret.x = startX + ((typeIndex) * gridSizeX);
            return ret;
        }

        override public function get areanStartPoint() : Point
        {
            var ret : Point = new Point();
            ret.x = ((BattleResMgr.instance.battleDesc.gridDimensionX + 2) * gridSizeX) + startX;
            ret.y = 0;
            return ret;
        }
    }
}