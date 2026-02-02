package todlib;

import flixel.math.FlxPoint;
import lime.app.Application;
import openfl.utils.AssetType;
import openfl.utils.Assets;
import sexyappbase.DescParser.IntRef;
import sexyappbase.ImageLib;
import todlib.todcommon.TodCurves;
import todlib.todparticle.FloatParameterTrack;
import todlib.todparticle.FloatParameterTrackNode;
import todlib.todparticle.ParticleEffect;
import todlib.todparticle.ParticleField;
import todlib.todparticle.ParticleFieldType;
import todlib.todparticle.ParticleParams;
import todlib.todparticle.ParticleTracks;
import todlib.todparticle.TodEmitterDefinition;
import todlib.todparticle.TodParticleDefinition;
import todlib.todparticle.TodParticleEmitter;
import todlib.todparticle.TodParticleHolder;

using StringTools;

class TodParticle
{
    public static var lawnParticleArray:Array<ParticleParams> = [
        new ParticleParams(MELONSPLASH, "MelonImpact.xml"),
        new ParticleParams(WINTERMELON, "WinterMelonImpact.xml"),
        new ParticleParams(FUMECLOUD, "FumeCloud.xml"),
        new ParticleParams(POPCORNSPLASH, "PopcornSplash.xml"),
        new ParticleParams(POWIE, "Powie.xml"),
        new ParticleParams(JACKEXPLODE, "JackExplode.xml"),
        new ParticleParams(ZOMBIE_HEAD, "ZombieHead.xml"),
        new ParticleParams(ZOMBIE_ARM, "ZombieArm.xml"),
        new ParticleParams(ZOMBIE_TRAFFIC_CONE, "ZombieTrafficCone.xml"),
        new ParticleParams(ZOMBIE_PAIL, "ZombiePail.xml"),
        new ParticleParams(ZOMBIE_HELMET, "ZombieHelmet.xml"),
        new ParticleParams(ZOMBIE_FLAG, "ZombieFlag.xml"),
        new ParticleParams(ZOMBIE_DOOR, "ZombieDoor.xml"),
        new ParticleParams(ZOMBIE_NEWSPAPER, "ZombieNewspaper.xml"),
        new ParticleParams(ZOMBIE_HEADLIGHT, "ZombieHeadLight.xml"),
        new ParticleParams(POW, "Pow.xml"),
        new ParticleParams(ZOMBIE_POGO, "ZombiePogo.xml"),
        new ParticleParams(ZOMBIE_NEWSPAPER_HEAD, "ZombieNewspaperHead.xml"),
        new ParticleParams(ZOMBIE_BALLOON_HEAD, "ZombieBalloonHead.xml"),
        new ParticleParams(SOD_ROLL, "SodRoll.xml"),
        new ParticleParams(GRAVE_STONE_RISE, "GraveStoneRise.xml"),
        new ParticleParams(PLANTING, "Planting.xml"),
        new ParticleParams(PLANTING_POOL, "PlantingPool.xml"),
        new ParticleParams(ZOMBIE_RISE, "ZombieRise.xml"),
        new ParticleParams(GRAVE_BUSTER, "GraveBuster.xml"),
        new ParticleParams(GRAVE_BUSTER_DIE, "GraveBusterDie.xml"),
        new ParticleParams(POOL_SPLASH, "PoolSplash.xml"),
        new ParticleParams(ICE_SPARKLE, "IceSparkle.xml"),
        new ParticleParams(SEED_PACKET, "SeedPacket.xml"),
        new ParticleParams(TALL_NUT_BLOCK, "TallNutBlock.xml"),
        new ParticleParams(DOOM, "Doom.xml"),
        new ParticleParams(DIGGER_RISE, "DiggerRise.xml"),
        new ParticleParams(DIGGER_TUNNEL, "DiggerTunnel.xml"),
        new ParticleParams(DANCER_RISE, "DancerRise.xml"),
        new ParticleParams(POOL_SPARKLY, "PoolSparkly.xml"),
        new ParticleParams(WALLNUT_EAT_SMALL, "WallnutEatSmall.xml"),
        new ParticleParams(WALLNUT_EAT_LARGE, "WallnutEatLarge.xml"),
        new ParticleParams(PEA_SPLAT, "PeaSplat.xml"),
        new ParticleParams(SPIKE_SPLAT, "SpikeSplat.xml"),
        new ParticleParams(BUTTER_SPLAT, "ButterSplat.xml"),
        new ParticleParams(CABBAGE_SPLAT, "CabbageSplat.xml"),
        new ParticleParams(PUFF_SPLAT, "PuffSplat.xml"),
        new ParticleParams(STAR_SPLAT, "StarSplat.xml"),
        new ParticleParams(ICE_TRAP, "IceTrap.xml"),
        new ParticleParams(SNOWPEA_SPLAT, "SnowPeaSplat.xml"),
        new ParticleParams(SNOWPEA_PUFF, "SnowPeaPuff.xml"),
        new ParticleParams(SNOWPEA_TRAIL, "SnowPeaTrail.xml"),
        new ParticleParams(LANTERN_SHINE, "LanternShine.xml"),
        new ParticleParams(SEED_PACKET_PICKUP, "Award.xml"),
        new ParticleParams(POTATO_MINE, "PotatoMine.xml"),
        new ParticleParams(POTATO_MINE_RISE, "PotatoMineRise.xml"),
        new ParticleParams(PUFFSHROOM_TRAIL, "PuffShroomTrail.xml"),
        new ParticleParams(PUFFSHROOM_MUZZLE, "PuffShroomMuzzle.xml"),
        new ParticleParams(SEED_PACKET_FLASH, "SeedPacketFlash.xml"),
        new ParticleParams(WHACK_A_ZOMBIE_RISE, "WhackAZombieRise.xml"),
        new ParticleParams(ZOMBIE_LADDER, "ZombieLadder.xml"),
        new ParticleParams(UMBRELLA_REFLECT, "UmbrellaReflect.xml"),
        new ParticleParams(SEED_PACKET_PICK, "SeedPacketPick.xml"),
        new ParticleParams(ICE_TRAP_ZOMBIE, "IceTrapZombie.xml"),
        new ParticleParams(ICE_TRAP_RELEASE, "IceTrapRelease.xml"),
        new ParticleParams(ZAMBONI_SMOKE, "ZamboniSmoke.xml"),
        new ParticleParams(GLOOMCLOUD, "GloomCloud.xml"),
        new ParticleParams(ZOMBIE_POGO_HEAD, "ZombiePogoHead.xml"),
        new ParticleParams(ZAMBONI_TIRE, "ZamboniTire.xml"),
        new ParticleParams(ZAMBONI_EXPLOSION, "ZamboniExplosion.xml"),
        new ParticleParams(ZAMBONI_EXPLOSION2, "ZamboniExplosion2.xml"),
        new ParticleParams(CATAPULT_EXPLOSION, "CatapultExplosion.xml"),
        new ParticleParams(MOWER_CLOUD, "MowerCloud.xml"),
        new ParticleParams(BOSS_ICE_BALL, "BossIceBallTrail.xml"),
        new ParticleParams(BLASTMARK, "BlastMark.xml"),
        new ParticleParams(COIN_PICKUP_ARROW, "CoinPickupArrow.xml"),
        new ParticleParams(PRESENT_PICKUP, "PresentPickup.xml"),
        new ParticleParams(IMITATER_MORPH, "ImitaterMorph.xml"),
        new ParticleParams(MOWERED_ZOMBIE_HEAD, "MoweredZombieHead.xml"),
        new ParticleParams(MOWERED_ZOMBIE_ARM, "MoweredZombieArm.xml"),
        new ParticleParams(ZOMBIE_HEAD_POOL, "ZombieHeadPool.xml"),
        new ParticleParams(ZOMBIE_BOSS_FIREBALL, "Zombie_boss_fireball.xml"),
        new ParticleParams(FIREBALL_DEATH, "FireballDeath.xml"),
        new ParticleParams(ICEBALL_DEATH, "IceballDeath.xml"),
        new ParticleParams(ICEBALL_TRAIL, "Iceball_Trail.xml"),
        new ParticleParams(FIREBALL_TRAIL, "Fireball_Trail.xml"),
        new ParticleParams(BOSS_EXPLOSION, "BossExplosion.xml"),
        new ParticleParams(SCREEN_FLASH, "ScreenFlash.xml"),
        new ParticleParams(TROPHY_SPARKLE, "TrophySparkle.xml"),
        new ParticleParams(PORTAL_CIRCLE, "PortalCircle.xml"),
        new ParticleParams(PORTAL_SQUARE, "PortalSquare.xml"),
        new ParticleParams(POTTED_PLANT_GLOW, "PottedPlantGlow.xml"),
        new ParticleParams(POTTED_WATER_PLANT_GLOW, "PottedWaterPlantGlow.xml"),
        new ParticleParams(POTTED_ZEN_GLOW, "PottedZenGlow.xml"),
        new ParticleParams(MIND_CONTROL, "MindControl.xml"),
        new ParticleParams(VASE_SHATTER, "VaseShatter.xml"),
        new ParticleParams(VASE_SHATTER_LEAF, "VaseShatterLeaf.xml"),
        new ParticleParams(VASE_SHATTER_ZOMBIE, "VaseShatterZombie.xml"),
        new ParticleParams(AWARD_PICKUP_ARROW, "AwardPickupArrow.xml"),
        new ParticleParams(ZOMBIE_SEAWEED, "Zombie_seaweed.xml"),
        new ParticleParams(ZOMBIE_MUSTACHE, "ZombieMustache.xml"),
        new ParticleParams(ZOMBIE_SUNGLASS, "ZombieFutureGlasses.xml"),
        new ParticleParams(ZOMBIE_PINATA, "Pinata.xml"),
        new ParticleParams(DUST_SQUASH, "Dust_Squash.xml"),
        new ParticleParams(DUST_FOOT, "Dust_Foot.xml"),
        new ParticleParams(ZOMBIE_DAISIES, "Daisy.xml"),
        new ParticleParams(CREDIT_STROBE, "Credits_Strobe.xml"),
        new ParticleParams(CREDITS_RAYSWIPE, "Credits_RaysWipe.xml"),
        new ParticleParams(CREDITS_ZOMBIEHEADWIPE, "Credits_ZombieHeadWipe.xml"),
        new ParticleParams(STARBURST, "Starburst.xml"),
        new ParticleParams(CREDITS_FOG, "Credits_fog.xml"),
        new ParticleParams(PERSENT_PICK_UP_ARROW, "UpsellArrow.xml"),
        new ParticleParams(KERNEL_SPLAT, "KernelSplat.xml"),
    ];

