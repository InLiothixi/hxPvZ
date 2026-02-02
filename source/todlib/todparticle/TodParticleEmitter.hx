package todlib.todparticle;

import cpp.Pointer;
import flixel.FlxG;
import flixel.math.FlxAngle;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import openfl.display.BlendMode;
import sexyappbase.DescParser.DoubleRef;
import sexyappbase.Graphics;
import sexyappbase.Image;
import todlib.filtereffect.FilterEffectType;
import todlib.todparticle.TodParticleSystem;

class TodParticleEmitter 
{
    public var emitterDef:TodEmitterDefinition;    
    public var particleSystem:TodParticleSystem;
    public var particleList:Array<TodParticle>;
    public var spawnAccum:Float;
    public var systemCenter:FlxPoint;
    public var particlesSpawned:Int;
    public var systemAge:Float;
    public var systemDuration:Float;
    public var systemTimeValue:Float;
    public var systemLastTimeValue:Float;
    public var dead:Bool;
    public var colorOverride:FlxColor;
    public var extraAdditiveColor:FlxColor;
    public var extraAdditiveDrawOverride:Bool;
    public var scaleOverride:Float;
    public var imageOverride:Image;
    public var crossFadeEmitter:TodParticleEmitter;
    public var emitterCrossFadeCountDown:Float;
    public var frameOverride:Int;
    public var trackInterp:Array<Float>;
    public var systemFieldInterp:Array<Array<Float>>;
    public var filterEffect:FilterEffectType;

    public function new() {}

    public function todEmittterInitialize(x:Float, y:Float, system:TodParticleSystem, emitterDef:TodEmitterDefinition)
    {
        particleSystem = system;
        this.emitterDef = emitterDef;
        spawnAccum = 0;
        systemCenter = FlxPoint.get(x, y);
        particlesSpawned = 0;
        systemTimeValue = -1;
        systemLastTimeValue = -1;
        systemAge = -1;
        systemDuration = 0;
        dead = false;
        colorOverride = FlxColor.WHITE;
        extraAdditiveColor = FlxColor.WHITE;
        extraAdditiveDrawOverride = false;
        scaleOverride = 1;
        particleList = [];
        filterEffect = FilterEffectType.NONE;

        if (FloatParameterTrack.floatTrackIsSet(emitterDef.systemDuration))
        {
            systemDuration = FloatParameterTrack.floatTrackEvaluate(emitterDef.systemDuration, 0, FlxG.random.float());
        }
        else 
        {
            systemDuration = FloatParameterTrack.floatTrackEvaluate(emitterDef.particleDuration, 0, 1);
        }
        systemDuration = Math.max(1, systemDuration);

        systemFieldInterp = [[]];
        for (i in 0...emitterDef.systemFields.length)
        {
            systemFieldInterp[i][0] = FlxG.random.float();
            systemFieldInterp[i][1] = FlxG.random.float();
        }

        trackInterp = [];
        for (j in 0...10)
        {
            trackInterp[j] = FlxG.random.float();
        }
    }

    public function deleteAll()
    {
        for (particle in particleList)
        {
            particleSystem.particleHolder.particles.remove(particle);
            particleList.remove(particle);
        }
    }

