package com.chaosTK.battle
{
    import com.chaosTK.animation.FramedAnimator;
    import com.chaosTK.resource.BattleResMgr;
    import com.chaosTK.resource.FighterInfo;
    import com.chaosTK.script.SFighter;
    
    import flash.geom.ColorTransform;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;

    public class Fighter extends FramedAnimator implements SFighter
    {
        private var _wipeOffIdentifier : int;
        private var colorIndex : int;
        private var _fighterConfig : FighterInfo;
        private var textLayout : TextField;
        private const textFormat : TextFormat = new TextFormat();
        public static var cidx : int;
        public var idx : int;
		
		public function get life() : int
		{
			return _fighterConfig.life;
		}
		
		public function get atk() : int
		{
			return _fighterConfig.atk;
		}
		
		public function get def() : Number
		{
			return _fighterConfig.def;
		}
		
		public function get speed() : int
		{
			return _fighterConfig.speed;
		}
		
        public function Fighter(config : FighterInfo, colorIndex : int, revert : Boolean)
        {
			var colorDesc : * = BattleResMgr.instance.battleDesc.colorArray[colorIndex];
            super(config.name, revert, colorDesc["red"], colorDesc["blue"], colorDesc["green"]);
            _fighterConfig = config;
            _wipeOffIdentifier = config.typeIndex + (BattleResMgr.instance.battleDesc.typeIndexCount * colorIndex);
            this.colorIndex = colorIndex;
            textFormat.font = "Verdana";
            textFormat.size = 20;

            idx = cidx++;
        }

        public function get wipeOffIdentifier() : int
        {
            return _wipeOffIdentifier;
        }

        public function get typeIndex() : int
        {
            return _fighterConfig.typeIndex;
        }

        public function get isGeneral() : Boolean
        {
            return _fighterConfig.isGeneral;
        }

        public function get fighterConfig() : FighterInfo
        {
            return _fighterConfig;
        }

        public function showTextInfo(str : String) : void
        {
            if (textLayout == null)
            {
                textLayout = new TextField();
                textLayout.autoSize = TextFieldAutoSize.LEFT;

                textLayout.defaultTextFormat = (textFormat);
                textLayout.textColor = 0x0ffffA0A0;
                if (!_revert)
                {
                    textLayout.x = -10;
                }
                addChild(textLayout);
            }
            textLayout.text = str;
        }
    }
}