    public static var loadingProgress:Float;
    public static var _particlesLoaded:Int;
    public static var particleDefArray:Array<TodParticleDefinition> = [];

    static function getParticlePath(id:String) : String
    {
        id = id.toLowerCase();

        var xmlList = Assets.list(AssetType.TEXT);

        for (path in xmlList)
        {
            var file = path.split("/").pop();
            if (file.toLowerCase() == id)
            {
                return path;
            }
        }

        return null;
    }

    static function parseCurve(str:String) : Null<TodCurves>
    {
        switch (str.toUpperCase())
        {
            case "CONSTANT":            return TodCurves.CONSTANT;
            case "LINEAR":              return TodCurves.LINEAR;
            case "EASE_IN":             return TodCurves.EASE_IN;
            case "EASE_OUT":            return TodCurves.EASE_OUT;
            case "EASE_IN_OUT":         return TodCurves.EASE_IN_OUT;
            case "EASE_IN_OUT_WEAK":    return TodCurves.EASE_IN_OUT_WEAK;
            case "FAST_IN_OUT":         return TodCurves.FAST_IN_OUT;
            case "FAST_IN_OUT_WEAK":    return TodCurves.FAST_IN_OUT_WEAK;
            case "WEAK_FAST_IN_OUT":    return TodCurves.WEAK_FAST_IN_OUT;
            case "BOUNCE":              return TodCurves.BOUNCE;
            case "BOUNCE_FAST_MIDDLE":  return TodCurves.BOUNCE_FAST_MIDDLE;
            case "BOUNCE_SLOW_MIDDLE":  return TodCurves.BOUNCE_SLOW_MIDDLE;
            case "SIN_WAVE":            return TodCurves.SIN_WAVE;
            case "EASE_SIN_WAVE":       return TodCurves.EASE_SIN_WAVE;
            default:                    return null;
        }
    }

