package com.chaosTK.util
{
    import flash.display.Sprite;

    public class AnchoredSprite extends Sprite
    {
        private var _anchorX : Number = 0;
        private var _anchorY : Number = 0;
        private var _anchorLocX : Number = 0;
        private var _anchorLocY : Number = 0;

        public function get anchorX() : Number
        {
            return _anchorX;
        }

        public function set anchorX(value : Number) : void
        {
            _anchorX = value;
            _anchorLocX = x + (width * _anchorX);
        }

        public function get anchorY() : Number
        {
            return _anchorY;
        }

        public function set anchorY(value : Number) : void
        {
            _anchorY = value;
            _anchorLocY = y + (height * _anchorY);
        }

        public function set anchorLocX(value : Number) : void
        {
            _anchorLocX = value;
            super.x = _anchorLocX - (width * _anchorX);
        }

        public function set anchorLocY(value : Number) : void
        {
            _anchorLocY = value;
            super.y = _anchorLocY - (height * _anchorY);
        }

        public function get anchorLocY() : Number
        {
            return _anchorLocY;
        }

        public function get anchorLocX() : Number
        {
            return _anchorLocX;
        }

        override public function set x(value : Number) : void
        {
            super.x = value;
            _anchorLocX = x + (width * _anchorX);
        }

        override public function set y(value : Number) : void
        {
            super.y = value;
            _anchorLocY = y + (height * _anchorY);
        }

        override public function set scaleX(value : Number) : void
        {
            super.scaleX = value;
            super.x = _anchorLocX - (width * _anchorX);
        }

        override public function set scaleY(value : Number) : void
        {
            super.scaleY = value;
            super.y = _anchorLocY - (height * _anchorY);
        }
    }
}
