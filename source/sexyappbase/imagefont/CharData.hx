package sexyappbase.imagefont;

import flixel.math.FlxPoint;
import flixel.math.FlxRect;

class CharData
{
    public var imageRect:FlxRect;
    public var offset:FlxPoint;
    public var kerningOffset:Array<Int>;
    public var width:Int;
    public var order:Int;

    public function new() 
    {
        imageRect = FlxRect.get();
        offset = FlxPoint.get();
        kerningOffset = [];
        width = 0;
        order = 0;
    }
}