    static function parseFloatParameterTrack(text:String):FloatParameterTrack 
    {
        var track = new FloatParameterTrack();

        if (text == null || StringTools.trim(text) == "")
            return track;
    
        var tokens = text.split(" ");
        var currentTime = 0.0;
        var currentCurve = TodCurves.CONSTANT;
        var currentDist = TodCurves.LINEAR;
    
        inline function pushNode(low:Float, high:Float) 
        {
            var node = new FloatParameterTrackNode(currentTime, low, high, currentCurve, currentDist);
            track.nodes.push(node);
        }
    
        for (raw in tokens) 
        {
            var token = StringTools.trim(raw);

            if (token == "") 
            {
                continue;
            }
    
            var checkEase = parseCurve(token);
            if (checkEase != null)
            {
                currentCurve = checkEase;
                continue;
            }
    
            if (token.indexOf(",") != -1) 
            {
                var valuePart = token.substr(0, token.indexOf(",")).trim();
                var timePart  = token.substr(token.indexOf(",") + 1).trim();
    
                if (valuePart != "") 
                {
                    if (valuePart.charAt(0) == "[" && valuePart.charAt(valuePart.length - 1) == "]")
                    {
                        var inner = valuePart.substr(1, valuePart.length - 2);
                        var vals = inner.split(" ");
                        var low = Std.parseFloat(vals[0]);
                        var high = (vals.length > 1) ? Std.parseFloat(vals[1]) : low;
                        pushNode(low, high);
                    } else 
                    {
                        var val = Std.parseFloat(valuePart);
                        if (!Math.isNaN(val)) pushNode(val, val);
                    }
                }
    
                var t = Std.parseFloat(timePart);

                if (!Math.isNaN(t)) 
                {
                    currentTime = t;
                }

                continue;
            }
    
            if (token.charAt(0) == "[" && token.charAt(token.length - 1) == "]") 
            {
                var inner = token.substr(1, token.length - 2);
                var vals = inner.split(" ");
                var low = Std.parseFloat(vals[0]);
                var high = (vals.length > 1) ? Std.parseFloat(vals[1]) : low;
                pushNode(low, high);
                currentTime += 1.0;

                continue;
            }
    
            var num = Std.parseFloat(token);
            if (!Math.isNaN(num)) 
            {
                pushNode(num, num);
                currentTime += 1.0;
            }
        }
        return track;
    }    

