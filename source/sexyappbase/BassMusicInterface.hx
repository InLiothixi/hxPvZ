package sexyappbase;

import cpp.Pointer;
import haxe.io.Bytes;
import lawn.system.music.MusicFile;
import lime.app.Application;
import openfl.utils.AssetType;
import openfl.utils.Assets;
import sexyappbase.BassInstance.BassInstanceHelper;
import sexyappbase.bassmusicinterface.BassMusicInfo;

class BassMusicInterface extends MusicInterface
{
    public var musicMap:Map<MusicFile, BassMusicInfo>;
    public var maxMusicVolume:Int;
    public var musicLoadFlags:Int;

    public function new() 
    {
        super();
        
        musicMap = new Map<MusicFile, BassMusicInfo>();
        maxMusicVolume = 40;
        if (!BassInstance.BASS_Init(-1, 48000, 0, null, null))
        {
            Application.current.window.alert("BASS_Init failed");
        }
        if (!BassInstance.BASS_Start())
        {
            Application.current.window.alert("BASS_Start failed");
        }
        musicLoadFlags = 0x4;
    }

    public function getMusicPath(id:String) : String
    {
        id = id.toLowerCase();

        var musicList = Assets.list(AssetType.BINARY);

        for (path in musicList)
        {
            var file = path.split("/").pop();
            if (file.toLowerCase() == id)
            {
                return path;
            }
        }

        return null;
    }

    override public function loadMusic(songID:MusicFile, fileName:String)
    {
        var aHMMusic:HMUSIC = null;
        var aHStream:HSTREAM = null;

        var path = getMusicPath(fileName);

        if (path == null)
        {            
            Application.current.window.alert("GetMusicPath cannot be found: " + fileName);
            return false;
        }
        
        var extName = path.split(".").pop();

        if (extName == "wav" || extName == "ogg" || extName == "mp3")
        {
            aHStream = BassInstance.BASS_StreamCreateFile(false, path, 0, 0, 0);
        }
        else 
        {
            var bytes:Bytes;
            #if android
                bytes = lime.utils.Assets.getBytes(path);
            #else
                bytes = sys.io.File.getBytes(path);
            #end
            var ptr = Pointer.arrayElem(bytes.getData(), 0); 
            aHMMusic = BassInstance.BASS_MusicLoad(true, ptr, 0, bytes.length, musicLoadFlags, 48000);
        }

        if (aHMMusic == null && aHStream == null)
        {
            Application.current.window.alert("BASS LoadMusic failed: " + path);
            return false;
        }

        var aMusicInfo = new BassMusicInfo();
        aMusicInfo.hMusic = aHMMusic;
        aMusicInfo.hStream = aHStream;
        musicMap.set(songID, aMusicInfo);

        return true;
    }

    override public function playMusic(songId:Int, offset:Int = 0, noLoop:Bool = false) 
    {
        if (musicMap.exists(songId))
        {
            var aMusicInfo = musicMap.get(songId);
            aMusicInfo.volume = aMusicInfo.volumeCap;
            aMusicInfo.volumeAdd = 0;
            aMusicInfo.stopOnFade = noLoop;
            BassInstance.BASS_ChannelSetAttribute(aMusicInfo.getHandle(), 2, aMusicInfo.volume);
            BassInstance.BASS_ChannelStop(aMusicInfo.getHandle());

            if (aMusicInfo.hMusic != null)
            {
                BassInstanceHelper.BASS_MusicPlayEx(aMusicInfo.hMusic, offset, noLoop ? 0 : 4, true);
            }
            else 
            {
                var flush = offset == -1 ? false : true;
                BassInstanceHelper.BASS_StreamPlay(aMusicInfo.hStream, flush, noLoop ? 0 : 4);
                if (offset > 0)
                {
                    BassInstance.BASS_ChannelSetPosition(aMusicInfo.hStream, offset, 1);
                }
            }
        }
    }

