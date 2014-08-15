package com.chaosTK.resource
{
    import flash.display.BitmapData;
    import flash.display.BlendMode;
    import flash.filters.ColorMatrixFilter;
    import flash.geom.ColorTransform;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.geom.Vector3D;

    public class AnimationBubble
    {
        private var name : String;
        private var subNameToFrames : Object = new Object();

        public function AnimationBubble(name : String)
        {
            this.name = name;
        }

        public function getAnimationBySubName(subName : String) : Vector.<BitmapData>
        {
            return subNameToFrames[subName]["defaults"];
        }
		public function getAnimationBySubNameAndColor(subName : String, red : Number, green : Number, blue : Number) : Vector.<BitmapData>
		{
			if((red == green) && (green = blue) && (blue == 1.0))
			{
				return getAnimationBySubName(subName);
			}
			var frames : Object = subNameToFrames[subName];
			var identifiler : String = "" + red + green + blue;
			var ret : Vector.<BitmapData> = frames[identifiler] as Vector.<BitmapData>;
			if(ret == null)
			{
				ret = new Vector.<BitmapData>();
				frames[identifiler] = ret;
				var defaults : Vector.<BitmapData> = frames["defaults"];
				for each(var bitmapData : BitmapData in defaults)
				{
					var tmp : BitmapData = new BitmapData(bitmapData.width, bitmapData.height, true, 0x00);
					tmp.draw(bitmapData,null, new ColorTransform(red, green, blue, 1.0), BlendMode.NORMAL);
					ret.push(tmp);
				}
			}
			return ret;
		}
		
        public function addSubFrames(subName : String, frames : Vector.<BitmapData>) : void
        {
            subNameToFrames[subName] = {defaults:frames};
        }
    }
}