    public function spawnParticle(index:Int, spawnCount:Int, elapsed:Float)
    {
        var aParticle = new TodParticle();

        for (i in 0...emitterDef.particleFields.length)
        {
            aParticle.particleFieldInterp[i][0] = FlxG.random.float();
            aParticle.particleFieldInterp[i][1] = FlxG.random.float();
        }
        for (i in 0...ParticleTracks.NUM_PARTICLE_TRACKS)
        {
            aParticle.particleInterp[i] = FlxG.random.float();
        }

        var aParticleDurationInterp = FlxG.random.float();
        var aLaunchSpeedInterp = FlxG.random.float();
        var aEmitterOffsetXInterp = FlxG.random.float();
        var aEmitterOffsetYInterp = FlxG.random.float();

        aParticle.particleDuration = FloatParameterTrack.floatTrackEvaluate(emitterDef.particleDuration, systemTimeValue, aParticleDurationInterp);
        aParticle.particleDuration = Math.max(1, aParticle.particleDuration);
        aParticle.particleAge = 0;
        aParticle.particleEmitter = this;
        aParticle.particleTimeValue = -1;
        aParticle.particleLastTimeValue = -1;
        
        if (TodCommon.testBit(emitterDef.particleFlags, ParticleFlags.RANDOM_START_TIME))
        {
            aParticle.particleAge = FlxG.random.float(0, aParticle.particleDuration);
        }

        var aLaunchSpeed = FloatParameterTrack.floatTrackEvaluate(emitterDef.launchSpeed, systemTimeValue, aLaunchSpeedInterp) * elapsed;
        var aLaunchAngleInterp = FlxG.random.float();

        var aLaunchAngle:Float = 0;
        if (emitterDef.emitterType == EmitterType.CIRCLE_PATH)
        {
            aLaunchAngle = FloatParameterTrack.floatTrackEvaluate(emitterDef.emitterPath, systemTimeValue, trackInterp[ParticleSystemTracks.EMITTER_PATH]) * 2 * Math.PI;
            aLaunchAngle += FlxAngle.TO_RAD *  FloatParameterTrack.floatTrackEvaluate(emitterDef.launchAngle, systemTimeValue, aLaunchAngleInterp);
        }
        else if (emitterDef.emitterType == EmitterType.CIRCLE_EVEN_SPACING)
        {
            aLaunchAngle = 2 * Math.PI * index / spawnCount + FlxAngle.TO_RAD * FloatParameterTrack.floatTrackEvaluate(emitterDef.launchAngle, systemTimeValue, aLaunchAngleInterp);
        }
        else if (FloatParameterTrack.floatTrackIsConstantZero(emitterDef.launchAngle))
        {
            aLaunchAngle = FlxG.random.float(0, 2 * Math.PI);
        }
        else
        {
            aLaunchAngle = FlxAngle.TO_RAD *  FloatParameterTrack.floatTrackEvaluate(emitterDef.launchAngle, systemTimeValue, aLaunchAngleInterp);
        }

        var aPosX:Float = 0;
        var aPosY:Float = 0;

        switch(emitterDef.emitterType)
        {
            case EmitterType.CIRCLE | EmitterType.CIRCLE_PATH | EmitterType.CIRCLE_EVEN_SPACING:
                var emitterRadiusInterp = FlxG.random.float();
                var aRadius = FloatParameterTrack.floatTrackEvaluate(emitterDef.emitterRadius, systemTimeValue, emitterRadiusInterp);

                aPosX = Math.sin(aLaunchAngle) * aRadius;
                aPosY = Math.cos(aLaunchAngle) * aRadius;

            case EmitterType.BOX:
                var aEmitterBoxXInterp = FlxG.random.float();
                var aEmitterBoxYInterp = FlxG.random.float();

                aPosX = FloatParameterTrack.floatTrackEvaluate(emitterDef.emitterBoxX, systemTimeValue, aEmitterBoxXInterp);
                aPosY = FloatParameterTrack.floatTrackEvaluate(emitterDef.emitterBoxY, systemTimeValue, aEmitterBoxYInterp);

            case EmitterType.BOX_PATH:
                var aEmitterPathPosition = FloatParameterTrack.floatTrackEvaluate(emitterDef.emitterPath, systemTimeValue, trackInterp[ParticleSystemTracks.EMITTER_PATH]);
                var aMinX = FloatParameterTrack.floatTrackEvaluate(emitterDef.emitterBoxX, systemTimeValue, 0);
                var aMaxX = FloatParameterTrack.floatTrackEvaluate(emitterDef.emitterBoxX, systemTimeValue, 1);
                var aMinY = FloatParameterTrack.floatTrackEvaluate(emitterDef.emitterBoxY, systemTimeValue, 0);
                var aMaxY = FloatParameterTrack.floatTrackEvaluate(emitterDef.emitterBoxY, systemTimeValue, 1);
                var aDistanceX = aMaxX - aMinX;
                var aDistanceY = aMaxY - aMinY;
                var aPathPos = aEmitterPathPosition * (aDistanceY + aDistanceX + aDistanceY + aDistanceX);
                if (aPathPos < aDistanceY)
                {
                    aPosX = aMinX;
                    aPosY = aMinY + aPathPos;
                }
                else if (aPathPos < aDistanceY + aDistanceX)
                {
                    aPosX = aMinX + (aPathPos - aDistanceY);
                    aPosY = aMaxY;
                }
                else if (aPathPos < aDistanceY + aDistanceX + aDistanceY)
                {
                    aPosX = aMaxX;
                    aPosY = aMaxY - (aPathPos - aDistanceY - aDistanceX);
                }
                else 
                {
                    aPosX = aMaxX - (aPathPos - aDistanceY - aDistanceX - aDistanceY);
                    aPosY = aMinY;
                }
                default:
        }

        var aEmitterSkewXInterp = FlxG.random.float();
        var aEmitterSkewYInterp = FlxG.random.float();
        var aSkewX = FloatParameterTrack.floatTrackEvaluate(emitterDef.emitterSkewX, systemTimeValue, aEmitterSkewXInterp);
        var aSkewY = FloatParameterTrack.floatTrackEvaluate(emitterDef.emitterSkewY, systemTimeValue, aEmitterSkewYInterp);
        aParticle.position.x = systemCenter.x + aPosX + aPosY * aSkewX;
        aParticle.position.y = systemCenter.y + aPosY + aPosX * aSkewY;
        aParticle.velocity.x = Math.sin(aLaunchAngle) * aLaunchSpeed;
        aParticle.velocity.y = Math.cos(aLaunchAngle) * aLaunchSpeed;
        aParticle.position.x += FloatParameterTrack.floatTrackEvaluate(emitterDef.emitterOffsetX, systemTimeValue, aEmitterOffsetXInterp);
        aParticle.position.y += FloatParameterTrack.floatTrackEvaluate(emitterDef.emitterOffsetY, systemTimeValue, aEmitterOffsetYInterp);
        aParticle.animationTimeValue = 0;
        
        if (emitterDef.animated || FloatParameterTrack.floatTrackIsSet(emitterDef.animRate))
        {
            aParticle.imageFrame = 0;
        }
        else 
        {
            aParticle.imageFrame = FlxG.random.int(0, emitterDef.imageFrames);
        }

        if (TodCommon.testBit(emitterDef.particleFlags, ParticleFlags.RANDOM_LAUNCH_SPIN))
        {
            aParticle.spinPosition = FlxG.random.float(2 * Math.PI);
        }
        else if (TodCommon.testBit(emitterDef.particleFlags, ParticleFlags.ALIGN_LAUNCH_SPIN))
        {
            aParticle.spinPosition = aLaunchAngle;
        }
        else 
        {
            aParticle.spinPosition = 0;
        }
        aParticle.spinVelocity = 0;
        aParticle.crossFadeDuration = 0;
        particleSystem.particleHolder.particles.push(aParticle);
        particleList.push(aParticle);
        return aParticle;
    }

