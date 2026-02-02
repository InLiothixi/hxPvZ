package sexyappbase.bassmusicinterface;

typedef HMUSIC = Null<Int>;
typedef HSTREAM = Null<Int>;

class BassMusicInfo 
{
    public var hMusic:HMUSIC;
    public var hStream:HSTREAM;
    public var volume:Float;
    public var volumeAdd:Float;
    public var volumeCap:Float;
    public var stopOnFade:Bool; 

    public function new() 
    {
        hMusic = null;
        hStream = null;
        volume = 0;
        volumeAdd = 0;
        volumeCap = 1;
        stopOnFade = false;
    }

    public function getHandle() : Int 
    {
        return (hMusic != null) ? hMusic : hStream;
    }
}