    static function parseParticleFields(xml:Iterator<Xml>):Array<ParticleField>
    {
        var result:Array<ParticleField> = [];
    
        var field = new ParticleField();

        for (subElem in xml) 
        {
            switch (subElem.nodeName) 
            {
                case "FieldType":
                    var typeStr = subElem.firstChild().nodeValue.toUpperCase();
                    field.fieldType = 
                    switch (typeStr) 
                    {
                        case "FRICTION": ParticleFieldType.FRICTION;
                        case "ACCELERATION": ParticleFieldType.ACCELERATION;
                        case "ATTRACTOR": ParticleFieldType.ATTRACTOR;
                        case "MAX_VELOCITY": ParticleFieldType.MAX_VELOCITY;
                        case "VELOCITY": ParticleFieldType.VELOCITY;
                        case "POSITION": ParticleFieldType.POSITION;
                        case "SYSTEM_POSITION": ParticleFieldType.SYSTEM_POSITION;
                        case "GROUND_CONSTRAINT": ParticleFieldType.GROUND_CONSTRAINT;
                        case "SHAKE": ParticleFieldType.SHAKE;
                        case "CIRCLE": ParticleFieldType.CIRCLE;
                        case "AWAY": ParticleFieldType.AWAY;
                        default: ParticleFieldType.INVALID;
                    };

                case "X":
                    field.x = parseFloatParameterTrack(subElem.firstChild().nodeValue);

                case "Y":
                    field.y = parseFloatParameterTrack(subElem.firstChild().nodeValue);
            }
            
            result.push(field);
        }
    
        return result;
    }
          
