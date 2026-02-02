package sexyappbase.imagefont;

import flixel.math.FlxRect;
import openfl.display.BitmapData;

class ActiveFontLayer
{
    public var baseFontLayer:FontLayer;
    public var scaledImage:BitmapData;
    public var scaledCharImageRects:Array<FlxRect>;

    public function new() 
    {
        scaledCharImageRects = [];
    }
}
