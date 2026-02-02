package todlib.attachment;

import flixel.math.FlxMatrix;
import flixel.math.FlxPoint;

class AttachEffect
{
    public var effect:Dynamic;
    public var effectType:EffectType;
    public var offset:FlxMatrix;
    public var dontDrawIfParentHidden:Bool;
    public var dontPropogateColor:Bool;

    public function new() {}
}