    override public function stopMusic(songId:Int)
    {
        if (musicMap.exists(songId))
        {
            var aMusicInfo = musicMap.get(songId);
            aMusicInfo.volume = 0;

            if (aMusicInfo.hMusic != null)
            {
                BassInstance.BASS_ChannelStop(aMusicInfo.hMusic);
            }
        
            if (aMusicInfo.hStream != null)
            {
                BassInstance.BASS_ChannelStop(aMusicInfo.hStream);
            }

            // BassInstance.BASS_ChannelStop(aMusicInfo.getHandle());
        }
    }

    override public function stopAllMusic()
    {
        for (songId in musicMap.keys())
        {
            var aMusicInfo = musicMap.get(songId);
            aMusicInfo.volume = 0;

            if (aMusicInfo.hMusic != null)
            {
                BassInstance.BASS_ChannelStop(aMusicInfo.hMusic);
            }
        
            if (aMusicInfo.hStream != null)
            {
                BassInstance.BASS_ChannelStop(aMusicInfo.hStream);
            }

            // BassInstance.BASS_ChannelStop(aMusicInfo.getHandle());
        }
    }

    override public function unloadMusic(songId:Int)
    {
        if (musicMap.exists(songId))
        {
            var aMusicInfo = musicMap.get(songId);
            if (aMusicInfo.hStream != null)
                BassInstance.BASS_StreamFree(aMusicInfo.hStream);
            else if (aMusicInfo.hMusic != null)
                BassInstance.BASS_MusicFree(aMusicInfo.hMusic);
            musicMap.remove(songId);
        }
    }

    override public function unloadAllMusic()
    {
        for (songId in musicMap.keys())
        {
            var aMusicInfo = musicMap.get(songId);
            if (aMusicInfo.hStream != null)
                BassInstance.BASS_StreamFree(aMusicInfo.hStream);
            else if (aMusicInfo.hMusic != null)
                BassInstance.BASS_MusicFree(aMusicInfo.hMusic);
            musicMap.remove(songId);
        }
    }

    override public function pauseMusic(songId:Int)
    {
        if (musicMap.exists(songId))
        {
            var aMusicInfo = musicMap.get(songId);
            BassInstance.BASS_ChannelPause(aMusicInfo.getHandle());
        }
    }

    override public function pauseAllMusic()
    {
        for (songId in musicMap.keys())
        {
            var aMusicInfo = musicMap.get(songId);
            if (BassInstance.BASS_ChannelIsActive(aMusicInfo.getHandle()) == 1)
                BassInstance.BASS_ChannelPause(aMusicInfo.getHandle());
        }
    }

    override public function resumeMusic(songId:Int)
    {
        if (musicMap.exists(songId))
        {
            var aMusicInfo = musicMap.get(songId);
                BassInstanceHelper.BASS_ChannelResume(aMusicInfo.getHandle());
        }
    }

    override public function resumeAllMusic()
    {
        for (songId in musicMap.keys())
        {
            var aMusicInfo = musicMap.get(songId);
            if (BassInstance.BASS_ChannelIsActive(aMusicInfo.getHandle()) == 3)
                BassInstanceHelper.BASS_ChannelResume(aMusicInfo.getHandle());
        }
    }

    override public function fadeIn(songId:Int, offset:Int = -1, speed:Float = 0.002, noLoop:Bool = false)
    {
        if (musicMap.exists(songId))
        {
            var aMusicInfo = musicMap.get(songId);
            aMusicInfo.volumeAdd = speed;
            aMusicInfo.stopOnFade = noLoop;

            BassInstance.BASS_ChannelStop(aMusicInfo.getHandle());
            BassInstance.BASS_ChannelSetAttribute(aMusicInfo.getHandle(), 2, aMusicInfo.volume);

            if (aMusicInfo.hMusic != null)
            {
                if (offset == -1)
                {
                    BassInstanceHelper.BASS_MusicPlay(aMusicInfo.hMusic);
                }
                else 
                {
                    BassInstanceHelper.BASS_MusicPlayEx(aMusicInfo.hMusic, offset, noLoop ? 0 : 4, true);
                }
            }
            else 
            {
                var flush = offset == -1 ? false : true;
                BassInstanceHelper.BASS_StreamPlay(aMusicInfo.hStream, flush, 4);
                if (offset > 0)
                {
                    BassInstance.BASS_ChannelSetPosition(aMusicInfo.hStream, offset, 1);
                }
            }
        }
    }

