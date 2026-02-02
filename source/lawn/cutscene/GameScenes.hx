package lawn.cutscene;

enum abstract GameScenes(Int) from Int to Int {
    var LOADING;
    var MENU;
    var LEVEL_INTRO;
    var PLAYING;
    var ZOMBIES_WON;
    var AWARD;
    var CREDIT;
    var CHALLENGE;
}