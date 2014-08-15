package com.chaosTK.game
{
    import flash.filesystem.FileMode;

    import com.chaosTK.resource.Player;

    import flash.filesystem.File;
    import flash.filesystem.FileStream;

    public class FinalState implements GameState
    {
        public function start() : void
        {
            var savingFile : File = File.applicationStorageDirectory.resolvePath("/" + GameStateMgr.UserConfigFileName);
            var savingFileStream : FileStream = new FileStream();
            savingFileStream.open(savingFile, FileMode.WRITE);
            savingFileStream.writeUTF(Player.instance.toString());
            savingFileStream.close();
        }

        public function finish() : void
        {
        }
    }
}