    public function update(elapsed:Float)
    {
        if (dead)   return;

        systemAge += elapsed;
        
        var aDie = false;
        if (systemAge >= systemDuration)
        {
            if (TodCommon.testBit(emitterDef.particleFlags, ParticleFlags.SYSTEM_LOOPS))
            {
                systemAge = 0;
            }
            else 
            {
                systemAge = systemDuration - elapsed;
                aDie = true;
            }
        }

        if (emitterCrossFadeCountDown > 0)
        {
            emitterCrossFadeCountDown -= elapsed;
            if (emitterCrossFadeCountDown <= 0)
            {
                aDie = true;
            }
        }

        if (crossFadeEmitter == null || crossFadeEmitter != null && crossFadeEmitter.dead)
        {
            aDie = true;
        }

        systemTimeValue = systemAge / (systemDuration - elapsed);
        for (i in 0...emitterDef.systemFields.length)
        {
            updateSystemField(emitterDef.systemFields[i], systemTimeValue, i);
        }
        for (aParticle in particleList)
        {
            if (!updateParticle(aParticle, elapsed))
            {
                deleteParticle(aParticle);
            }
        }
        updateSpawning(elapsed);

        if (aDie)
        {
            deleteNonCrossFading();
            if (particleList.length == 0)
            {
                dead = true;
                return;
            }
        }
        systemLastTimeValue = systemTimeValue;
    }

    public function deleteNonCrossFading()
    {
        for (particle in particleList)
        {
            if (particle.crossFadeDuration <= 0)
            {
                deleteParticle(particle);
            }
        }
    }

    public function deleteParticle(particle:TodParticle)
    {
        var aIndex = particleSystem.particleHolder.particles.indexOf(particle.crossFadeParticle);
        if (aIndex != -1)
        {
            var aCrossFadeParticle = particleSystem.particleHolder.particles[aIndex];
            aCrossFadeParticle.particleEmitter.deleteParticle(aCrossFadeParticle);
            particle.crossFadeParticle = null;
        }

        particleList.remove(particle);
        particleSystem.particleHolder.particles.remove(particle);
    }

    public function updateParticleField(particle:TodParticle, particleField:ParticleField, particleTimeValue:Float, fieldIndex:Int, elapsed:Float)
    {
        var aInterpX = particle.particleFieldInterp[fieldIndex][0];
        var aInterpY = particle.particleFieldInterp[fieldIndex][1];
        var x = FloatParameterTrack.floatTrackEvaluate(particleField.x, particleTimeValue, aInterpX);
        var y = FloatParameterTrack.floatTrackEvaluate(particleField.y, particleTimeValue, aInterpY);

        switch (particleField.fieldType)
        {
            case ParticleFieldType.FRICTION:
                particle.velocity.x *= 1 - x;
                particle.velocity.y *= 1 - y;

            case ParticleFieldType.ACCELERATION:
                particle.velocity.x += elapsed * x;
                particle.velocity.y += elapsed * y;

            case ParticleFieldType.ATTRACTOR:
                var aDiffX = x - (particle.position.x - systemCenter.x);
                var aDiffY = y - (particle.position.y - systemCenter.y);
                particle.velocity.x += elapsed * aDiffX;
                particle.velocity.y += elapsed * aDiffY;

            case ParticleFieldType.MAX_VELOCITY:
                particle.velocity.x = FlxMath.bound(particle.velocity.x, -x, x);
                particle.velocity.y = FlxMath.bound(particle.velocity.y, -y, y);

            case ParticleFieldType.VELOCITY:
                particle.position.x += elapsed * x;
                particle.position.y += elapsed * y;

            case ParticleFieldType.POSITION:
                var aLastX = FloatParameterTrack.floatTrackEvaluateFromLastTime(particleField.x, particle.particleLastTimeValue, aInterpX);
                var aLastY = FloatParameterTrack.floatTrackEvaluateFromLastTime(particleField.y, particle.particleLastTimeValue, aInterpY);
                particle.position.x += x - aLastX;
                particle.position.y += y - aLastY;

            case ParticleFieldType.GROUND_CONSTRAINT:
                if (particle.position.y > systemCenter.y + y)
                {
                    particle.position.y = systemCenter.y + y;
                    var aCollisionReflect = FloatParameterTrack.floatTrackEvaluate(emitterDef.collisionReflect, particleTimeValue, particle.particleInterp[ParticleTracks.COLLISION_REFLECT]);
                    var aCollisionSpin = FloatParameterTrack.floatTrackEvaluate(emitterDef.collisionSpin, particleTimeValue, particle.particleInterp[ParticleTracks.COLLISION_SPIN]) / 1000.0;
                    particle.spinVelocity = particle.velocity.y * aCollisionSpin;
                    particle.velocity.x *= aCollisionReflect;
                    particle.velocity.y *= -aCollisionReflect;
                }
            
            case ParticleFieldType.SHAKE:
                var aLastX = FloatParameterTrack.floatTrackEvaluateFromLastTime(particleField.x, particle.particleLastTimeValue, aInterpX);
                var aLastY = FloatParameterTrack.floatTrackEvaluateFromLastTime(particleField.y, particle.particleLastTimeValue, aInterpY);
                var aLastRandSeed = particle.particleAge - elapsed;
                if (Math.floor(aLastRandSeed) == -1)
                    aLastRandSeed = particle.particleDuration - elapsed;

                var particlePtr:Int = untyped __cpp__('(uintptr_t)&{0}', particle);

                var rand = new FlxRandom(Math.floor(aLastRandSeed) * particlePtr);
                particle.position.x -= aLastX * (rand.float() * 2.0 - elapsed);
                particle.position.y -= aLastY * (rand.float() * 2.0 - elapsed);
                rand.initialSeed = Math.floor(particle.particleAge) * particlePtr;
                particle.position.x += x * (rand.float() * 2.0 - elapsed);
                particle.position.y += y * (rand.float() * 2.0 - elapsed);

            case ParticleFieldType.CIRCLE | ParticleFieldType.AWAY:
                var aToCenter = particle.position - systemCenter;
                var aMotion = new FlxPoint(-aToCenter.y, aToCenter.x);
                aMotion.normalize();
                var aRadius = aToCenter.length;
                aMotion *= elapsed * (x + aRadius * y);
                particle.position += aMotion;
    
            default:
        }
    }

