package com.chaosTK.resource
{
	import com.chaosTK.script.SFighterInfo;

    public class FighterInfo extends ObjectSerialable implements SFighterInfo
    {
        private var _name : String;
        private var _typeIndex : int;
        private var _isGeneral : Boolean;
        private var _animationDesc : Object;
        private var _life : int;
        private var _atk : int;
        private var _def : Number;
        private var _speed : int;

		public function get speed():int
		{
			return _speed;
		}

		public function set speed(value:int):void
		{
			_speed = value;
		}

		public function get def():Number
		{
			return _def;
		}

		public function set def(value:Number):void
		{
			_def = value;
		}

		public function get atk():int
		{
			return _atk;
		}

		public function set atk(value:int):void
		{
			_atk = value;
		}

		public function get life():int
		{
			return _life;
		}

		public function set life(value:int):void
		{
			_life = value;
		}

        public function get isGeneral() : Boolean
        {
            return _isGeneral;
        }

        public function set isGeneral(value : Boolean) : void
        {
            _isGeneral = value;
        }

        public function get typeIndex() : int
        {
            return _typeIndex;
        }

        public function set typeIndex(value : int) : void
        {
            _typeIndex = value;
        }

        public function get name() : String
        {
            return _name;
        }

        public function set name(value : String) : void
        {
            _name = value;
        }

        public function get animationDesc() : Object
        {
            return _animationDesc;
        }

        public function set animationDesc(value : Object) : void
        {
            _animationDesc = value;
        }

        public function FighterInfo(obj : Object)
        {
            super(obj);
        }
    }
}