    public static function definitionLoadXml(particleFileName:String, particleDef:TodParticleDefinition) : Bool
    {
        var path = getParticlePath(particleFileName);

        if (!Assets.exists(path))
        {
            return false;
        }

        var xml = Xml.parse(Assets.getText(path));

        for (element in xml.elements())
        {
            switch (element.nodeName)
            {
                case "Emitter":
                    var emitter = new TodEmitterDefinition();

                    for (subElement in element.elements())
                    {
                        switch (subElement.nodeName)
                        {
                            case "Image":
                                var rawName = subElement.firstChild().nodeValue;
                                var base = rawName.replace("IMAGE_", "");
                                base = base.replace("PARTICLES_", "");
                                base = base.replace("REANIM_", "");
                                var parts = base.split("_");
                                var formatted = [];
                                for (i in 0...parts.length)
                                {
                                    var word = parts[i].toLowerCase();
                                    if (i == 0) word = word.charAt(0).toUpperCase() + word.substr(1);
                                    formatted.push(word);
                                }
                                var fileName = formatted.join("_");
                                emitter.image = ImageLib.getImage(fileName);
                            case "ImageCol":
                                emitter.imageCol = Std.parseInt(subElement.firstChild().nodeValue);
                            case "ImageRow":
                                emitter.imageRow = Std.parseInt(subElement.firstChild().nodeValue);
                            case "ImageFrames":
                                emitter.imageFrames = Std.parseInt(subElement.firstChild().nodeValue);
                            case "ParticleFlags":
                                emitter.particleFlags = new IntRef(Std.parseInt(subElement.firstChild().nodeValue));
                            case "EmitterType":
                                emitter.emitterType = Std.parseInt(subElement.firstChild().nodeValue);
                            case "Name":
                                emitter.name = subElement.firstChild().nodeValue;
                            case "OnDuration":
                                emitter.onDuration = subElement.firstChild().nodeValue;
                            case "SystemDuration":
                                emitter.systemDuration = parseFloatParameterTrack(subElement.firstChild().nodeValue);
                            case "CrossFadeDuration":
                                emitter.crossFadeDuration = parseFloatParameterTrack(subElement.firstChild().nodeValue);
                            case "SpawnRate":
                                emitter.spawnRate = parseFloatParameterTrack(subElement.firstChild().nodeValue);
                            case "SpawnMinActive":
                                emitter.spawnMinActive = parseFloatParameterTrack(subElement.firstChild().nodeValue);
                            case "SpawnMaxActive":
                                emitter.spawnMaxActive = parseFloatParameterTrack(subElement.firstChild().nodeValue);
                            case "spawnMaxLaunched":
                                emitter.spawnMaxLaunched = parseFloatParameterTrack(subElement.firstChild().nodeValue);
                            case "EmitterRadius":
                                emitter.emitterRadius = parseFloatParameterTrack(subElement.firstChild().nodeValue);
                            case "EmitterOffsetX":
                                emitter.emitterOffsetX = parseFloatParameterTrack(subElement.firstChild().nodeValue);
                            case "EmitterOffsetY":
                                emitter.emitterOffsetY = parseFloatParameterTrack(subElement.firstChild().nodeValue);
                            case "EmitterBoxX":
                                emitter.emitterBoxX = parseFloatParameterTrack(subElement.firstChild().nodeValue);
                            case "EmitterBoxY":
                                emitter.emitterBoxY = parseFloatParameterTrack(subElement.firstChild().nodeValue);
                            case "EmitterPath":
                                emitter.emitterPath = parseFloatParameterTrack(subElement.firstChild().nodeValue);
                            case "EmitterSkewX":
                                emitter.emitterSkewX = parseFloatParameterTrack(subElement.firstChild().nodeValue);
                            case "EmitterSkewY":
                                emitter.emitterSkewY = parseFloatParameterTrack(subElement.firstChild().nodeValue);
                            case "ParticleDuration":
                                emitter.particleDuration = parseFloatParameterTrack(subElement.firstChild().nodeValue);
                            case "SystemRed":
                                emitter.systemRed = parseFloatParameterTrack(subElement.firstChild().nodeValue);
                            case "SystemGreen":
                                emitter.systemGreen = parseFloatParameterTrack(subElement.firstChild().nodeValue);
                            case "SystemBlue":
                                emitter.systemBlue = parseFloatParameterTrack(subElement.firstChild().nodeValue);
                            case "SystemAlpha":
                                emitter.systemAlpha = parseFloatParameterTrack(subElement.firstChild().nodeValue);
                            case "SystemBrightness":
                                emitter.systemBrightness = parseFloatParameterTrack(subElement.firstChild().nodeValue);
                            case "LaunchSpeed":
                                emitter.launchSpeed = parseFloatParameterTrack(subElement.firstChild().nodeValue);
                            case "LaunchAngle":
                                emitter.launchAngle = parseFloatParameterTrack(subElement.firstChild().nodeValue);
                            case "Field":
                                emitter.particleFields = parseParticleFields(subElement.elements());
                            case "SystemField":
                                emitter.systemFields = parseParticleFields(subElement.elements());
                            case "ParticleRed":
                                emitter.particleRed = parseFloatParameterTrack(subElement.firstChild().nodeValue);
                            case "ParticleGreen":
                                emitter.particleGreen = parseFloatParameterTrack(subElement.firstChild().nodeValue);
                            case "ParticleBlue":
                                emitter.particleBlue = parseFloatParameterTrack(subElement.firstChild().nodeValue);
                            case "ParticleAlpha":
                                emitter.particleAlpha = parseFloatParameterTrack(subElement.firstChild().nodeValue);
                            case "ParticleBrightness":
                                emitter.particleBrightness = parseFloatParameterTrack(subElement.firstChild().nodeValue);
                            case "ParticleSpinAngle":
                                emitter.particleSpinAngle = parseFloatParameterTrack(subElement.firstChild().nodeValue);
                            case "ParticleSpinSpeed":
                                emitter.particleSpinSpeed = parseFloatParameterTrack(subElement.firstChild().nodeValue);
                            case "ParticleScale":
                                emitter.particleScale = parseFloatParameterTrack(subElement.firstChild().nodeValue);
                            case "ParticleStretch":
                                emitter.particleStretch = parseFloatParameterTrack(subElement.firstChild().nodeValue);
                            case "CollisionReflect":
                                emitter.collisionReflect = parseFloatParameterTrack(subElement.firstChild().nodeValue);
                            case "CollisionSpin":
                                emitter.collisionSpin = parseFloatParameterTrack(subElement.firstChild().nodeValue);
                            case "ClipTop":
                                emitter.clipTop = parseFloatParameterTrack(subElement.firstChild().nodeValue);
                            case "ClipBottom":
                                emitter.clipBottom = parseFloatParameterTrack(subElement.firstChild().nodeValue);
                            case "ClipLeft":
                                emitter.clipLeft = parseFloatParameterTrack(subElement.firstChild().nodeValue);
                            case "ClipRight":
                                emitter.clipRight = parseFloatParameterTrack(subElement.firstChild().nodeValue);
                            case "AnimationRate":
                                emitter.animRate = parseFloatParameterTrack(subElement.firstChild().nodeValue);
                        }
                    }

                    particleDef.emitterDefs.push(emitter);
            }
        }

        return true;
    }

