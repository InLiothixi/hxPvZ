package lawn;

import RenderItem.RenderHelper;
import entities.Entities;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.effects.FlxSkewedSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.tile.FlxDrawTrianglesItem.DrawData;
import flixel.group.FlxGroup;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.tweens.misc.NumTween;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import lawn.board.BackgroundType;
import lawn.system.PoolEffect;
import lawn.system.music.MusicFile;
import lawn.system.music.MusicTune;
import lime.ui.MouseCursor;
import openfl.display.BitmapData;
import openfl.display.Shape;
import openfl.ui.Mouse;
import openfl.utils.Assets;
import sexyappbase.ClipShader.ClipEffect;
import sexyappbase.Graphics;
import sexyappbase.ImageFont;
import sexyappbase.ImageLib;
import todlib.Attachment;
import todlib.FilterEffect;
import todlib.Reanimation;
import todlib.TodCommon;
import todlib.TodParticle;
import todlib.filtereffect.FilterEffectType;
import todlib.reanimator.ReanimLoopType;
import todlib.reanimator.ReanimationType;
import todlib.reanimator.ReanimatorDefinition;
import todlib.reanimator.ReanimatorParams;
import todlib.reanimator.RenderGroup;

class Board extends FlxState
{
	public static var instance:Board;

	public var mainCounter:Float;

	public var background:BackgroundType;
	public var paused:Bool;
	public var burst:Bool;
	public var poolEffect:PoolEffect;

	override public function new() {
		super();

		instance = this;

		mainCounter = 0;
	}

	override public function create()
	{
		super.create();

		persistentUpdate = true;
		persistentDraw = true;

		Main.board = this;

		camera.scroll.x = 220;
		background = BackgroundType.FOG;

		paused = false;

		Main.music.musicInit();
		Main.music.musicLoadCreditsSong();
        Main.music.makeSureMusicIsPlaying(MusicTune.FOG_RIGORMORMIST);

		burst = false;
		poolEffect = new PoolEffect();
		poolEffect.poolEffectInitialize();

		var reanim = Main.addReanimation(0, 0, 0, ReanimationType.BOSS_DRIVER);
		reanim.playReanim("anim_idle", ReanimLoopType.LOOP, 0, 18.0);
		
		var reanim2 = Main.addReanimation(220, 0, 1, ReanimationType.BOSS);
		reanim2.playReanim("anim_head_idle", ReanimLoopType.LOOP, 0, 12);

		var track = reanim2.getTrackInstanceByName("Boss_head2");
		var aAttach = Attachment.attachReanim(track.attachment, reanim, 28, -84);
		reanim2.frameBasePose = 0;
		aAttach.effect.offset.a = 1.2;
		aAttach.effect.offset.d = 1.2;
		aAttach.effect.dontDrawIfParentHidden = true;
		track.attachment = aAttach.attachment;
		reanim.isAttachment = true;
	}

	override public function update(elapsed:Float)
	{
		#if !FLX_NO_KEYBOARD
		if (FlxG.keys.justPressed.SPACE)
		{
			paused = !paused;
			Main.music.gameMusicPause(paused);
		}
		#end

		if (paused)
		{
			return;
		}

		Main.effectSystem.update(elapsed);

		super.update(elapsed);

		#if !FLX_NO_KEYBOARD
		if (FlxG.keys.justPressed.Q)
		{
			background--;
		}
		if (FlxG.keys.justPressed.E)
		{
			background++;
		}
		#end

		if (FlxG.keys.justPressed.R)
		{
			burst = !burst;
		}

		background = background % BackgroundType.NUM_BACKGROUNDS;

		poolEffect.poolEffectUpdate(elapsed);
	}

	// function mouseDownWithPlant(X:Float, Y:Float)
	// {
	// 	final seedtype = SeedType.PEASHOOTER;
	// 	final gridX = plantingPixelToGridX(X, Y, seedtype);
	// 	final gridY = plantingPixelToGridY(X, Y, seedtype);

	// 	if (gridX < 0 || gridX > MAX_GRID_SIZE_X || gridY < 0 || gridY > MAX_GRID_SIZE_Y)
	// 		return;

	// 	//entities.addPlant(gridX, gridY, seedtype);
	// }

	public function drawBackdrop(g:Graphics)
	{
		g.pushState();

		var bgImage:BitmapData = null;
		switch (background)
		{
			case BackgroundType.DAY: bgImage = ImageLib.getImage("background1").bmp;
			case BackgroundType.NIGHT: bgImage = ImageLib.getImage("background2").bmp;
			case BackgroundType.POOL: bgImage = ImageLib.getImage("background3").bmp;
			case BackgroundType.FOG: bgImage = ImageLib.getImage("background4").bmp;
			case BackgroundType.ROOF: bgImage = ImageLib.getImage("background5").bmp;
			case BackgroundType.BOSS: bgImage = ImageLib.getImage("background6boss").bmp;
			case BackgroundType.MUSHROOM_GARDEN: bgImage = ImageLib.getImage("Background_MushroomGarden").bmp;
			case BackgroundType.GREENHOUSE: bgImage = ImageLib.getImage("Background_Greenhouse").bmp;
			case BackgroundType.ZOMBIQUARIUM: bgImage = ImageLib.getImage("aquarium1").bmp;
			default:
		}

		if (background == BackgroundType.MUSHROOM_GARDEN || background == BackgroundType.GREENHOUSE || background == BackgroundType.ZOMBIQUARIUM)
		{
			g.drawImage(bgImage);
		}
		else
		{
			//g.translate(-GameConstants.BOARD_OFFSET);
			g.drawImage(bgImage);
			g.popState();
		}

		g.popState();
	}

	public function drawUIBottom(g:Graphics)
	{
		g.pushState();

		if (background == BackgroundType.GREENHOUSE || background == BackgroundType.MUSHROOM_GARDEN)
		{

		}

		g.popState();
	}

	override function draw()
	{
		var g = new Graphics(FlxG.camera);
		g.smoothing = true;

		drawBackdrop(g);

		super.draw();  
		
		//poolEffect.poolEffectDraw(g);

		//var clipShader = new ClipEffect();
		//clipShader.updateClipRect(0, 0, 500, 600);
		//g.shader = clipShader.shader;

		for (reanim in Main.effectSystem.reanimtionHolder.reanimations) {
			reanim.draw(g);
		}
	}
}
