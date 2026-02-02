package lawn.system.music;

enum abstract MusicBurstState(Int) from Int to Int 
{
    var BURST_OFF;
	var BURST_STARTING;
	var BURST_ON;
	var BURST_FINISHING;
}