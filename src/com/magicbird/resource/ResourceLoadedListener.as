package com.chaosTK.resource
{
    import flash.events.ProgressEvent;

    public interface ResourceLoadedListener
    {
        function onLoaded(e : ProgressEvent) : void;
    }
}
