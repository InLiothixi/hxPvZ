package todlib.reanimator;

enum abstract ReanimLoopType(Int) from Int to Int 
{
    var LOOP;
    var LOOP_FULL_LAST_FRAME;
    var PLAY_ONCE;
    var PLAY_ONCE_AND_HOLD;
    var PLAY_ONCE_FULL_LAST_FRAME;
    var PLAY_ONCE_FULL_LAST_FRAME_AND_HOLD;
}