    public function updateParticle(particle:TodParticle, elapsed:Float)
    {
        if (particle.particleAge >= particle.particleDuration)
        {
            if (TodCommon.testBit(emitterDef.particleFlags, ParticleFlags.PARTICLE_LOOPS))
            {
                particle.particleAge = 0;
            }
            else if (particle.crossFadeDuration > 0)
            {
                particle.particleAge = particle.particleDuration - elapsed;
            }
            else if (emitterDef.onDuration == String.fromCharCode(0) || crossFadeParticleToName(particle, emitterDef.onDuration, elapsed))
            {
                return false;
            }
        }
        if (particle.crossFadeParticle != null && !particleSystem.particleHolder.particles.contains(particle.crossFadeParticle))
        {
            return false;
        }
        particle.particleTimeValue = particle.particleAge / (particle.particleDuration - elapsed);
        for (i in 0...emitterDef.particleFields.length)
        {
            updateParticleField(particle, emitterDef.particleFields[i], particle.particleTimeValue, i, elapsed);
        }
        particle.position += particle.velocity;
        var aSpinSpeed = particleTrackEvaluate(emitterDef.particleSpinSpeed, particle, ParticleTracks.SPIN_SPEED) * elapsed;
        var aSpinAngle = particleTrackEvaluate(emitterDef.particleSpinSpeed, particle, ParticleTracks.SPIN_ANGLE);
        var aLastSpinAngle = FloatParameterTrack.floatTrackEvaluateFromLastTime(emitterDef.particleSpinAngle, particle.particleLastTimeValue, particle.particleInterp[ParticleTracks.SPIN_ANGLE]);
        particle.spinPosition += FlxAngle.TO_RAD * (aSpinSpeed + aSpinAngle - aLastSpinAngle) + particle.spinVelocity;
        
        if (FloatParameterTrack.floatTrackIsSet(emitterDef.animRate))
        {
            var aAnimTime = particleTrackEvaluate(emitterDef.animRate, particle, ParticleTracks.ANIMATION_RATE) * elapsed;
            particle.animationTimeValue += aAnimTime;
            while (particle.animationTimeValue >= 1.0)
            {
                particle.animationTimeValue -= 1;
            }
            while (particle.animationTimeValue < 0.0) 
            {
                particle.animationTimeValue += 1;
            }
        }

        particle.particleAge += elapsed;
        particle.particleLastTimeValue = particle.particleTimeValue;
        return true;
    }

    public function crossFadeParticleToName(particle:TodParticle, emitterName:String, elapsed:Float)
    {
        var aDef = particleSystem.findEmitterDefByName(emitterName);
        if (aDef == null)
        {
            #if debug
            trace('Can\'t find emitter to cross fade: $emitterName');
            #end
            return false;
        }

        var aEmitter = new TodParticleEmitter();
        aEmitter.todEmittterInitialize(systemCenter.x, systemCenter.y, particleSystem, aDef);
        particleSystem.emitterList.push(aEmitter);
        return crossFadeParticle(particle, aEmitter, elapsed);
    }

