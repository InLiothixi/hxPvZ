package sexyappbase.imagefont;

import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import openfl.display.BitmapData;

class RenderCommand 
{
    public var image:BitmapData;
    public var dest:FlxPoint;
    public var src:FlxRect;
    public var mode:Int;
    public var color:FlxColor;
    public var isPlaceHolder:Bool;
    public var next:RenderCommand;

    public function new() 
    {
        dest = FlxPoint.get();
        src = FlxRect.get();
        color = FlxColor.WHITE;
        isPlaceHolder = false;
    }
}