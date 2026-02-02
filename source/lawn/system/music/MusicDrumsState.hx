package lawn.system.music;

enum abstract MusicDrumsState(Int) from Int to Int 
{
    var DRUMS_OFF;
	var DRUMS_ON_QUEUED;
	var DRUMS_ON;
	var DRUMS_OFF_QUEUED;
	var DRUMS_FADING;
}