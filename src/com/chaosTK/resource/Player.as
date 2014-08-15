package com.chaosTK.resource
{
    import com.adobe.serialization.json.JSONDecoder;
    import com.adobe.serialization.json.JSONEncoder;
    import com.chaosTK.game.AvailFighterContainer;

    public class Player extends AvailFighterContainer
    {
        private var _currentLevel : int;
        private static const _instance : Player = new Player();

        public static function get instance() : Player
        {
            return _instance;
        }

        public function get availFighterIndics() : Vector.<int>
        {
            return _availFighterIndics;
        }

        public function get currentLevel() : int
        {
            return _currentLevel;
        }

        public function set currentLevel(value : int) : void
        {
            _currentLevel = value;
        }

        public function toString() : String
        {
            return new JSONEncoder({level:_currentLevel, fighters:_availFighterIndics}).getString();
        }

        public function load(str : String) : void
        {
            var configObject : Object = new JSONDecoder(str, true).getValue();
            _currentLevel = configObject["level"];
            _life = configObject["life"];
            for each (var fighterConfig : int in configObject["fighters"])
            {
                _availFighterIndics.push(fighterConfig);
            }
        }

        public static function writeSample() : String
        {
            var configObject : Object = new Object();
            configObject["level"] = 1;
            configObject["fighters"] = new Array(1, 2, 3, 4);
            return new JSONEncoder(configObject).getString();
        }
    }
}
