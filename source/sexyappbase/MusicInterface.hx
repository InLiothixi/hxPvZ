package sexyappbase;

class MusicInterface
{
    public function new() {}

    public function loadMusic(songID:Int, fileName:String)
    {
        return false;
    }

    public function playMusic(songID:Int, offset:Int = 0, noLoop:Bool = false) {}
    public function stopMusic(songID:Int) {}
    public function pauseMusic(songID:Int) {}
    public function resumeMusic(songID:Int) {}
    public function stopAllMusic() {}

    public function unloadMusic(songID:Int) {}
    public function unloadAllMusic() {}
    public function pauseAllMusic() {}
    public function resumeAllMusic() {}

    public function fadeIn(songID:Int, offset:Int = -1, speed:Float = 0.002, noLoop:Bool = false) {}
    public function fadeOut(songID:Int, stopSong:Bool = true, speed:Float = 0.004) {}
    public function fadeAll(stopSong:Bool = true, speed:Float = 0.004) {}
    public function fadeOutAll(stopSong:Bool, speed:Float) {}
    public function setSongVolume(songID:Int, volume:Float) {}
    public function setSongMaxVolume(songID:Int, maxVolume:Float) {}
    public function isPlaying(songID:Int) 
    {
        return false;
    }

    public function setVolume(volume:Float) {}
    public function setMusicAmplify(songID:Int, amp:Float) {}
    public function update(elapsed:Float) {}
}