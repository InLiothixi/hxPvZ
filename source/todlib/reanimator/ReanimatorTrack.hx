package todlib.reanimator;

class ReanimatorTrack
{
    public var name:String;
    public var transforms:Array<ReanimatorTransform>;

    public function new() {
        name = "";
        transforms = [];
    }
}