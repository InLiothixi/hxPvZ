package sexyappbase;

import sexyappbase.bassmusicinterface.BassMusicInfo.HMUSIC;

#if android
    #if (HXCPP_ARMV7)
        @:buildXml('
        <target id="haxe">
            <lib name="D:/hxPvZ/bass/android/armeabi/libbass.so" />
        </target>
        ')
    #elseif (HXCPP_ARM64)
        @:buildXml('
        <target id="haxe">
            <lib name="D:/hxPvZ/bass/android/arm64/libbass.so" />
        </target>
        ')
    #end
    @:include("D:/hxPvZ/bass/android/bass.h")
#else
@:buildXml('
<target id="haxe">
    <lib name="D:/hxPvZ/bass/x64/bass.lib" />
</target>
')

@:include("D:/hxPvZ/bass/x64/bass.h")
#end


extern class BassInstance 
{
    @:native("BASS_Init")
    public static function BASS_Init(device:Int, freq:Int, flags:Int, win:Dynamic, clsid:Dynamic):Bool;
    @:native("BASS_Free")
    public static function BASS_Free():Bool;
    @:native("BASS_Stop")
    public static function BASS_Stop():Bool;
    @:native("BASS_Start")
    public static function BASS_Start():Bool;
    @:native("BASS_SetVolume")
    public static function BASS_SetVolume(volume:Float):Bool;
    @:native("BASS_SetConfig")
    public static function BASS_SetConfig(option:Int, value:Int):Bool;
    @:native("BASS_GetConfig")
    public static function BASS_GetConfig(option:Int):Int;
    @:native("BASS_GetVolume")
    public static function BASS_GetVolume():Float;
    @:native("BASS_GetInfo")
    public static function BASS_GetInfo(info:Dynamic):Bool;
    @:native("BASS_GetVersion")
    public static function BASS_GetVersion():Int;
    @:native("BASS_ChannelStop")
    public static function BASS_ChannelStop(handle:Int):Bool;
    @:native("BASS_ChannelPlay")
    public static function BASS_ChannelPlay(handle:Int, restart:Bool):Bool;
    @:native("BASS_ChannelPause")
    public static function BASS_ChannelPause(handle:Int):Bool;
    @:native("BASS_ChannelSetAttribute")
    public static function BASS_ChannelSetAttribute(handle:Int, attrib:Int, value:Float):Bool;
    @:native("BASS_ChannelGetAttribute")
    public static function BASS_ChannelGetAttribute(handle:Int, attrib:Int, value:Float):Bool;
    @:native("BASS_ChannelFlags")
    public static function BASS_ChannelFlags(handle:Int, flags:Int, mask:Int):Int;
    @:native("BASS_ChannelSlideAttribute")
    public static function BASS_ChannelSlideAttribute(handle:Int, attrib:Int, value:Float, time:Int):Bool;
    @:native("BASS_ChannelSetPosition")
    public static function BASS_ChannelSetPosition(handle:Int, pos:Int, mode:Int):Bool;
    @:native("BASS_ChannelGetPosition")
    public static function BASS_ChannelGetPosition(handle:Int, mode:Int):Int;
    @:native("BASS_ChannelIsActive")
    public static function BASS_ChannelIsActive(handle:Int):Int;
    @:native("BASS_ChannelIsSliding")
    public static function BASS_ChannelIsSliding(handle:Int, attrib:Int):Bool;
    @:native("BASS_ChannelGetLevel")
    public static function BASS_ChannelGetLevel(handle:Int):Int;
    @:native("BASS_ChannelSetSync")
    public static function BASS_ChannelSetSync(handle:Int, type:Int, param:Int, proc:Dynamic, user:Dynamic):Int;
    @:native("BASS_ChannelRemoveSync")
    public static function BASS_ChannelRemoveSync(handle:Int, sync:Int):Bool;
    @:native("BASS_ChannelGetData")
    public static function BASS_ChannelGetData(handle:Int, buffer:Dynamic, length:Int):Int;
    @:native("BASS_FXSetParameters")
    public static function BASS_FXSetParameters(handle:Int, params:Dynamic):Bool;
    @:native("BASS_FXGetParameters")
    public static function BASS_FXGetParameters(handle:Int, params:Dynamic):Bool;
    @:native("BASS_ChannelSetFX")
    public static function BASS_ChannelSetFX(handle:Int, type:Int, priority:Int):Int;
    @:native("BASS_ChannelRemoveFX")
    public static function BASS_ChannelRemoveFX(handle:Int, fx:Int):Bool;
    @:native("BASS_MusicLoad")
    public static function BASS_MusicLoad(mem:Bool, file:Dynamic, offset:Int, length:Int, flags:Int, freq:Int):Int;
    @:native("BASS_MusicFree")
    public static function BASS_MusicFree(handle:Int):Bool;
    @:native("BASS_StreamCreateFile")
    public static function BASS_StreamCreateFile(mem:Bool, file:String, offset:Int, length:Int, flags:Int):Int;
    @:native("BASS_StreamFree")
    public static function BASS_StreamFree(handle:Int):Bool;

    @:native("BASS_SampleLoad")
    public static function BASS_SampleLoad(mem:Bool, file:String, offset:Int, length:Int, max:Int, flags:Int):Int;
    @:native("BASS_SampleFree")
    public static function BASS_SampleFree(handle:Int):Bool;
    @:native("BASS_SampleSetInfo")
    public static function BASS_SampleSetInfo(handle:Int, info:Dynamic):Bool;
    @:native("BASS_SampleGetInfo")
    public static function BASS_SampleGetInfo(handle:Int, info:Dynamic):Bool;
    @:native("BASS_SampleGetChannel")
    public static function BASS_SampleGetChannel(handle:Int, onlyNew:Bool):Int;
    @:native("BASS_SampleStop")
    public static function BASS_SampleStop(handle:Int):Bool;
    @:native("BASS_ErrorGetCode")
    public static function BASS_ErrorGetCode():Int;
}

class BassInstanceHelper
{    
    public static function BASS_MusicSetAmplify(handle:HMUSIC, amp:Float)
    {
        BassInstance.BASS_ChannelSetAttribute(handle, 0x100, amp);
        return true;
    }

    public static function BASS_MusicPlay(handle:HMUSIC)
    {
        return BassInstance.BASS_ChannelPlay(handle, true);
    }

    inline static function makeLong(low:Int, high:Int):Int {
        return ((high & 0xFFFF) << 16) | (low & 0xFFFF);
    }
    
    inline static function makeMusicPos(order:Int, row:Int):Int 
    {
        return (0x80000000 | makeLong(row, order));
    }

    public static function BASS_MusicPlayEx(handle:HMUSIC, pos:Int, flags:Int, reset:Bool)
    {
        var anOffset = makeMusicPos(pos, 0);

        BassInstance.BASS_ChannelStop(handle);
        BassInstance.BASS_ChannelSetPosition(handle, anOffset, 1);
        BassInstance.BASS_ChannelFlags(handle, flags, flags); // 0xFFFFFFFF
        return BassInstance.BASS_ChannelPlay(handle, false);
    }

    public static function BASS_ChannelResume(handle:Int) 
    {
        return BassInstance.BASS_ChannelPlay(handle, false);
    }

    public static function BASS_StreamPlay(handle:Int, flush:Bool, flags:Int) 
    {
        BassInstance.BASS_ChannelFlags(handle, flags, flags);
        return BassInstance.BASS_ChannelPlay(handle, flush);
    }
}