    public function crossFadeParticle(particle:TodParticle, toEmitter:TodParticleEmitter, elapsed:Float) 
    {
        if (particle.crossFadeDuration > 0)
        {
            #if debug
            trace("We don't support cross fading more than one at a time");
            #end
            return false;
        }
        if (!FloatParameterTrack.floatTrackIsSet(toEmitter.emitterDef.crossFadeDuration))
        {
            #if debug
            trace("Can't cross fade to emitter that doesn't have CrossFadeDuration");
            #end
            return false;
        }

        var aToParticle = toEmitter.spawnParticle(0, 1, elapsed);
        if (aToParticle == null)
        {
            return false;
        }
        if (emitterCrossFadeCountDown > 0)
        {
            particle.crossFadeDuration = emitterCrossFadeCountDown;
        }
        else 
        {
            var aCrossFadeDurationInterp = FlxG.random.float();
            var aCrossFadeDuration = FloatParameterTrack.floatTrackEvaluate(toEmitter.emitterDef.crossFadeDuration, systemTimeValue, aCrossFadeDurationInterp);
            particle.crossFadeDuration = Math.max(1, aCrossFadeDuration);
        }
        if (!FloatParameterTrack.floatTrackIsSet(toEmitter.emitterDef.particleDuration))
        {
            aToParticle.particleDuration = aToParticle.crossFadeDuration;
        }
        aToParticle.crossFadeParticle = particle;
        return true;
    }

    public function particleTrackEvaluate(track:FloatParameterTrack, particle:TodParticle, particleTrack:ParticleTracks)
    {
        return FloatParameterTrack.floatTrackEvaluate(track, particle.particleTimeValue, particle.particleInterp[particleTrack]);
    }

    public function updateSystemField(particleField:ParticleField, particleTimeValue:Float, fieldIndex:Int)
    {
        var aInterpX = systemFieldInterp[fieldIndex][0];
        var aInterpY = systemFieldInterp[fieldIndex][1];
        var x = FloatParameterTrack.floatTrackEvaluate(particleField.x, particleTimeValue, aInterpX);
        var y = FloatParameterTrack.floatTrackEvaluate(particleField.y, particleTimeValue, aInterpY);

        switch (particleField.fieldType)
        {
            case ParticleFieldType.SYSTEM_POSITION:
                var aLastX = FloatParameterTrack.floatTrackEvaluateFromLastTime(particleField.x, systemLastTimeValue, aInterpX);
                var aLastY = FloatParameterTrack.floatTrackEvaluateFromLastTime(particleField.y, systemLastTimeValue, aInterpY);
                systemCenter.x += x - aLastX;
                systemCenter.y += y - aLastY;
                
            default: 
        }
    }

    public function systemTrackEvaluate(track:FloatParameterTrack, systemTrack:ParticleSystemTracks)
    {
        return FloatParameterTrack.floatTrackEvaluate(track, systemTimeValue, trackInterp[systemTrack]);
    }

    public function updateSpawning(elapsed:Float)
    {
        var aCrossFadeEmitter = crossFadeEmitter;
        var aSpawningEmitter = aCrossFadeEmitter == null ? this : aCrossFadeEmitter;
        spawnAccum += aSpawningEmitter.systemTrackEvaluate(aSpawningEmitter.emitterDef.spawnRate, ParticleSystemTracks.SPAWNRATE) * elapsed;
        var aSpawnCount = Math.floor(spawnAccum);
        spawnAccum -= aSpawnCount;

        var aSpawnMinActive = Math.floor(aSpawningEmitter.systemTrackEvaluate(aSpawningEmitter.emitterDef.spawnMinActive, ParticleSystemTracks.SPAWN_MIN_ACTIVE));
        if (aSpawnMinActive >= 0 && aSpawnCount < aSpawnMinActive - particleList.length)
        {
            aSpawnCount = aSpawnMinActive - particleList.length;
        }
        var aSpawnMaxActive = Math.floor(aSpawningEmitter.systemTrackEvaluate(aSpawningEmitter.emitterDef.spawnMaxActive, ParticleSystemTracks.SPAWN_MAX_ACTIVE));
        if (aSpawnMaxActive >= 0 && aSpawnCount > aSpawnMaxActive - particleList.length)
        {
            aSpawnCount = aSpawnMaxActive - particleList.length;
        }
        if (FloatParameterTrack.floatTrackIsSet(aSpawningEmitter.emitterDef.spawnMaxLaunched))
        {
            var aSpawnMaxLaunched = aSpawningEmitter.systemTrackEvaluate(aSpawningEmitter.emitterDef.spawnMaxLaunched, ParticleSystemTracks.SPAWN_MAX_LAUNCHED);
            if (aSpawnCount > Math.floor(aSpawnMaxLaunched) - particlesSpawned)
                aSpawnCount = Math.floor(aSpawnMaxLaunched) - particlesSpawned;
        }

        for (i in 0...aSpawnCount)
        {
            var aParticle = spawnParticle(i, aSpawnCount, elapsed);
            if (aCrossFadeEmitter != null)
                crossFadeParticle(aParticle, aCrossFadeEmitter, elapsed);
        }
    }

    public function crossFadeLerp(from:Float, to:Float, fromIsSet:Bool, toIsSet:Bool, fraction:Float)
    {
        if (!fromIsSet)
        {
            return to;
        }
        if (!toIsSet)
        {
            return from;
        }
        return from + (to - from) * fraction;
    }

