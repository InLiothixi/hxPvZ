package lawn.system.music;

enum abstract MusicFile(Int) from Int to Int 
{
    var NONE = -1;
	var MAIN_MUSIC = 1;
	var DRUMS;
    var HIHATS;
	var CREDITS_ZOMBIES_ON_YOUR_LAWN;
	var NUM_MUSIC_FILES;
}