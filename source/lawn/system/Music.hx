package lawn.system;

import cpp.Pointer;
import lawn.system.music.MusicBurstState;
import lawn.system.music.MusicDrumsState;
import lawn.system.music.MusicFile;
import lawn.system.music.MusicTune;
import lime.app.Application;
import sexyappbase.BassInstance;
import sexyappbase.BassMusicInterface;
import sexyappbase.MusicInterface;
import sexyappbase.bassmusicinterface.BassMusicInfo;
import todlib.TodCommon;
import todlib.todcommon.TodCurves;

class Music
{
    public var musicInterface:BassMusicInterface;
    public var curMusicTune:MusicTune;
    public var curMusicFileMain:MusicFile;
    public var curMusicFileDrums:MusicFile;
    public var curMusicFileHihats:MusicFile;
    public var burstOverride:Int;
    public var baseBPM:Int;
    public var baseModSpeed:Int;
    public var musicBurstState:MusicBurstState;
    public var burstStateCounter:Float;
    public var musicDrumState:MusicDrumsState;
    public var queuedDrumTrackPackedOrder:Int;
    public var drumsStateCounter:Float;
    public var pauseOffset:Int;
    public var pauseOffsetDrums:Int;
    public var paused:Bool;
    public var musicDisabled:Bool;
    public var fadeOutCounter:Float;
    public var fadeOutDuration:Float;

    public function new()
    {
        musicInterface = Main.bassInterface;
        curMusicTune = MusicTune.NONE;
        curMusicFileMain = MusicFile.NONE;
        curMusicFileDrums = MusicFile.NONE;
        curMusicFileHihats = MusicFile.NONE;
        burstOverride = -1;
        musicDrumState = MusicDrumsState.DRUMS_OFF;
        queuedDrumTrackPackedOrder = -1;
        baseBPM = 155;
        baseModSpeed = 3;
        musicBurstState = MusicBurstState.BURST_OFF;
        pauseOffset = 0;
        pauseOffsetDrums = 0;
        paused = false;
        musicDisabled = false;
        fadeOutCounter = 0;
        fadeOutDuration = 0;
    }

    public function getBassMusicHandle(musicFile:MusicFile) : Null<Int>
    {
        var aBass = Main.bassInterface;
        if (aBass.musicMap.exists(musicFile))
        {
            return aBass.musicMap.get(musicFile).hMusic;
        }
        return null;
    }