    override public function fadeOut(songId:Int, stopSong:Bool = true, speed:Float = 0.004) 
    {
        if (musicMap.exists(songId))
        {
            var aMusicInfo = musicMap.get(songId);
            if (aMusicInfo.volume > 0)
            {
                aMusicInfo.volumeAdd -= speed;
            }
            aMusicInfo.stopOnFade = stopSong;
        }
    }

    override public function fadeOutAll(stopSong:Bool, speed:Float) 
    {
        for (songId in musicMap.keys())
        {
            var aMusicInfo = musicMap.get(songId);
            if (aMusicInfo.volume > 0)
            {
                aMusicInfo.volumeAdd -= speed;
            }
            aMusicInfo.stopOnFade = stopSong;
        }
    }

    override public function setVolume(volume:Float)
    {
        BassInstance.BASS_SetConfig(5, Std.int(volume));
        BassInstance.BASS_SetConfig(6, Std.int(volume));
    }

    override public function setSongVolume(songId:Int, volume:Float)
    {
        if (musicMap.exists(songId))
        {
            var aMusicInfo = musicMap.get(songId);
            aMusicInfo.volume = volume;
            BassInstance.BASS_ChannelSetAttribute(aMusicInfo.getHandle(), 2, volume);
        }
    }

    override public function setSongMaxVolume(songId:Int, maxVolume:Float)
    {
        if (musicMap.exists(songId))
        {
            var aMusicInfo = musicMap.get(songId);
            aMusicInfo.volumeCap = maxVolume;
            aMusicInfo.volume = Math.min(aMusicInfo.volume, maxVolume);
            BassInstance.BASS_ChannelSetAttribute(aMusicInfo.getHandle(), 2, aMusicInfo.volume);
        }
    }

    override public function isPlaying(songId:Int)
    {
        if (musicMap.exists(songId))
        {
            var aMusicInfo = musicMap.get(songId);
            return BassInstance.BASS_ChannelIsActive(aMusicInfo.getHandle()) == 1;
        }

        return false;
    }

    override public function setMusicAmplify(songId:Int, amp:Float)
    {
        if (musicMap.exists(songId))
        {
            var aMusicInfo = musicMap.get(songId);
            BassInstanceHelper.BASS_MusicSetAmplify(aMusicInfo.getHandle(), amp);
        }
    }

    override public function update(elapsed:Float)
    {
        for (songId in musicMap.keys())
        {
            var aMusicInfo = musicMap.get(songId);

            if (aMusicInfo.volumeAdd != 0)
            {
                aMusicInfo.volume += aMusicInfo.volumeAdd * elapsed;

                if (aMusicInfo.volume > aMusicInfo.volumeCap)
                {
                    aMusicInfo.volume = aMusicInfo.volumeCap;
                    aMusicInfo.volumeAdd = 0;
                }
                else if (aMusicInfo.volume < 0)
                {
                    aMusicInfo.volume = 0;
                    aMusicInfo.volumeAdd = 0;

                    if (aMusicInfo.stopOnFade)
                    {
                        BassInstance.BASS_ChannelStop(aMusicInfo.getHandle());
                    }
                }

                BassInstance.BASS_ChannelSetAttribute(aMusicInfo.getHandle(), 2, aMusicInfo.volume);
            }
        }
    }

    public function getMusicOrder(songId:Int) 
    {
        if (musicMap.exists(songId))
        {
            var aMusicInfo = musicMap.get(songId);
            var aPosition = BassInstance.BASS_ChannelGetPosition(aMusicInfo.getHandle(), 0);
            return aPosition;
        }

        return -1;
    }

    public function getChannelPosition(songId:Int) 
    {
        if (musicMap.exists(songId))
        {
            var aMusicInfo = musicMap.get(songId);
            var aPosition = BassInstance.BASS_ChannelGetPosition(aMusicInfo.getHandle(), 1);
            return aPosition;
        }

        return -1;
    }
}