package
{
    import com.chaosTK.game.Scene;

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.TimerEvent;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.text.TextField;
    import flash.utils.Timer;

    [SWF(backgroundColor="#FFFFFF", frameRate="200", width="640", height="480")]
    public class BitFiltTest extends Sprite
    {
        [Embed(source="background.jpg")]
        private var embeddedClass : Class;
        private var picture : Bitmap;
        private var startPoint : Point;
        private var endPoint : Point;
        private var ping : Boolean;
        private var rate : int;
        private var frameLabel : TextField;
        private var main : Sprite;
        private var bitmap : Bitmap;
        private var curX : Number = 0;
        private var curY : Number = 0;

        public function BitFiltTest()
        {
            Scene.instance.init(this.stage, main = new Sprite());
            addChild(main);
            picture = new embeddedClass();
            bitmap = new Bitmap(new BitmapData(800, 480));
            main.addChild(bitmap);
            addChild(frameLabel = new TextField());
            frameLabel.textColor = 0xffffffff;
            addEventListener(Event.ENTER_FRAME, onFrame);
            var timer : Timer = new Timer(1000);
            timer.addEventListener(TimerEvent.TIMER, onTimer);
            timer.start();
            startPoint = new Point(-100, -100);
            endPoint = new Point(100, 100);
            ping = true;
        }

        private function onTimer(e : TimerEvent) : void
        {
            frameLabel.text = "fps : " + rate;
            rate = 0;
        }

        private function onFrame(e : Event) : void
        {
            rate++;
            var x : Number = curX;
            var y : Number = curY;
            if (ping)
            {
                if (x <= endPoint.x)
                {
                    curX = x + 1;
                    curY = y + 1;
                }
                else
                {
                    ping = false;
                }
            }
            else
            {
                if (x >= startPoint.x)
                {
                    curX = x - 1;
                    curY = y - 1;
                }
                else
                {
                    ping = true;
                }
            }
            var bitmapData : BitmapData = bitmap.bitmapData;
            bitmapData.copyPixels(picture.bitmapData, new Rectangle(0, 0, picture.width - curX, picture.height - curY), new Point(curX, curY));
        }
    }
}