    public function setupMusicFileForTune(musicFile:MusicFile, musicTune:MusicTune)
    {
        var aTrackCount = 0;
        var aTrackStart1 = -1;
        var aTrackEnd1 = -1;
        var aTrackStart2 = -1;
        var aTrackEnd2 = -1;

        switch (musicTune)
        {
            case MusicTune.DAY_GRASSWALK:
                switch (musicFile)
                {
                    case MusicFile.MAIN_MUSIC:  aTrackCount = 29; aTrackStart1 = 0; aTrackEnd1 = 23;
                    case MusicFile.HIHATS:      aTrackCount = 29; aTrackStart1 = 27; aTrackEnd1 = 27;
                    case MusicFile.DRUMS:       aTrackCount = 29; aTrackStart1 = 24; aTrackEnd1 = 26;
                    default:
                }
            case MusicTune.POOL_WATERYGRAVES:
                switch (musicFile)
                {
                    case MusicFile.MAIN_MUSIC:  aTrackCount = 29; aTrackStart1 = 0; aTrackEnd1 = 17;
                    case MusicFile.HIHATS:      aTrackCount = 29; aTrackStart1 = 18; aTrackEnd1 = 24; aTrackStart2 = 29;	aTrackEnd2 = 29;
                    case MusicFile.DRUMS:       aTrackCount = 29; aTrackStart1 = 25; aTrackEnd1 = 28;
                    default:
                }
            case MusicTune.FOG_RIGORMORMIST:
                switch (musicFile)
                {
                    case MusicFile.MAIN_MUSIC:  aTrackCount = 29; aTrackStart1 = 0; aTrackEnd1 = 15;
                    case MusicFile.HIHATS:      aTrackCount = 29; aTrackStart1 = 23; aTrackEnd1 = 23;
                    case MusicFile.DRUMS:       aTrackCount = 29; aTrackStart1 = 16; aTrackEnd1 = 22;
                    default:
                }
            case MusicTune.ROOF_GRAZETHEROOF:
                switch (musicFile)
                {
                    case MusicFile.MAIN_MUSIC:  aTrackCount = 29; aTrackStart1 = 0; aTrackEnd1 = 17;
                    case MusicFile.HIHATS:      aTrackCount = 29; aTrackStart1 = 21; aTrackEnd1 = 21;
                    case MusicFile.DRUMS:       aTrackCount = 29; aTrackStart1 = 18; aTrackEnd1 = 20;
                    default:
                }
            default:
                switch (musicFile)
                {
                    case MusicFile.MAIN_MUSIC:  aTrackCount = 29; aTrackStart1 = 0; aTrackEnd1 = 29;
                    case MusicFile.DRUMS:       aTrackCount = 29; aTrackStart1 = 0; aTrackEnd1 = 29;
                    default:
                }
        }

        var aHMusic = getBassMusicHandle(musicFile);

        if (aHMusic == null)
        {
            return;
        }

        for (track in 0...aTrackCount + 1)
        {
            var aVolume:Int = 0;

            if (track >= aTrackStart1 && track <= aTrackEnd1)
            {
                aVolume = 100;
            }
            else if (track >= aTrackStart2 && track <= aTrackEnd2)
            {
                aVolume = 100;
            }
            else
            {
                aVolume = 0;
            }

            BassInstance.BASS_ChannelSetAttribute(aHMusic, 0x200 + track, aVolume);
        }
    }

    public function playFromOffset(musicFile:MusicFile, offset:Int, volume:Float)
    {
        var aMusicInfo:BassMusicInfo = null;
        var aBass = musicInterface;
        if (aBass.musicMap.exists(musicFile))
        {
            aMusicInfo = aBass.musicMap.get(musicFile);
        }

        if (aMusicInfo == null)
        {
            return;
        }

        if (aMusicInfo.hStream != null)
        {
            var aNoLoop = musicFile == MusicFile.CREDITS_ZOMBIES_ON_YOUR_LAWN;
            var aOldCap = aMusicInfo.volumeCap;
            aMusicInfo.volumeCap = volume;
            musicInterface.playMusic(musicFile, offset, aNoLoop);
            aMusicInfo.volumeCap = aOldCap;
        }
        else if (aMusicInfo.hMusic != null)
        {
            BassInstance.BASS_ChannelStop(aMusicInfo.hMusic);
            setupMusicFileForTune(musicFile, curMusicTune);
            aMusicInfo.stopOnFade = false;
            aMusicInfo.volume = aMusicInfo.volumeCap * volume;
            aMusicInfo.volumeAdd = 0;
            BassInstance.BASS_ChannelSetAttribute(aMusicInfo.hMusic, 2, aMusicInfo.volume);
            var aFlag = 0x8000 | 0x4;
            BassInstance.BASS_ChannelFlags(aMusicInfo.hMusic, aFlag, aFlag);
            BassInstance.BASS_ChannelSetPosition(aMusicInfo.hMusic, offset, 1);
            BassInstance.BASS_ChannelPlay(aMusicInfo.hMusic, false);
        }
    }

    public function loadSong(musicFile:MusicFile, fileName:String)
    {
        if (!musicInterface.loadMusic(musicFile, fileName))
        {
            Application.current.window.alert("music failed to load " + fileName);
        }
        else
        {
            BassInstance.BASS_ChannelSetAttribute(getBassMusicHandle(musicFile), 0x102, 4);
        }
    }

    public function musicTitleScreenInit()
    {
        loadSong(MusicFile.MAIN_MUSIC, "mainmusic.mo3");
        makeSureMusicIsPlaying(MusicTune.TITLE_CRAZY_DAVE_MAIN_THEME);
    }

