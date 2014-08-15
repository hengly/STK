package com.chaosTK.battle.controller
{
    import de.polygonal.ds.Heapable;

    public class MissionStep implements Heapable
    {
        private var _x : int;
        private var _y : int;
        private var _isHorizontal : Boolean;
        private var _point : int;

        public function get x() : int
        {
            return _x;
        }

        public function get y() : int
        {
            return _y;
        }

        public function get point() : int
        {
            return point;
        }

        public function MissionStep(x : int, y : int, point : int, isHorizontal : Boolean)
        {
            _x = x;
            _y = y;
            _point = point;
            _isHorizontal = isHorizontal;
        }

        public function compare(other : Object) : int
        {
            return _point - (other as MissionStep)._point;
        }
    }
}