    public function getRenderParams(particle:TodParticle, params:ParticleRenderParams)
    {
        var aEmitter = particle.particleEmitter;
        var aDef = aEmitter.emitterDef;

        params.redIsSet = false;
        {
            var check = 0;
            check |= (FloatParameterTrack.floatTrackIsSet(aDef.systemRed) ? 1 : 0);
            check |= (FloatParameterTrack.floatTrackIsSet(aDef.particleRed) ? 1 : 0);
            check |= aEmitter.colorOverride.redFloat != 1.0 ? 1 : 0;
            params.redIsSet = check != 0;
        }

        params.greenIsSet = false;
        {
            var check = 0;
            check |= (FloatParameterTrack.floatTrackIsSet(aDef.systemGreen) ? 1 : 0);
            check |= (FloatParameterTrack.floatTrackIsSet(aDef.particleGreen) ? 1 : 0);
            check |= aEmitter.colorOverride.greenFloat != 1.0 ? 1 : 0;
            params.greenIsSet = check != 0;
        }

        params.blueIsSet = false;
        {
            var check = 0;
            check |= (FloatParameterTrack.floatTrackIsSet(aDef.systemBlue) ? 1 : 0);
            check |= (FloatParameterTrack.floatTrackIsSet(aDef.particleBlue) ? 1 : 0);
            check |= aEmitter.colorOverride.blueFloat != 1.0 ? 1 : 0;
            params.blueIsSet = check != 0;
        }

        params.alphaIsSet = false;
        {
            var check = 0;
            check |= (FloatParameterTrack.floatTrackIsSet(aDef.systemAlpha) ? 1 : 0);
            check |= (FloatParameterTrack.floatTrackIsSet(aDef.particleAlpha) ? 1 : 0);
            check |= aEmitter.colorOverride.alphaFloat != 1.0 ? 1 : 0;
            params.alphaIsSet = check != 0;
        }

        params.particleScaleIsSet = false;
        {
            var check = 0;
            check |= (FloatParameterTrack.floatTrackIsSet(aDef.particleScale) ? 1 : 0);
            check |= aEmitter.scaleOverride != 1.0 ? 1 : 0;
            params.particleScaleIsSet = check != 0;
        }

        params.particleStretchIsSet = FloatParameterTrack.floatTrackIsSet(aDef.particleStretch);
       
        params.spinPositionIsSet = false;
        {
            var check = 0;
            check |= (FloatParameterTrack.floatTrackIsSet(aDef.particleSpinSpeed) ? 1 : 0);
            check |= (FloatParameterTrack.floatTrackIsSet(aDef.particleSpinAngle) ? 1 : 0);
            check |= TodCommon.testBit(aDef.particleFlags, ParticleFlags.RANDOM_LAUNCH_SPIN) ? 1 : 0;
            check |= TodCommon.testBit(aDef.particleFlags, ParticleFlags.ALIGN_LAUNCH_SPIN) ? 1 : 0;
            params.spinPositionIsSet = check != 0;
        }

        params.positionIsSet = false;
        {
            var check = 0;
            check |= (aDef.particleFields.length > 0) ? 1 : 0;
            check |= (FloatParameterTrack.floatTrackIsSet(aDef.emitterRadius) ? 1 : 0);
            check |= (FloatParameterTrack.floatTrackIsSet(aDef.emitterOffsetX) ? 1 : 0);
            check |= (FloatParameterTrack.floatTrackIsSet(aDef.emitterOffsetY) ? 1 : 0);
            check |= (FloatParameterTrack.floatTrackIsSet(aDef.emitterBoxX) ? 1 : 0);
            check |= (FloatParameterTrack.floatTrackIsSet(aDef.emitterBoxY) ? 1 : 0);
            params.positionIsSet = check != 0;
        }

        var aSystemRed = aEmitter.systemTrackEvaluate(aDef.systemRed, ParticleSystemTracks.SYSTEM_RED);
        var aSystemGreen = aEmitter.systemTrackEvaluate(aDef.systemGreen, ParticleSystemTracks.SYSTEM_GREEN);
        var aSystemBlue = aEmitter.systemTrackEvaluate(aDef.systemBlue, ParticleSystemTracks.SYSTEM_BLUE);
        var aSystemAlpha = aEmitter.systemTrackEvaluate(aDef.systemAlpha, ParticleSystemTracks.SYSTEM_ALPHA);
        var aSystemBrightness = aEmitter.systemTrackEvaluate(aDef.systemBrightness, ParticleSystemTracks.SYSTEM_BRIGHTNESS);
        var aParticleRed = aEmitter.particleTrackEvaluate(aDef.particleRed, particle, ParticleTracks.RED);
        var aParticleGreen = aEmitter.particleTrackEvaluate(aDef.particleGreen, particle, ParticleTracks.GREEN);
        var aParticleBlue = aEmitter.particleTrackEvaluate(aDef.particleBlue, particle, ParticleTracks.BLUE);
        var aParticleAlpha = aEmitter.particleTrackEvaluate(aDef.particleAlpha, particle, ParticleTracks.ALPHA);
        var aParticleBrightness = aEmitter.particleTrackEvaluate(aDef.particleBrightness, particle, ParticleTracks.BRIGHTNESS);
        var aBrightness = aParticleBrightness * aSystemBrightness;
        params.red = aParticleRed * aSystemRed * aEmitter.colorOverride.redFloat * aBrightness;
        params.green = aParticleGreen * aSystemGreen * aEmitter.colorOverride.greenFloat * aBrightness;
        params.blue = aParticleBlue * aSystemBlue * aEmitter.colorOverride.blueFloat * aBrightness;
        params.alpha = aParticleAlpha * aSystemAlpha * aEmitter.colorOverride.alpha;
        params.extraAdditiveRed = aParticleRed * aSystemRed * aEmitter.extraAdditiveColor.redFloat * aBrightness;
        params.extraAdditiveGreen = aParticleGreen * aSystemGreen * aEmitter.extraAdditiveColor.greenFloat * aBrightness;
        params.extraAdditiveBlue = aParticleBlue * aSystemBlue * aEmitter.extraAdditiveColor.blueFloat * aBrightness;
        params.extraAdditiveAlpha = aParticleAlpha * aSystemAlpha * aEmitter.extraAdditiveColor.alpha;
        params.posX = particle.position.x;
        params.posY = particle.position.y;
        var aParticleScale = aEmitter.particleTrackEvaluate(aDef.particleScale, particle, ParticleTracks.SCALE);
        params.particleStretch = aEmitter.particleTrackEvaluate(aDef.particleStretch, particle, ParticleTracks.STRETCH);
        params.particleScale = aParticleScale * aEmitter.scaleOverride;
        params.spinPosition = particle.spinPosition;

        params.filterEffect = FilterEffectType.NONE;
        if (aEmitter.filterEffect != FilterEffectType.NONE)
        {
            params.filterEffect = aEmitter.filterEffect;
        }

        var aCrossFadeParticle = particle.crossFadeParticle;
        if (aCrossFadeParticle != null)
        {
            var aCrossFadeParams = new ParticleRenderParams();
            if (getRenderParams(aCrossFadeParticle, aCrossFadeParams))
            {
                var aFraction = particle.particleAge / (aCrossFadeParticle.crossFadeDuration - FlxG.elapsed);
                params.red = crossFadeLerp(aCrossFadeParams.red, params.red, aCrossFadeParams.redIsSet, params.redIsSet, aFraction);
                params.green = crossFadeLerp(aCrossFadeParams.green, params.green, aCrossFadeParams.greenIsSet, params.greenIsSet, aFraction);
                params.blue = crossFadeLerp(aCrossFadeParams.blue, params.blue, aCrossFadeParams.blueIsSet, params.blueIsSet, aFraction);
                params.alpha = crossFadeLerp(aCrossFadeParams.alpha, params.alpha, aCrossFadeParams.alphaIsSet, params.alphaIsSet, aFraction);
                params.particleScale = crossFadeLerp(
                    aCrossFadeParams.particleScale, params.particleScale, aCrossFadeParams.particleScaleIsSet, params.particleScaleIsSet, aFraction
                );
                params.particleStretch = crossFadeLerp(
                    aCrossFadeParams.particleStretch, params.particleStretch, aCrossFadeParams.particleStretchIsSet, params.particleStretchIsSet, aFraction
                );
                params.spinPosition = crossFadeLerp(
                    aCrossFadeParams.spinPosition, params.spinPosition, aCrossFadeParams.spinPositionIsSet, params.spinPositionIsSet, aFraction
                );
                params.posX = crossFadeLerp(aCrossFadeParams.posX, params.posX, aCrossFadeParams.positionIsSet, params.positionIsSet, aFraction);
                params.posY = crossFadeLerp(aCrossFadeParams.posY, params.posY, aCrossFadeParams.positionIsSet, params.positionIsSet, aFraction);
                params.redIsSet = params.redIsSet || aCrossFadeParams.redIsSet;
                params.greenIsSet = params.greenIsSet || aCrossFadeParams.greenIsSet;
                params.blueIsSet = params.blueIsSet || aCrossFadeParams.blueIsSet;
                params.alphaIsSet = params.alphaIsSet || aCrossFadeParams.alphaIsSet;
                params.particleScaleIsSet = params.particleScaleIsSet || aCrossFadeParams.particleScaleIsSet;
                params.particleStretchIsSet = params.particleStretchIsSet || aCrossFadeParams.particleStretchIsSet;
                params.spinPositionIsSet = params.spinPositionIsSet || aCrossFadeParams.spinPositionIsSet;
                params.positionIsSet = params.positionIsSet || aCrossFadeParams.positionIsSet;
            }
        }

        return true;
    }