    public function musicInit()
    {
        loadSong(MusicFile.DRUMS, "mainmusic.mo3");
        loadSong(MusicFile.HIHATS, "mainmusic.mo3");
    }

    public function musicLoadCreditsSong()
    {
        loadSong(MusicFile.CREDITS_ZOMBIES_ON_YOUR_LAWN, "ZombiesOnYourLawn.ogg");
    }

    public function stopAllMusic()
    {
        if (musicInterface != null)
        {
            if (curMusicFileMain != MusicFile.NONE)
                musicInterface.stopMusic(curMusicFileMain);
            if (curMusicFileDrums != MusicFile.NONE)
                musicInterface.stopMusic(curMusicFileDrums);
            if (curMusicFileHihats != MusicFile.NONE)
                musicInterface.stopMusic(curMusicFileHihats);
        }

        curMusicTune = MusicTune.NONE;
        curMusicFileMain = MusicFile.NONE;
        curMusicFileDrums = MusicFile.NONE;
        curMusicFileHihats = MusicFile.NONE;
        queuedDrumTrackPackedOrder = -1;
        musicDrumState = MusicDrumsState.DRUMS_OFF;
        musicBurstState = MusicBurstState.BURST_OFF;
        pauseOffset = 0;
        pauseOffsetDrums = 0;
        paused = false;
        fadeOutCounter = 0;
    }

