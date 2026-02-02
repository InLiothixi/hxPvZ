package todlib.reanimator;

import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import openfl.display.BitmapData;
import sexyappbase.Image;

class ReanimatorTrackInstance
{
    public var blendCounter:Float;
    public var blendTime:Float;
    public var blendTransform:ReanimatorTransform;
    public var shakeOverride:Float;
    public var shake:FlxPoint;
    public var attachment:Attachment;
    public var imageOverride:Image;
    public var renderGroup:RenderGroup;
    public var trackColor:FlxColor;
    public var ignoreClipRect:Bool;
    public var truncateDisappearingFrames:Bool;
    public var ignoreColorOverride:Bool;
    public var ignoreExtraAdditiveColor:Bool;
    public var renderInBack:Bool;
    public var forceDontRender:Bool;

    public function new() 
    {
        blendCounter = 0;
        blendTime = 0;
        shakeOverride = 0;
        shake = FlxPoint.get();
        renderGroup = RenderGroup.NORMAL;
        ignoreClipRect = false;
        imageOverride = null;
        truncateDisappearingFrames = true;
        trackColor = FlxColor.WHITE;
        ignoreColorOverride = false;
        ignoreExtraAdditiveColor = false;
        renderInBack = false;
        forceDontRender = false;
    }
}