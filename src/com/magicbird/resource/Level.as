package com.chaosTK.resource
{
    import com.adobe.serialization.json.JSONDecoder;
    import com.adobe.serialization.json.JSONEncoder;
    import com.chaosTK.game.AvailFighterContainer;

    public class Level extends AvailFighterContainer
    {
        private var name : String;
		private var _aiClazz : String;
        private var _battleDescObject : Object;
        private static var _currentLevel : Level;
		
		public function get aiClazzName() : String
		{
			return _aiClazz;
		}
		
        public static function get currentLevel() : Level
        {
            return _currentLevel;
        }

        public static function set currentLevel(value : Level) : void
        {
            _currentLevel = value;
        }

        public function Level(config : String)
        {
            var configObject : * = new JSONDecoder(config, true).getValue();
            name = configObject["name"];
			_aiClazz = configObject["ai"];
            _life = configObject["life"];
            for each (var i : int in configObject["availFighterIndices"])
            {
                _availFighterIndics.push(i);
            }
            _battleDescObject = configObject["battle"];
        }

        public function get battleResName() : String
        {
            return name;
        }

        public function get battleDescObject() : Object
        {
            return _battleDescObject;
        }

        public static function writeSample() : String
        {
            var obj : Object = new Object();
            obj["name"] = "x";
            obj["availFighterIndices"] = new Array(1, 2, 3);

            var battleDesc : BattleDesc = new BattleDesc(new Object());
            battleDesc.colorArray = new Array({red:1.0, blue:1.0, green:1.0});
            obj["battleDesc"] = battleDesc;
            obj["background"] = "background.jpg";

            return new JSONEncoder(obj).getString();
        }
    }
}