    public function playMusic(musicTune:MusicTune, offset:Int, drumsOffset:Int)
    {
        if (musicDisabled)
        {
            return;
        }

        curMusicTune = musicTune;
        curMusicFileMain = MusicFile.NONE;
        curMusicFileDrums = MusicFile.NONE;
        curMusicFileHihats = MusicFile.NONE;
        var aRestartingSong = offset != -1;

        switch (musicTune)
        {
            case MusicTune.DAY_GRASSWALK:
                curMusicFileMain = MusicFile.MAIN_MUSIC;
                curMusicFileDrums = MusicFile.DRUMS;
                curMusicFileHihats = MusicFile.HIHATS;

                if (offset == -1)
                {
                    offset = 0;
                }

                playFromOffset(curMusicFileMain, offset, 1);
                playFromOffset(curMusicFileDrums, offset, 0);
                playFromOffset(curMusicFileHihats, offset, 0);
            case MusicTune.NIGHT_MOONGRAINS:
                curMusicFileMain = MusicFile.MAIN_MUSIC;
                curMusicFileDrums = MusicFile.DRUMS;

                if (offset == -1)
                {
                    offset = 0x30;
                    drumsOffset = 0x5C;
                }

                playFromOffset(curMusicFileMain, offset, 1);
                playFromOffset(curMusicFileDrums, drumsOffset, 0);
            case MusicTune.POOL_WATERYGRAVES:
                curMusicFileMain = MusicFile.MAIN_MUSIC;
                curMusicFileDrums = MusicFile.DRUMS;
                curMusicFileHihats = MusicFile.HIHATS;

                if (offset == -1)
                {
                    offset = 0x5E;
                }

                playFromOffset(curMusicFileMain, offset, 1);
                playFromOffset(curMusicFileDrums, offset, 0);
                playFromOffset(curMusicFileHihats, offset, 0);
            case MusicTune.FOG_RIGORMORMIST:
                curMusicFileMain = MusicFile.MAIN_MUSIC;
                curMusicFileDrums = MusicFile.DRUMS;
                curMusicFileHihats = MusicFile.HIHATS;

                if (offset == -1)
                {
                    offset = 0x7D;
                }

                playFromOffset(curMusicFileMain, offset, 1);
                playFromOffset(curMusicFileDrums, offset, 0);
                playFromOffset(curMusicFileHihats, offset, 0);
            case MusicTune.ROOF_GRAZETHEROOF:
                curMusicFileMain = MusicFile.MAIN_MUSIC;
                curMusicFileDrums = MusicFile.DRUMS;
                curMusicFileHihats = MusicFile.HIHATS;
                if (offset == -1)
                {
                    offset = 0xB8;
                }

                playFromOffset(curMusicFileMain, offset, 1);
                playFromOffset(curMusicFileDrums, offset, 0);
                playFromOffset(curMusicFileHihats, offset, 0);
            case MusicTune.CHOOSE_YOUR_SEEDS:
                curMusicFileMain = MusicFile.MAIN_MUSIC;
                if (offset == -1)
                {
                    offset = 0x7A;
                }
                playFromOffset(curMusicFileMain, offset, 1);
            case MusicTune.TITLE_CRAZY_DAVE_MAIN_THEME:
                curMusicFileMain = MusicFile.MAIN_MUSIC;
                if (offset == -1)
                {
                    offset = 0x98;
                }
                playFromOffset(curMusicFileMain, offset, 1);
            case MusicTune.ZEN_GARDEN:
                curMusicFileMain = MusicFile.MAIN_MUSIC;
                if (offset == -1)
                {
                    offset = 0xDD;
                }
                playFromOffset(curMusicFileMain, offset, 1);
            case MusicTune.PUZZLE_CEREBRAWL:
                curMusicFileMain = MusicFile.MAIN_MUSIC;
                if (offset == -1)
                {
                    offset = 0xB1;
                }
                playFromOffset(curMusicFileMain, offset, 1);
            case MusicTune.MINIGAME_LOONBOON:
                curMusicFileMain = MusicFile.MAIN_MUSIC;
                if (offset == -1)
                {
                    offset = 0xA6;
                }
                playFromOffset(curMusicFileMain, offset, 1);
            case MusicTune.CONVEYER:
                curMusicFileMain = MusicFile.MAIN_MUSIC;
                if (offset == -1)
                {
                    offset = 0xD4;
                }
                playFromOffset(curMusicFileMain, offset, 1);
            case MusicTune.FINAL_BOSS_BRAINIAC_MANIAC:
                curMusicFileMain = MusicFile.MAIN_MUSIC;
                if (offset == -1)
                {
                    offset = 0x9E;
                }
                playFromOffset(curMusicFileMain, offset, 1);
            case MusicTune.CREDITS_ZOMBIES_ON_YOUR_LAWN:
                curMusicFileMain = MusicFile.CREDITS_ZOMBIES_ON_YOUR_LAWN;
                if (offset == -1)
                {
                    offset = 0;
                }
                playFromOffset(curMusicFileMain, offset, 1);
            default:
        }

        if (aRestartingSong)
        {
            if (curMusicFileMain != MusicFile.NONE)
            {
                var aHMusic = getBassMusicHandle(curMusicFileMain);
                BassInstance.BASS_ChannelSetAttribute(aHMusic, 0x103, baseBPM);
                BassInstance.BASS_ChannelSetAttribute(aHMusic, 0x104, baseModSpeed);
            }
            if (curMusicFileDrums != MusicFile.NONE)
            {
                var aHMusic = getBassMusicHandle(curMusicFileDrums);
                BassInstance.BASS_ChannelSetAttribute(aHMusic, 0x103, baseBPM);
                BassInstance.BASS_ChannelSetAttribute(aHMusic, 0x104, baseModSpeed);
            }
            if (curMusicFileHihats != MusicFile.NONE)
            {
                var aHMusic = getBassMusicHandle(curMusicFileHihats);
                BassInstance.BASS_ChannelSetAttribute(aHMusic, 0x103, baseBPM);
                BassInstance.BASS_ChannelSetAttribute(aHMusic, 0x104, baseModSpeed);
            }
        }
        else
        {
            var aHMusic = Std.int(getBassMusicHandle(curMusicFileMain));

            var bpm:Float = 0;
            var speed:Float = 0;

            untyped __cpp__('float _bpm_f = 0;');
            untyped __cpp__('float _speed_f = 0;');

            untyped __cpp__('BASS_ChannelGetAttribute({0}, 0x103, &_bpm_f);', aHMusic);
            untyped __cpp__('BASS_ChannelGetAttribute({0}, 0x104, &_speed_f);', aHMusic);

            untyped __cpp__('{0} = (Float)_bpm_f;', bpm);
            untyped __cpp__('{0} = (Float)_speed_f;', speed);

            baseBPM = Std.int(bpm);
            baseModSpeed = Std.int(speed);
        }
    }