    public static function filterColorDoLumSat(color:FlxColor, lum:Float, sat:Float)
    {
        var r = new DoubleRef(color.redFloat);
        var g = new DoubleRef(color.greenFloat);
        var b = new DoubleRef(color.blueFloat);
        var a = new DoubleRef(color.alphaFloat);

        var h = new DoubleRef(0);
        var s = new DoubleRef(0);
        var l = new DoubleRef(0);

        FilterEffect.rgb_to_hsl(r, g, b, h, s, l);
        s.value *= sat;
        l.value *= lum;
        FilterEffect.hsl_to_rgb(h, s, l, r, g, b);

        var result = FlxColor.fromRGBFloat(r.value, g.value, b.value, a.value);
        return result;
    }

    public function drawParticle(g:Graphics, particle:TodParticle)
    {
        if (particle.crossFadeDuration > 0)
        {
            return;
        }

        var aParams = new ParticleRenderParams();
        if (getRenderParams(particle, aParams))
        {
            var aColor = FlxColor.fromRGB(
                Math.round(aParams.red), 
                Math.round(aParams.green), 
                Math.round(aParams.blue), 
                Math.round(aParams.alpha)
            );

            if (aColor.alpha > 0)
            {
                aParams.posX += g.trans.x;
                aParams.posY += g.trans.y;

                if (aParams.filterEffect == FilterEffectType.WASHED_OUT)
                {
                    aColor = filterColorDoLumSat(aColor, 1.8, 0.2);
                }
                else if (aParams.filterEffect == FilterEffectType.LESS_WASHED_OUT)
                {
                    aColor = filterColorDoLumSat(aColor, 1.2, 0.3);
                }

                var aParticle:TodParticle = null;
                if (imageOverride != null || emitterDef.image != null)
                {
                    aParticle = particle;
                }
                else 
                {
                    aParticle = particle.crossFadeParticle;
                }

                if (aParticle != null)
                {
                    renderParticle(g, particle, aColor, aParams);
                }
            }

            var aExtraAdditiveColor = FlxColor.fromRGB(
                Math.round(aParams.extraAdditiveRed), 
                Math.round(aParams.extraAdditiveGreen), 
                Math.round(aParams.extraAdditiveBlue), 
                Math.round(aParams.extraAdditiveAlpha)
            );
        }
    }

