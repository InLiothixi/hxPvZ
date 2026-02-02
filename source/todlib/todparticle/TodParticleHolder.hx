package todlib.todparticle;

import todlib.todparticle.TodParticleSystem;

class TodParticleHolder 
{
    public var particleSystems:Array<TodParticleSystem>;
    public var emitters:Array<TodParticleEmitter>;
    public var particles:Array<TodParticle>;

    public function new() {}

    public function initializeHolder()
    {
        particleSystems = [];
        emitters = [];
        particles = [];
    }
}