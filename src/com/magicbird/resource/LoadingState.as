package com.chaosTK.resource
{
    import br.com.stimuli.loading.BulkLoader;
    import br.com.stimuli.loading.BulkProgressEvent;

    import flash.events.ProgressEvent;

    public class LoadingState
    {
        private var loading : Boolean;
        private var processingCallback : Function;
        private var completeCallback : Function;
        private var bindedLoader : ResourceLoadedListener;

        public function LoadingState(bindedLoader : ResourceLoadedListener)
        {
            this.bindedLoader = bindedLoader;
        }

        public function onStart(processing : Function, complete : Function) : void
        {
            if (loading)
            {
                throw new Error("loading while loading");
            }
            loading = true;
            processingCallback = processing;
            completeCallback = complete;
        }

        public function bindLoadingListeners(loader : BulkLoader) : void
        {
            if (processingCallback != null)
            {
                loader.addEventListener(BulkProgressEvent.PROGRESS, processingCallback);
            }
            loader.addEventListener(BulkProgressEvent.COMPLETE, onComplete);
        }

        private function onComplete(e : ProgressEvent) : void
        {
            var loader : BulkLoader = e.target as BulkLoader;
            loader.removeEventListener(BulkProgressEvent.COMPLETE, onComplete);
            if (processingCallback != null)
            {
                loader.removeEventListener(BulkProgressEvent.PROGRESS, processingCallback);
            }

            bindedLoader.onLoaded(e);

            loading = false;
            processingCallback = null;
            completeCallback(e);
            completeCallback = null;
            loader.clear();
        }
    }
}
