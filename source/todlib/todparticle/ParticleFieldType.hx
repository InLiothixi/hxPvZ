package todlib.todparticle;

enum abstract ParticleFieldType(Int) from Int to Int 
{
    var INVALID;
    var FRICTION;
    var ACCELERATION;
    var ATTRACTOR;
    var MAX_VELOCITY;
    var VELOCITY;
    var POSITION;
    var SYSTEM_POSITION;
    var GROUND_CONSTRAINT;
    var SHAKE;
    var CIRCLE;
    var AWAY;
    var COUNT;
}