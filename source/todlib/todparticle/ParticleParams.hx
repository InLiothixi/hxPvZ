package todlib.todparticle;

class ParticleParams
{
    public var particleEffect:ParticleEffect;
    public var particleFileName:String;
    public function new(particleEffect:ParticleEffect, particleFileName:String) 
    {
        this.particleEffect = particleEffect;
        this.particleFileName = particleFileName;
    }
}