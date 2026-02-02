package lawn.widget.titlescreen;

enum abstract TitleState(Int) from Int to Int 
{
	var WAITING_FOR_FIRST_DRAW;
	var POPCAP_LOGO;
	var PARTNER_LOGO;
	var SCREEN;
}