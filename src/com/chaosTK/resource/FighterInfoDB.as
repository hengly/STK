package com.chaosTK.resource
{
    import com.adobe.serialization.json.JSONDecoder;
    import com.adobe.serialization.json.JSONEncoder;

    public class FighterInfoDB
    {
        public function FighterInfoDB()
        {
            if (_instance != null)
            {
                throw new Error();
            }
        }

        private static const _instance : FighterInfoDB = new FighterInfoDB();
        private var fighterInfos : Vector.<FighterInfo> = new Vector.<FighterInfo>();

        public static function get instance() : FighterInfoDB
        {
            return _instance;
        }

        public function parse(configStr : String) : void
        {
            var config : Array = new JSONDecoder(configStr, true).getValue() as Array;
            for (var i : int = 0; i < config.length; i++)
            {
                var fighterInfo : FighterInfo = new FighterInfo(config[i]);
                fighterInfos.push(fighterInfo);
            }
        }

        public function getFighterInfoByID(id : int) : FighterInfo
        {
            return fighterInfos[id];
        }

        public static function writeSample() : String
        {
            var fighterInfo : FighterInfo = new FighterInfo(new Object());
            fighterInfo.isGeneral = true;
            fighterInfo.typeIndex = 1;
            fighterInfo.name = "x";
            fighterInfo.animationDesc = {animations:new Array({count:2, name:"a"}, {count:3, name:"b"}), name:"fucker"};
            return new JSONEncoder(new Array(fighterInfo)).getString();
        }
    }
}