package todlib.reanimator;

class ReanimatorDefinition
{
    public var tracks:Array<ReanimatorTrack>;
    public var fps:Float;
    public var reanimAtlas:ReanimAtlas;

    public function new() 
    {
        tracks = [];
        fps = 12;    
    }
}