package todlib.todparticle;

import todlib.filtereffect.FilterEffectType;

class ParticleRenderParams 
{
    public var redIsSet:Bool;
    public var greenIsSet:Bool;
    public var blueIsSet:Bool;
    public var alphaIsSet:Bool;
    public var particleScaleIsSet:Bool;
    public var particleStretchIsSet:Bool;
    public var spinPositionIsSet:Bool;
    public var positionIsSet:Bool;
    public var red:Float;
    public var green:Float;
    public var blue:Float;
    public var alpha:Float;
    public var extraAdditiveRed:Float;
    public var extraAdditiveGreen:Float;
    public var extraAdditiveBlue:Float;
    public var extraAdditiveAlpha:Float;
    public var particleScale:Float;
    public var particleStretch:Float;
    public var spinPosition:Float;
    public var posX:Float;
    public var posY:Float;
    public var filterEffect:FilterEffectType;

    public function new() {}
}