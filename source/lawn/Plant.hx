package lawn;

import flixel.math.FlxRect;
import lawn.plant.SeedType;
import lawn.plant.State;
import lawn.plant.SubClass;

class Plant {
    public var seedType:SeedType;
    public var plantCol:Int;
    public var animCounter:Float;
    public var frame:Int; 
    public var frameLength:Int;
    public var numFrames:Int;
    public var state:State;
    public var plantHealth:Float;
    public var plantMaxHealth:Float;
    public var subClass:SubClass;
    public var disappearCountdown:Float;
    public var doSpecialCountdown:Float;
    public var stateCountdown:Float;
    public var launchCounter:Float;
    public var launchRate:Float;
    public var plantRect:FlxRect;
    public var plantAttackRect:FlxRect;
    public var targetX:Float;
    public var targetY:Float; 
    public var startRow:Int;
    

}