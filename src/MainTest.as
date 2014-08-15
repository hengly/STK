package
{
    import flash.display.Loader;
    import flash.display.LoaderInfo;
    import flash.display.Sprite;
    import flash.display.StageQuality;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.events.TimerEvent;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    import flash.system.ApplicationDomain;
    import flash.system.LoaderContext;
    import flash.text.TextField;
    import flash.utils.ByteArray;
    import flash.utils.Timer;
    import flash.utils.getDefinitionByName;

    [SWF(backgroundColor="#000000", frameRate="200", width="800", height="480")]
    public class MainTest extends Sprite
    {
        private var mainFrame : Sprite;
        private var frameRate : int = 0;
        private var frameLabel : TextField;
		
		private function onScriptLibraryLoaded(e : Event) : void
		{
			var urlLoader : URLLoader = e.target as URLLoader;
			urlLoader.removeEventListener(Event.COMPLETE, onScriptLibraryLoaded);
			var loaderContent : LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			loaderContent.allowCodeImport = true;
			var loader : Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onScriptLibarryReady);
			loader.loadBytes(urlLoader.data, loaderContent);
		}
		
		private function onScriptLibarryReady(e : Event) : void
		{
			(e.target as LoaderInfo).removeEventListener(Event.COMPLETE, onScriptLibarryReady);
			var x : * = (e.target as LoaderInfo).content;
			start();
		}
		
		private function loadScript() : void
		{
			var request : URLRequest = new URLRequest('ScriptSwf.swf');
			var urlLoader : URLLoader = new URLLoader;
			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			urlLoader.addEventListener(Event.COMPLETE, onScriptLibraryLoaded);
			urlLoader.load(request);
		}
		
		private function start() : void
		{
			import com.chaosTK.game.GameStateMgr;
			import com.chaosTK.game.Scene;

			Scene.instance.init(stage, mainFrame);
			GameStateMgr.instance.start();
			
			addEventListener(Event.ENTER_FRAME, onFrame);
			
			var timer : Timer = new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
			
		}
		
        public function MainTest()
        {
			addEventListener(Event.ADDED_TO_STAGE, onInit);
        }

        private function onInit(e : Event) : void
        {
			mainFrame = new Sprite();
            frameLabel = new TextField();
            frameLabel.textColor = 0x0ffffff;
			frameLabel.x = 50;
            frameLabel.text = "fps:" + 60;
            frameLabel.y = 100;
            addChild(mainFrame);
            addChild(frameLabel);
			
			loadScript();
        }

        private function onFrame(e : Event) : void
        {
            e;
            frameRate += 1;
        }

        private function onTimer(e : TimerEvent) : void
        {
            e;
            frameLabel.text = "fps:" + frameRate;
            frameRate = 0;
        }
    }
}