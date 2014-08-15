package com.chaosTK.game
{
    import com.chaosTK.resource.FighterInfo;
    import com.chaosTK.resource.FighterInfoDB;

    public class AvailFighterContainer
    {
        protected var _availFighterIndics : Vector.<int> = new Vector.<int>();
        protected var _availFighters : Vector.<FighterInfo>;
        protected var _life : int;

        public function AvailFighterContainer()
        {
        }

        public function get availFighters() : Vector.<FighterInfo>
        {
            if (_availFighters == null)
            {
                _availFighters = new Vector.<FighterInfo>();
                for (var i : int = 0; i < _availFighterIndics.length; i++)
                {
                    _availFighters.push(FighterInfoDB.instance.getFighterInfoByID(_availFighterIndics[i]));
                }
            }
            return _availFighters;
        }

        public function get life() : int
        {
            return _life;
        }
    }
}