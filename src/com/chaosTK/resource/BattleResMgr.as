package com.chaosTK.resource
{
    import br.com.stimuli.loading.BulkLoader;
    import br.com.stimuli.loading.loadingtypes.LoadingItem;

    import flash.display.Bitmap;
    import flash.display.Sprite;
    import flash.errors.IllegalOperationError;
    import flash.events.ProgressEvent;

    public class BattleResMgr implements ResourceLoadedListener
    {
        private static const _instance : BattleResMgr = new BattleResMgr();
        private var _battleBackGround : Sprite = new Sprite();
        private var _battleDesc : BattleDesc;
        private var loadingState : LoadingState;

        public function BattleResMgr()
        {
            if (_instance != null)
            {
                throw new IllegalOperationError();
            }
            loadingState = new LoadingState(this);
        }

        public function get battleBackGround() : Sprite
        {
            _battleBackGround.x = 0;
            _battleBackGround.y = 0;
            return _battleBackGround;
        }

        public function get battleDesc() : BattleDesc
        {
            return _battleDesc;
        }

        public static function get instance() : BattleResMgr
        {
            return _instance;
        }

        public function clear() : void
        {
            _battleBackGround = null;
            _battleDesc = null;
        }

        public function load(resDesc : Object, complete : Function, processing : Function = null) : void
        {
            loadingState.onStart(processing, complete);
            _battleDesc = new BattleDesc(resDesc["battleDesc"]);
            var resName : String = resDesc["background"];
            var loader : BulkLoader = new BulkLoader("battleRes");
            loader.add(resName);
            loadingState.bindLoadingListeners(loader);
            loader.start();
        }

        public function onLoaded(e : ProgressEvent) : void
        {
            var loader : BulkLoader = e.target as BulkLoader;
            for each (var loadingItem : LoadingItem in loader.items)
            {
                var image : Bitmap = loader.getBitmap(loadingItem.url.url);
                _battleBackGround.addChild(image);
            }
        }
    }
}