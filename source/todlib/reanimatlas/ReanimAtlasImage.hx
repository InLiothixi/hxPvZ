package todlib.reanimatlas;

import flixel.math.FlxRect;
import openfl.display.BitmapData;
import sexyappbase.Image;

class ReanimAtlasImage
{
    public var rect:FlxRect;
    public var originalImage:Image;

    public function new() 
    {
        rect = FlxRect.get();    
    }
}