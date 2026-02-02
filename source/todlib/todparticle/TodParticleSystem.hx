package todlib.todparticle;

class TodParticleSystem 
{
    public var effectType:ParticleEffect;
    public var particleDef:TodParticleDefinition;
    public var particleHolder:TodParticleHolder;
    public var emitterList:Array<TodParticleEmitter> = [];
    public var dead:Bool;
    public var dontUpdate:Bool;
    public var isAttachment:Bool;
    public var renderOrder:Int;

    public function new() 
    {
        effectType = ParticleEffect.NONE;
        emitterList = [];
        dead = false;
        dontUpdate = false;
        isAttachment = false;
        renderOrder = 0;
    }

    public function initializeFromDef(x:Float, y:Float, order:Int, definition:TodParticleDefinition, type:ParticleEffect)
    {
        particleDef = definition;
        effectType = type;
        renderOrder = order;
    }

    public function particleSystemDie()
    {
        for (emitter in emitterList)
        {
            emitter.deleteAll();
            emitterList.remove(emitter);
        }
        emitterList.resize(0);
        dead = true;
    }

    public function update(elapsed:Float)
    {
        if (dontUpdate) return;

        var aEmitterAlive = false;
        for (emitter in emitterList)
        {
            emitter.update(elapsed);
            
            if ((FloatParameterTrack.floatTrackIsSet(emitter.emitterDef.crossFadeDuration) && emitter.particleList.length > 0 ) || !emitter.dead)
            {
                aEmitterAlive = true;
            }
        }
        if (!aEmitterAlive)
        {
            dead = true;
        }
    }

    public function findEmitterDefByName(emitterName:String)
    {
        for (def in particleDef.emitterDefs)
        {
            if (def.name == emitterName)
            {
                return def;
            }
        }
        return null;    
    }
}