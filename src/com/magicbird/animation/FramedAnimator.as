package com.chaosTK.animation
{
    import com.chaosTK.resource.AnimationBubble;
    import com.chaosTK.resource.AnimationBubbleMgr;
    import com.chaosTK.util.AnchoredSprite;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;

    public class FramedAnimator extends AnchoredSprite
    {
        private var index : int;
        private var autoReplay : Boolean;
        private var frames : Vector.<BitmapData>;
        private var animationName : String;
        private var _playing : Boolean;
        private var bitmap : Bitmap;
        protected  var _revert : Boolean;
        private var animationBubble : com.chaosTK.resource.AnimationBubble;
		
		private var _redMask : Number;
		private var _blueMask : Number;
		private var _greenMask : Number;
		
        public function FramedAnimator(name : String, revert : Boolean, redMask : Number = 1.0, blueMask : Number = 1.0, greenMask : Number = 1.0)
        {
            super();
            this.name = name;
            this._revert = revert;
            animationBubble = AnimationBubbleMgr.instance.getAnimationBubbleByName(name);
			
			_redMask = redMask;
			_blueMask = blueMask;
			_greenMask = greenMask;
        }

		public function get playing():Boolean
		{
			return _playing;
		}

        public function get revert() : Boolean
        {
            return _revert;
        }
		
		public function removeColorMask() : void
		{
			_redMask = 1.0;
			_blueMask = 1.0;
			_greenMask = 1.0;
			frames = animationBubble.getAnimationBySubName(animationName);
		}
		
        public function play(animationName : String, autoReplay : Boolean = true, forceRestat : Boolean = true) : void
        {
            if (this.animationName == animationName)
            {
                if (!playing)
                {
                    FramedAnimationMgr.instance.registerTick(this);
                    _playing = true;
                }
                if (forceRestat)
                {
                    index = 0;
                }
                return;
            }
            this.animationName = animationName;
            frames = animationBubble.getAnimationBySubNameAndColor(animationName, _redMask, _blueMask, _greenMask);
            this.autoReplay = autoReplay;
            index = 0;
            _playing = true;
            if (bitmap == null)
            {
                bitmap = new Bitmap();
                if (_revert)
                {
                    bitmap.scaleX = -1;
                }
                addChild(bitmap);
            }
            FramedAnimationMgr.instance.registerTick(this);
        }
		
        public function pause() : void
        {
            bitmap.bitmapData = frames[index];
            _playing = false;
        }

        public function resume() : void
        {
            _playing = true;
        }

        internal function tick(curTimeInMills : Number) : Boolean
        {
            if (!playing)
            {
                return true;
            }
            curTimeInMills;
            bitmap.bitmapData = frames[index];

            index += 1;
            if (index == frames.length)
            {
                if (autoReplay)
                {
                    index = 0;
                }
                else
                {
                    _playing = false;
                    return false;
                }
            }
            return true;
        }
    }
}