    static function floatTrackSetDefault(track:FloatParameterTrack, value:Float)
    {
        if (track == null)
        {
            track = new FloatParameterTrack();
        }
        
        if ((track.nodes == null || track.nodes.length == 0) && value != 0) 
        {
            track.nodes = [
                new FloatParameterTrackNode(0, value, value, TodCurves.CONSTANT, TodCurves.LINEAR)
            ];
        }
    }

    public static function todParticleLoadADef(particleDef:TodParticleDefinition, particleFileName:String): Bool
    {
        if (!definitionLoadXml(particleFileName, particleDef))
        {
            return false;
        }
        else 
        {
            for (emitter in particleDef.emitterDefs)
            {
                floatTrackSetDefault(emitter.systemDuration, 0);
                floatTrackSetDefault(emitter.spawnRate, 0);
                floatTrackSetDefault(emitter.spawnMinActive, -1);
                floatTrackSetDefault(emitter.spawnMaxActive, -1);
                floatTrackSetDefault(emitter.spawnMaxLaunched, -1);
                floatTrackSetDefault(emitter.emitterRadius, 0);
                floatTrackSetDefault(emitter.emitterOffsetX, 0);
                floatTrackSetDefault(emitter.emitterOffsetY, 0);
                floatTrackSetDefault(emitter.emitterBoxX, 0);
                floatTrackSetDefault(emitter.emitterBoxY, 0);
                floatTrackSetDefault(emitter.emitterSkewX, 0);
                floatTrackSetDefault(emitter.emitterSkewY, 0);
                floatTrackSetDefault(emitter.particleDuration, 1);
                floatTrackSetDefault(emitter.launchSpeed, 0);
                floatTrackSetDefault(emitter.systemRed, 1);
                floatTrackSetDefault(emitter.systemGreen, 1);
                floatTrackSetDefault(emitter.systemBlue, 1);
                floatTrackSetDefault(emitter.systemAlpha, 1);
                floatTrackSetDefault(emitter.systemBrightness, 1);
                floatTrackSetDefault(emitter.launchAngle, 0);
                floatTrackSetDefault(emitter.crossFadeDuration, 0);
                floatTrackSetDefault(emitter.particleRed, 1);
                floatTrackSetDefault(emitter.particleGreen, 1);
                floatTrackSetDefault(emitter.particleBlue, 1);
                floatTrackSetDefault(emitter.particleAlpha, 1);
                floatTrackSetDefault(emitter.particleBrightness, 1);
                floatTrackSetDefault(emitter.particleSpinAngle, 0);
                floatTrackSetDefault(emitter.particleSpinSpeed, 0);
                floatTrackSetDefault(emitter.particleScale, 1);
                floatTrackSetDefault(emitter.particleStretch, 1);
                floatTrackSetDefault(emitter.collisionReflect, 0);
                floatTrackSetDefault(emitter.collisionSpin, 0);
                floatTrackSetDefault(emitter.clipTop, 0);
                floatTrackSetDefault(emitter.clipBottom, 0);
                floatTrackSetDefault(emitter.clipLeft, 0);
                floatTrackSetDefault(emitter.clipRight, 0);
                floatTrackSetDefault(emitter.animRate, 0);
            }
        }

        return true;
    }