    public function getMusicOrder(musicFile:MusicFile)
    {
        return Main.bassInterface.getMusicOrder(musicFile);
    }

    public function getChannelOrder(musicFile:MusicFile)
    {
        return Main.bassInterface.getChannelPosition(musicFile);
    }

    public function musicResyncChannel(musicFileToMatch:MusicFile, musicFileToSync:MusicFile)
    {
        var aPosToMatch = getChannelOrder(musicFileToMatch);
        var aPosToSync = getChannelOrder(musicFileToSync);
        var aDiff = (aPosToSync >> 16) - (aPosToMatch >> 16);
        if (Math.abs(aDiff) <= 128)
        {
            var aHMusic = getBassMusicHandle(musicFileToSync);

            var aBPM = baseBPM;
            if (aDiff > 2)
            {
                aBPM -= 2;
            }
            else if (aDiff > 0)
            {
                aBPM -= 1;
            }
            else if (aDiff < -2)
            {
                aBPM += 2;
            }
            else if (aDiff < 0)
            {
                aBPM += 1;
            }

            BassInstance.BASS_ChannelSetAttribute(aHMusic, 0x103, aBPM);
        }
    }

    public function musicResync()
    {
        if (curMusicFileMain != MusicFile.NONE)
        {
            if (curMusicFileDrums != MusicFile.NONE)
            {
                musicResyncChannel(curMusicFileMain, curMusicFileDrums);
            }

            if (curMusicFileHihats != MusicFile.NONE)
            {
                musicResyncChannel(curMusicFileMain, curMusicFileHihats);
            }
        }
    }

    public function startBurst()
    {
        if (musicBurstState == MusicBurstState.BURST_OFF)
        {
            musicBurstState = MusicBurstState.BURST_STARTING;
            burstStateCounter = 4;
        }
    }

    public function fadeOut(fadeOutDuration:Int)
    {
        if (curMusicTune != MusicTune.NONE)
        {
            fadeOutCounter = fadeOutDuration;
            this.fadeOutDuration = fadeOutDuration;
        }
    }

