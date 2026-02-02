package todlib.todparticle;

import sexyappbase.DescParser.IntRef;
import sexyappbase.Image;

class TodEmitterDefinition
{
    public var image:Image;
    public var imageCol:Int;
    public var imageRow:Int;
    public var imageFrames:Int;
    public var animated:Bool;
    public var particleFlags:IntRef;
    public var emitterType:EmitterType;
    public var name:String;
    public var onDuration:String;
    public var systemDuration:FloatParameterTrack;
    public var crossFadeDuration:FloatParameterTrack;
    public var spawnRate:FloatParameterTrack;
    public var spawnMinActive:FloatParameterTrack;
    public var spawnMaxActive:FloatParameterTrack;
    public var spawnMaxLaunched:FloatParameterTrack;
    public var emitterRadius:FloatParameterTrack;
    public var emitterOffsetX:FloatParameterTrack;
    public var emitterOffsetY:FloatParameterTrack;
    public var emitterBoxX:FloatParameterTrack;
    public var emitterBoxY:FloatParameterTrack;
    public var emitterSkewX:FloatParameterTrack;
    public var emitterSkewY:FloatParameterTrack;
    public var emitterPath:FloatParameterTrack;
    public var particleDuration:FloatParameterTrack;
    public var launchSpeed:FloatParameterTrack;
    public var launchAngle:FloatParameterTrack;
    public var systemRed:FloatParameterTrack;
    public var systemGreen:FloatParameterTrack;
    public var systemBlue:FloatParameterTrack;
    public var systemAlpha:FloatParameterTrack;
    public var systemBrightness:FloatParameterTrack;
    public var particleFields:Array<ParticleField>;
    public var systemFields:Array<ParticleField>;
    public var particleRed:FloatParameterTrack;
    public var particleGreen:FloatParameterTrack;
    public var particleBlue:FloatParameterTrack;
    public var particleAlpha:FloatParameterTrack;
    public var particleBrightness:FloatParameterTrack;
    public var particleSpinAngle:FloatParameterTrack;
    public var particleSpinSpeed:FloatParameterTrack;
    public var particleScale:FloatParameterTrack;
    public var particleStretch:FloatParameterTrack;
    public var collisionReflect:FloatParameterTrack;
    public var collisionSpin:FloatParameterTrack;
    public var clipTop:FloatParameterTrack;
    public var clipBottom:FloatParameterTrack;
    public var clipLeft:FloatParameterTrack;
    public var clipRight:FloatParameterTrack;
    public var animRate:FloatParameterTrack;

    public function new() {}
}