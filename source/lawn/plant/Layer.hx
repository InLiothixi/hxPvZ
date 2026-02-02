package lawn.plant;

enum abstract Layer(Int) from Int to Int 
{
    var BELOW = -1;
    var MAIN;
    var REANIM;
    var REANIM_HEAD;
    var REANIM_BLINK;
    var ON_TOP;
    var NUM_PLANT_LAYERS;
}