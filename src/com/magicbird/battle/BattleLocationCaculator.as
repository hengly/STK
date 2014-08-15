package com.chaosTK.battle
{
    import com.chaosTK.resource.BattleDesc;
    import com.chaosTK.resource.BattleResMgr;
    import com.chaosTK.util.NotImplementedError;

    import flash.geom.Point;

    public class BattleLocationCaculator
    {
        protected var gridSizeX : Number;
        protected var gridSizeY : Number;
        protected var gridDimensionX : int;
        protected var gridDimensionY : int;
        protected var startX : Number;
        protected var startY : Number;

        public function BattleLocationCaculator(startX : Number, startY : Number)
        {
            this.startX = startX;
            this.startY = startY;
            var battleDesc : BattleDesc = BattleResMgr.instance.battleDesc;
            gridSizeX = battleDesc.gridSizeX;
            gridSizeY = battleDesc.gridSizeY;
            gridDimensionX = battleDesc.gridDimensionX;
            gridDimensionY = battleDesc.gridDimensionY;
        }

        public function toSpriteLocation(x : int, y : int, check : Boolean = true) : Point
        {
            throw new NotImplementedError();
        }

        public function toGridLocation(x : Number, y : Number, check : Boolean = true) : Point
        {
            throw new NotImplementedError();
        }

        public function toArenaLocation(y : int, typeIndex : int) : Point
        {
            throw new NotImplementedError();
        }

        public function get areanStartPoint() : Point
        {
            throw new NotImplementedError();
        }
    }
}