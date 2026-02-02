package todlib.filtereffect;

enum abstract FilterEffectType(Int) from Int to Int 
{
    var NONE = -1;
    var WASHED_OUT;
    var LESS_WASHED_OUT;
    var WHITE;
    var NUM_FILTER_EFFECTS;
}
