package todlib.reanimator;

import openfl.display.BitmapData;
import sexyappbase.Font;
import sexyappbase.Image;

class ReanimatorTransform
{
    public var transX:Null<Float>;
    public var transY:Null<Float>;
    public var skewX:Null<Float>;
    public var skewY:Null<Float>;
    public var scaleX:Null<Float>;
    public var scaleY:Null<Float>;
    public var frame:Null<Float>;
    public var alpha:Null<Float>;
    public var image:Image;
    public var font:Dynamic;
    public var text:String;

    public function new() 
    {
        text = String.fromCharCode(0);
    }
}