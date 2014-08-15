package com.chaosTK.game
{
    import flash.display.Sprite;
    import flash.events.Event;

    public class MainSceneChangedEvent extends Event
    {
        private const Type : String = "MainSceneChanged";
        private var _scene : Sprite;

        public function MainSceneChangedEvent(scene : Sprite)
        {
            super(Type, bubbles, cancelable);
            _scene = scene;
        }

        public function get scene() : Sprite
        {
            return _scene;
        }
    }
}