    public function updateMusicBurst(elapsed:Float)
    {
        if (Main.board == null) return;

        var aBurstScheme = 0;

        if (curMusicTune == MusicTune.DAY_GRASSWALK || curMusicTune == MusicTune.POOL_WATERYGRAVES ||
            curMusicTune == MusicTune.FOG_RIGORMORMIST || curMusicTune == MusicTune.ROOF_GRAZETHEROOF)
        {
            aBurstScheme = 1;
        }
        else if (curMusicTune == MusicTune.NIGHT_MOONGRAINS)
        {
            aBurstScheme = 2;
        }
        else
        {
            return;
        }

        var aPackedOrderMain = getChannelOrder(curMusicFileMain);

        if (burstStateCounter > 0)
            burstStateCounter -= elapsed;
        if (drumsStateCounter > 0)
            drumsStateCounter -= elapsed;

        if (burstStateCounter < 0) burstStateCounter = 0;
        if (drumsStateCounter < 0) drumsStateCounter = 0;

        var aFadeTrackVolume:Float = 0;
        var aDrumsVolume:Float = 0;
        var aMainTrackVolume:Float = 1;

        switch (musicBurstState)
        {
            case MusicBurstState.BURST_OFF:
                if (Main.board.burst || burstOverride == 1)
                    startBurst();

            case MusicBurstState.BURST_STARTING:
                if (aBurstScheme == 1)
                {
                    aFadeTrackVolume = TodCommon.todAnimateCurve(4, 0, burstStateCounter, 0, 1, TodCurves.LINEAR);
                    if (Math.floor(burstStateCounter) == 1)
                    {
                        musicDrumState = MusicDrumsState.DRUMS_ON_QUEUED;
                        queuedDrumTrackPackedOrder = aPackedOrderMain;
                    }
                    else if (Math.floor(burstStateCounter) == 0)
                    {
                        musicBurstState = MusicBurstState.BURST_ON;
                        burstStateCounter = 8;
                    }
                }
                else if (aBurstScheme == 2)
                {
                    if (musicDrumState == MusicDrumsState.DRUMS_OFF)
                    {
                        musicDrumState = MusicDrumsState.DRUMS_ON_QUEUED;
                        queuedDrumTrackPackedOrder = aPackedOrderMain;
                        burstStateCounter = 4;
                    }
                    else if (musicDrumState == MusicDrumsState.DRUMS_ON_QUEUED)
                    {
                        burstStateCounter = 4;
                    }
                    else
                    {
                        aMainTrackVolume = TodCommon.todAnimateCurve(4, 0, burstStateCounter, 1, 0, TodCurves.LINEAR);
                        if (Math.floor(burstStateCounter) == 0)
                        {
                            musicBurstState = MusicBurstState.BURST_ON;
                            burstStateCounter = 8;
                        }
                    }
                }

            case MusicBurstState.BURST_ON:
                aFadeTrackVolume = 1;
                if (aBurstScheme == 2) aMainTrackVolume = 0;

                if (Math.floor(burstStateCounter) == 0 && (!Main.board.burst || burstOverride == 2))
                {
                    if (aBurstScheme == 1)
                    {
                        musicBurstState = MusicBurstState.BURST_FINISHING;
                        burstStateCounter = 8;
                        musicDrumState = MusicDrumsState.DRUMS_OFF_QUEUED;
                        queuedDrumTrackPackedOrder = aPackedOrderMain;
                    }
                    else if (aBurstScheme == 2)
                    {
                        musicBurstState = MusicBurstState.BURST_FINISHING;
                        burstStateCounter = 11;
                        musicDrumState = MusicDrumsState.DRUMS_FADING;
                        drumsStateCounter = 8;
                    }
                }

            case MusicBurstState.BURST_FINISHING:
                if (aBurstScheme == 1)
                    aFadeTrackVolume = TodCommon.todAnimateCurve(8, 0, burstStateCounter, 1, 0, TodCurves.LINEAR);
                else
                    aMainTrackVolume = TodCommon.todAnimateCurve(4, 0, burstStateCounter, 0, 1, TodCurves.LINEAR);

                if (Math.floor(burstStateCounter) == 0 && musicDrumState == MusicDrumsState.DRUMS_OFF)
                    musicBurstState = MusicBurstState.BURST_OFF;

            default:
        }

        var aDrumsJumpOrder = -1;
        var aOrderMain = 0;
        var aOrderDrum = 0;

        if (aBurstScheme == 1)
        {
            aOrderMain =  Math.floor(((aPackedOrderMain >> 16) & 0xFFFF) / 128);
            aOrderDrum = Math.floor(((queuedDrumTrackPackedOrder >> 16) & 0xFFFF) / 128);
        }
        else if (aBurstScheme == 2)
        {
            aOrderMain = aPackedOrderMain & 0xFFFF;
            aOrderDrum = queuedDrumTrackPackedOrder & 0xFFFF;
            if (((aPackedOrderMain >> 16) & 0xFFFF) > 252) aOrderMain++;
            if (((queuedDrumTrackPackedOrder >> 16) & 0xFFFF) > 252) aOrderDrum++;
        }

        switch (musicDrumState)
        {
            case MusicDrumsState.DRUMS_ON_QUEUED:
                if (aOrderMain != aOrderDrum)
                {
                    aDrumsVolume = 1;
                    musicDrumState = MusicDrumsState.DRUMS_ON;
                    if (aBurstScheme == 2)
                    {
                        aDrumsJumpOrder = (aOrderMain % 2 == 0) ? 76 : 77;
                    }
                }

            case MusicDrumsState.DRUMS_ON:
                aDrumsVolume = 1;

            case MusicDrumsState.DRUMS_OFF_QUEUED:
                aDrumsVolume = 1;
                if ((aOrderMain != aOrderDrum) && aBurstScheme == 1)
                {
                    musicDrumState = MusicDrumsState.DRUMS_FADING;
                    drumsStateCounter = 0.5;
                }

            case MusicDrumsState.DRUMS_FADING:
                if (aBurstScheme == 2)
                    aDrumsVolume = TodCommon.todAnimateCurve(8, 0, drumsStateCounter, 1, 0, TodCurves.LINEAR);
                else
                    aDrumsVolume = TodCommon.todAnimateCurve(0.5, 0, drumsStateCounter, 1, 0, TodCurves.LINEAR);

                if (drumsStateCounter <= 0)
                    musicDrumState = MusicDrumsState.DRUMS_OFF;

            default:
        }

        if (aBurstScheme == 1)
        {
            musicInterface.setSongVolume(curMusicFileHihats, aFadeTrackVolume);
            musicInterface.setSongVolume(curMusicFileDrums, aDrumsVolume);
        }
        else if (aBurstScheme == 2)
        {
            musicInterface.setSongVolume(curMusicFileMain, aMainTrackVolume);
            musicInterface.setSongVolume(curMusicFileDrums, aDrumsVolume);

            if (aDrumsJumpOrder != -1)
                BassInstance.BASS_ChannelSetPosition(getBassMusicHandle(curMusicFileDrums), aDrumsJumpOrder & 0xFFFF, 1);
        }
    }


