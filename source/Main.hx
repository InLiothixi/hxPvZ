package;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxSprite;
import flixel.system.scaleModes.RatioScaleMode;
import lawn.Board;
import lawn.cutscene.GameScenes;
import lawn.system.Music;
import lawn.widget.TitleScreen;
import lime.utils.Bytes;
import openfl.Lib;
import openfl.display.BitmapData;
import openfl.display.PNGEncoderOptions;
import openfl.display.Sprite;
import openfl.display.StageQuality;
import openfl.events.Event;
import sexyappbase.BassInstance;
import sexyappbase.BassMusicInterface;
import sexyappbase.DebugDisplay;
import sexyappbase.ImageFont;
import sexyappbase.debugdisplay.FPSMode;
import sys.FileSystem;
import sys.io.File;
import sys.thread.Thread;
import todlib.EffectSystem;
import todlib.FilterEffect;
import todlib.Reanimation;
import todlib.TodParticle;
import todlib.reanimator.ReanimationType;

using StringTools;

class Main extends Sprite
{
	public static var instance:Main;

	public var gameScene:GameScenes;

	public static var debugDisplay:DebugDisplay;
	public static var board:Board;
	public static var bassInterface:BassMusicInterface;
	public static var music:Music;
	public static var effectSystem:EffectSystem;

	public static var debugMode:Bool;
	public static var showFPS:Bool;
	public static var fpsMode:FPSMode;

	public static var loadingThreadStarted:Bool;
	public static var loadingThreadCompleted:Bool;

	public function new()
	{
		super();

		instance = this;

		gameScene = GameScenes.LOADING;

		debugMode = #if debug true #else false #end;
		showFPS = debugMode;
		fpsMode = FPSMode.SHOW_FPS;

		stage.quality = StageQuality.BEST;

		bassInterface = new BassMusicInterface();
		music = new Music();
		
		effectSystem = new EffectSystem();
		effectSystem.effectSystemInitialize();

		Resources.extractInitResources();
		Resources.extractLoaderBarResources();
		Resources.extractLoadingImagesResources();

		addChild(new FlxGame(800, 600, TitleScreen));

		debugDisplay = new DebugDisplay();
		debugDisplay.visible = showFPS;
		addChild(debugDisplay);

		FlxG.autoPause = FlxG.fixedTimestep = false;
		FlxG.game.focusLostFramerate = FlxG.drawFramerate;
		FlxG.camera.antialiasing = FlxSprite.defaultAntialiasing = true;

		FlxG.scaleMode = new RatioScaleMode(false);
		#if !FLX_NO_MOUSE
		FlxG.mouse.useSystemCursor = true;
		#end

		loadingThreadStarted = false;
		loadingThreadCompleted = false;
		
		stage.addEventListener(Event.CLOSE, closeEvent);
		FlxG.signals.gameResized.add(positionFPS);
		//FlxG.signals.focusGained.add(focusGained);
        //FlxG.signals.focusLost.add(focusLost);
		FlxG.signals.postUpdate.add(updateApp);
	}

	function closeEvent(event) 
	{
		effectSystem.effectSystemDispose();
		
		BassInstance.BASS_Stop();
		BassInstance.BASS_Free();
	}

	function focusGained()
	{
		music.gameMusicPause(false);
	}

	function focusLost()
	{
		music.gameMusicPause(true);
	}

	function positionFPS(width:Int, height:Int)
	{
		debugDisplay.x = width - 85;

		if (fpsMode != FPSMode.SHOW_FPS)
		{
			debugDisplay.x -= 50;
		}

		debugDisplay.y = height - 34;
	}

	function updateApp()
	{
		bassInterface.update(FlxG.elapsed);
		music.musicUpdate(FlxG.elapsed);

		if (loadingThreadCompleted && effectSystem != null)
		{
			effectSystem.processDeleteQueue();
		}

		#if !FLX_NO_KEYBOARD

        if (FlxG.keys.pressed.CONTROL && FlxG.keys.pressed.ALT && FlxG.keys.justPressed.D)
        {
            debugMode = !debugMode;
            FlxG.sound.play("assets/sounds/Windows Background.wav");
        }

        if (FlxG.keys.justPressed.F11)
        {
            FlxG.fullscreen = !FlxG.fullscreen;
        }

        if (FlxG.keys.justPressed.F10)
        {
            takeScreenShot();
        }

        if (!debugMode) return;

        if (FlxG.keys.justPressed.F3)
        {
			if (FlxG.keys.pressed.SHIFT)
			{
				showFPS = true;
				fpsMode = (fpsMode + 1) % (FPSMode.SHOW_MEMORY + 1);
				debugDisplay.updateMode();
				positionFPS(FlxG.stage.stageWidth, FlxG.stage.stageHeight);
			}
			else
			{
            	showFPS = !showFPS;
			}
            debugDisplay.visible = showFPS;
        }

        #end

        #if !debug
        return;
        #end


	}

	public function takeScreenShot()
	{
		var stage = Lib.current.stage;
		var w = Std.int(stage.stageWidth);
		var h = Std.int(stage.stageHeight);

		var bmpData = new BitmapData(w, h, true, 0x00000000);
		bmpData.draw(stage, null, null, null, null, true);

		Thread.create(function() 
			{
			var bytes = bmpData.encode(bmpData.rect, new PNGEncoderOptions());

			var folder = "screenshots";
			if (!FileSystem.exists(folder)) {
				FileSystem.createDirectory(folder);
			}

			var timestamp = Date.now().toString().replace(":", "-").replace(" ", "_");
			var fileName = folder + "/screenshot_" + timestamp + ".png";

			File.saveBytes(fileName, Bytes.ofData(bytes));
			}
		);
	}

	public static function startLoadingThread()
	{
		if (!loadingThreadStarted)
		{
			loadingThreadStarted = true;
			Thread.create(loadingThreadProcStub);
			Thread.create(loadingThreadProcStub2);
			FlxG.signals.postUpdate.add(checkIfLoadingThreadDone);
		}
	}

	static function loadingThreadProcStub()
	{
		loadingThreadProc();
	}

	static function loadingThreadProc()
	{
		//Reanimation.reanimatorLoadDefinitions();
		Reanimation.loadingProgress = 1;
	}

	static function loadingThreadProcStub2()
	{
		loadingThreadProc2();
	}
	

	static function loadingThreadProc2()
	{
		TodParticle.todParticleLoadDefinitions();
		TodParticle.loadingProgress = 1;
	}

	public static function getLoadingThreadProgress()
	{
		return (Reanimation.loadingProgress + TodParticle.loadingProgress) / 2.0;
	}

	static function checkIfLoadingThreadDone()
	{
		if (!loadingThreadCompleted && 
			Reanimation.loadingProgress == 1 && 
			TodParticle.loadingProgress == 1)
		{
			loadingThreadCompleted = true;
			FlxG.signals.postUpdate.remove(checkIfLoadingThreadDone);
		}
	}

	public static function addReanimation(x:Float, y:Float, renderOrder:Int, reanimType:ReanimationType) 
	{
		return effectSystem.reanimtionHolder.allocReanimation(x, y, renderOrder, reanimType);
	}
}
