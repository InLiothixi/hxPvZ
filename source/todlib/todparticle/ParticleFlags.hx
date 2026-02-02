package todlib.todparticle;

enum abstract ParticleFlags(Int) from Int to Int 
{
    var RANDOM_LAUNCH_SPIN;
    var ALIGN_LAUNCH_SPIN;
    var ALIGN_TO_PIXELS;
    var SYSTEM_LOOPS;
    var PARTICLE_LOOPS;
    var PARTICLES_DONT_FOLLOW;
    var RANDOM_START_TIME;
    var DIE_IF_OVERLOADED;
    var ADDITIVE;
    var FULLSCREEN;
    var SOFTWARE_ONLY;
    var HARDWARE_ONLY;
}