    public function musicUpdate(elapsed:Float)
    {
        if (fadeOutCounter > 0)
        {
            fadeOutCounter -= elapsed;

            if (fadeOutCounter == 0)
            {
                stopAllMusic();
            }
            else if (musicInterface != null && curMusicFileMain != MusicFile.NONE)
            {
                var aFadeLevel = TodCommon.todAnimateCurve(fadeOutDuration, 0, fadeOutCounter, 1, 0, TodCurves.LINEAR);
                musicInterface.setSongVolume(curMusicFileMain, aFadeLevel);
            }
        }

        if (Main.board != null && !Main.board.paused)
        {
            updateMusicBurst(elapsed);
            musicResync();
        }
    }

    public function makeSureMusicIsPlaying(musicTune:MusicTune)
    {
        if (curMusicTune != musicTune)
        {
            stopAllMusic();
            playMusic(musicTune, -1, -1);
        }
    }

    public function gameMusicPause(thePause:Bool)
    {
        if (thePause)
        {
            if (!paused && curMusicTune != MusicTune.NONE && musicInterface != null)
            {
                if (musicInterface.musicMap.exists(curMusicFileMain))
                {
                    var aMusicInfo = musicInterface.musicMap.get(curMusicFileMain);

                    if (aMusicInfo.hStream != null)
                    {
                        pauseOffset = getChannelOrder(aMusicInfo.hStream);
                        musicInterface.stopMusic(curMusicFileMain);
                    }
                    else if (aMusicInfo.hMusic != null)
                    {
                        var aOrderMain = getChannelOrder(curMusicFileMain);
                        pauseOffset = ((aOrderMain & 0xffff) | (Math.floor((aOrderMain >> 16) / 4) << 16));
                        musicInterface.stopMusic(curMusicFileMain);

                        if (curMusicTune == MusicTune.DAY_GRASSWALK || curMusicTune == MusicTune.POOL_WATERYGRAVES ||
                            curMusicTune == MusicTune.FOG_RIGORMORMIST || curMusicTune == MusicTune.ROOF_GRAZETHEROOF)
                        {
                            musicInterface.stopMusic(curMusicFileDrums);
                            musicInterface.stopMusic(curMusicFileHihats);
                        }
                        else if (curMusicTune == MusicTune.NIGHT_MOONGRAINS)
                        {
                            var aOrderDrums = getChannelOrder(curMusicFileDrums);
                            pauseOffsetDrums = ((aOrderDrums & 0xffff) | (Math.floor((aOrderDrums >> 16) / 4) << 16));
                            musicInterface.stopMusic(curMusicFileDrums);
                        }
                    }
                    paused = true;
                }
            }
        }
        else if (paused)
        {
            if (curMusicTune != MusicTune.NONE)
            {
                playMusic(curMusicTune, pauseOffset, pauseOffsetDrums);
            }

            paused = false;
        }
    }

}