    public static function todParticleLoadDefinitions() 
    {
        _particlesLoaded = 0;
        loadingProgress = 0;
        
        for (i in 0...lawnParticleArray.length)
        {
            final param = lawnParticleArray[i];
            var definition = new TodParticleDefinition();
            if (!todParticleLoadADef(definition, param.particleFileName))
            {
                Application.current.window.alert('Failed to load particle \'${param.particleFileName}\'');
            }
            particleDefArray[i] = definition;
            _particlesLoaded++;
            loadingProgress = _particlesLoaded / (ParticleEffect.NUM_PARTICLES - 1);
        }

        loadingProgress = 1;
    }

    public var particleEmitter:TodParticleEmitter;
    public var particleDuration:Float;
    public var particleAge:Float;
    public var particleTimeValue:Float;
    public var particleLastTimeValue:Float;
    public var animationTimeValue:Float;
    public var velocity:FlxPoint;
    public var position:FlxPoint;
    public var imageFrame:Int;
    public var spinPosition:Float;
    public var spinVelocity:Float;
    public var crossFadeParticle:TodParticle;
    public var crossFadeDuration:Float;
    public var particleInterp:Array<Float>;
    public var particleFieldInterp:Array<Array<Float>>;

    public function new() 
    {
        position = FlxPoint.get();
        velocity = FlxPoint.get();
    }
}