package com.chaosTK.game
{
    public class GameStateMgr
    {
        public static const UserConfigFileName : String = "userConfig.json";
        public static const FighterConfigFileName : String = "fighterConfig.json";

        public function GameStateMgr()
        {
            if (_instance != null)
            {
                throw new Error();
            }
        }

        private static const _instance : GameStateMgr = new GameStateMgr();
        private static var current : GameState;

        public static function get instance() : GameStateMgr
        {
            return _instance;
        }

        public function start() : void
        {
            switchTo(new StartGame());
        }

        public function switchTo(stage : GameState) : void
        {
            if (current != null)
            {
                current.finish();
            }
            current = stage;
            stage.start();
        }
    }
}