    public function renderParticle(g:Graphics, particle:TodParticle, color:FlxColor, params:ParticleRenderParams)
    {
        var aEmitter = particle.particleEmitter;
        var aEmitterDef = aEmitter.emitterDef;
        var aImage = aEmitter.imageOverride ?? aEmitterDef.image;
        if (aImage == null) {
            return;
        }

        if (params.filterEffect != FilterEffectType.NONE) {
            aImage.bmp = FilterEffect.filterEffectGetImage(aImage.bmp, params.filterEffect);
        }

        var aCelWidth = aImage.getCelWidth();
        var aCelHeight = aImage.getCelHeight();
        var aFrame = aEmitter.frameOverride;

        if (aFrame == -1)
        {
            if (FloatParameterTrack.floatTrackIsSet(aEmitterDef.animRate))
            {
                aFrame = Math.floor(Math.min(Math.max(particle.animationTimeValue * aEmitterDef.imageFrames, 0), aEmitterDef.imageFrames - 1));
            } 
            else if (aEmitterDef.animated)
            {
                aFrame = Math.floor(Math.min(Math.max(particle.particleTimeValue * aEmitterDef.imageFrames, 0), aEmitterDef.imageFrames - 1));
            }
            else 
            {
                aFrame = particle.imageFrame;
            }
        }

        aFrame += aEmitterDef.imageCol;
        if (aFrame >= aImage.numCols) {
            aFrame = aImage.numCols - 1;
        }

        var aSrcRect = FlxRect.get(aFrame * aCelWidth, Math.min(aEmitterDef.imageRow, aImage.numRows - 1) * aCelHeight, aCelWidth, aCelHeight);
        var aClipTop = particleTrackEvaluate(aEmitterDef.clipTop, particle, ParticleTracks.CLIP_TOP);
        var aClipBottom = particleTrackEvaluate(aEmitterDef.clipBottom, particle, ParticleTracks.CLIP_BOTTOM);
        var aClipLeft = particleTrackEvaluate(aEmitterDef.clipLeft, particle, ParticleTracks.CLIP_LEFT);
        var aClipRight = particleTrackEvaluate(aEmitterDef.clipRight, particle, ParticleTracks.CLIP_RIGHT);
        params.posX += aClipLeft * aCelWidth;
        params.posY += aClipTop * aCelHeight;
        aSrcRect.x += Math.round(aClipLeft * aCelWidth);
        aSrcRect.y += Math.round(aClipTop * aCelHeight);
        aSrcRect.width -= Math.round(aCelWidth * (aClipLeft + aClipRight));
        aSrcRect.height -= Math.round(aCelHeight * (aClipBottom + aClipTop));

        if (TodCommon.testBit(aEmitterDef.particleFlags, ParticleFlags.ALIGN_TO_PIXELS)) 
        {
            params.posX = Math.round(params.posX);
            params.posY = Math.round(params.posY);
        }
        var aDrawMode = g.blendMode;

        if (TodCommon.testBit(aEmitterDef.particleFlags, ParticleFlags.ADDITIVE))
        {
            aDrawMode = BlendMode.ADD;
        }

        if (TodCommon.testBit(aEmitterDef.particleFlags, ParticleFlags.FULLSCREEN))
        {
            g.pushState();
            g.setColor(color);

            if (params.filterEffect == FilterEffectType.WASHED_OUT) {
                g.setColor(filterColorDoLumSat(color, 1.8, 0.2));
            } else if (params.filterEffect == FilterEffectType.LESS_WASHED_OUT) {
                g.setColor(filterColorDoLumSat(color, 1.2, 0.3));
            } else if (params.filterEffect == FilterEffectType.WHITE) {
                g.setColor(FlxColor.WHITE);
            }

            g.fillRect(FlxRect.get(-g.trans.x, -g.trans.y, FlxG.stage.width, FlxG.stage.height));
            g.popState();
            
        }


    }
}