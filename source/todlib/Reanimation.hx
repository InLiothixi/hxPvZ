package todlib;

import flixel.FlxG;
import flixel.math.FlxAngle;
import flixel.math.FlxMath;
import flixel.math.FlxMatrix;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import lime.app.Application;
import openfl.utils.AssetType;
import openfl.utils.Assets;
import sexyappbase.DescParser.IntRef;
import sexyappbase.Font;
import sexyappbase.Graphics;
import sexyappbase.Image;
import sexyappbase.ImageLib;
import todlib.attachment.AttacherInfo;
import todlib.filtereffect.FilterEffectType;
import todlib.reanimatlas.ReanimAtlasImage;
import todlib.reanimator.ReanimLoopType;
import todlib.reanimator.ReanimationHolder;
import todlib.reanimator.ReanimationType;
import todlib.reanimator.ReanimatorDefinition;
import todlib.reanimator.ReanimatorFrameTime;
import todlib.reanimator.ReanimatorParams;
import todlib.reanimator.ReanimatorTrack;
import todlib.reanimator.ReanimatorTrackInstance;
import todlib.reanimator.ReanimatorTransform;
import todlib.reanimator.RenderGroup;

using StringTools;

class Reanimation
{    
    public static var reanimationParamArray:Array<ReanimatorParams> = [
       new ReanimatorParams(ReanimationType.LOADBAR_SPROUT,                       "LoadBar_sprout",                   1 ),
       new ReanimatorParams(ReanimationType.LOADBAR_ZOMBIEHEAD,                   "LoadBar_Zombiehead",               1 ),
       new ReanimatorParams(ReanimationType.SODROLL,                              "SodRoll",                          0 ),
       new ReanimatorParams(ReanimationType.FINAL_WAVE,                           "FinalWave",                        1 ),
       new ReanimatorParams(ReanimationType.PEASHOOTER,                           "PeaShooterSingle",                 0 ),
       new ReanimatorParams(ReanimationType.WALLNUT,                              "Wallnut",                          0 ),
       new ReanimatorParams(ReanimationType.LILYPAD,                              "Lilypad",                          0 ),
       new ReanimatorParams(ReanimationType.SUNFLOWER,                            "SunFlower",                        0 ),
       new ReanimatorParams(ReanimationType.LAWNMOWER,                            "LawnMower",                        0 ),
       new ReanimatorParams(ReanimationType.READYSETPLANT,                        "StartReadySetPlant",               1 ),
       new ReanimatorParams(ReanimationType.CHERRYBOMB,                           "CherryBomb",                       0 ),
       new ReanimatorParams(ReanimationType.SQUASH,                               "Squash",                           0 ),
       new ReanimatorParams(ReanimationType.DOOMSHROOM,                           "DoomShroom",                       0 ),
       new ReanimatorParams(ReanimationType.SNOWPEA,                              "SnowPea",                          0 ),
       new ReanimatorParams(ReanimationType.REPEATER,                             "PeaShooter",                       0 ),
       new ReanimatorParams(ReanimationType.SUNSHROOM,                            "SunShroom",                        0 ),
       new ReanimatorParams(ReanimationType.TALLNUT,                              "Tallnut",                          0 ),
       new ReanimatorParams(ReanimationType.FUMESHROOM,                           "Fumeshroom",                       0 ),
       new ReanimatorParams(ReanimationType.PUFFSHROOM,                           "Puffshroom",                       0 ),
       new ReanimatorParams(ReanimationType.HYPNOSHROOM,                          "Hypnoshroom",                      0 ),
       new ReanimatorParams(ReanimationType.CHOMPER,                              "Chomper",                          0 ),
       new ReanimatorParams(ReanimationType.ZOMBIE,                               "Zombie",                           0 ),
       new ReanimatorParams(ReanimationType.SUN,                                  "Sun",                              0 ),
       new ReanimatorParams(ReanimationType.POTATOMINE,                           "PotatoMine",                       0 ),
       new ReanimatorParams(ReanimationType.SPIKEWEED,                            "Caltrop",                          0 ),
       new ReanimatorParams(ReanimationType.SPIKEROCK,                            "SpikeRock",                        0 ),
       new ReanimatorParams(ReanimationType.THREEPEATER,                          "ThreePeater",                      0 ),
       new ReanimatorParams(ReanimationType.MARIGOLD,                             "Marigold",                         0 ),
       new ReanimatorParams(ReanimationType.ICESHROOM,                            "IceShroom",                        0 ),
       new ReanimatorParams(ReanimationType.ZOMBIE_FOOTBALL,                      "Zombie_football",                  0 ),
       new ReanimatorParams(ReanimationType.ZOMBIE_NEWSPAPER,                     "Zombie_paper",                     0 ),
       new ReanimatorParams(ReanimationType.ZOMBIE_ZAMBONI,                       "Zombie_zamboni",                   0 ),
       new ReanimatorParams(ReanimationType.SPLASH,                               "splash",                           0 ),
       new ReanimatorParams(ReanimationType.JALAPENO,                             "Jalapeno",                         0 ),
       new ReanimatorParams(ReanimationType.JALAPENO_FIRE,                        "fire",                             0 ),
       new ReanimatorParams(ReanimationType.COIN_SILVER,                          "Coin_silver",                      0 ),
       new ReanimatorParams(ReanimationType.ZOMBIE_CHARRED,                       "Zombie_charred",                   0 ),
       new ReanimatorParams(ReanimationType.ZOMBIE_CHARRED_IMP,                   "Zombie_charred_imp",               0 ),
       new ReanimatorParams(ReanimationType.ZOMBIE_CHARRED_DIGGER,                "Zombie_charred_digger",            0 ),
       new ReanimatorParams(ReanimationType.ZOMBIE_CHARRED_ZAMBONI,               "Zombie_charred_zamboni",           0 ),
       new ReanimatorParams(ReanimationType.ZOMBIE_CHARRED_CATAPULT,              "Zombie_charred_catapult",          0 ),
       new ReanimatorParams(ReanimationType.ZOMBIE_CHARRED_GARGANTUAR,            "Zombie_charred_gargantuar",        0 ),
       new ReanimatorParams(ReanimationType.SCRAREYSHROOM,                        "ScaredyShroom",                    0 ),
       new ReanimatorParams(ReanimationType.PUMPKIN,                              "Pumpkin",                          0 ),
       new ReanimatorParams(ReanimationType.PLANTERN,                             "Plantern",                         0 ),
       new ReanimatorParams(ReanimationType.TORCHWOOD,                            "Torchwood",                        0 ),
       new ReanimatorParams(ReanimationType.SPLITPEA,                             "SplitPea",                         0 ),
       new ReanimatorParams(ReanimationType.SEASHROOM,                            "SeaShroom",                        0 ),
       new ReanimatorParams(ReanimationType.BLOVER,                               "Blover",                           0 ),
       new ReanimatorParams(ReanimationType.FLOWER_POT,                           "Pot",                              0 ),
       new ReanimatorParams(ReanimationType.CACTUS,                               "Cactus",                           0 ),
       new ReanimatorParams(ReanimationType.DANCER,                               "Zombie_Jackson",				     0 ),
       new ReanimatorParams(ReanimationType.TANGLEKELP,                           "Tanglekelp",                       0 ),
       new ReanimatorParams(ReanimationType.STARFRUIT,                            "Starfruit",                        0 ),
       new ReanimatorParams(ReanimationType.POLEVAULTER,                          "Zombie_polevaulter",               0 ),
       new ReanimatorParams(ReanimationType.BALLOON,                              "Zombie_balloon",                   0 ),
       new ReanimatorParams(ReanimationType.GARGANTUAR,                           "Zombie_gargantuar",                0 ),
       new ReanimatorParams(ReanimationType.IMP,                                  "Zombie_imp",                       0 ),
       new ReanimatorParams(ReanimationType.DIGGER,                               "Zombie_digger",                    0 ),
       new ReanimatorParams(ReanimationType.DIGGER_DIRT,                          "Digger_rising_dirt",               0 ),
       new ReanimatorParams(ReanimationType.ZOMBIE_DOLPHINRIDER,                  "Zombie_dolphinrider",              0 ),
       new ReanimatorParams(ReanimationType.POGO,                                 "Zombie_pogo",                      0 ),
       new ReanimatorParams(ReanimationType.BACKUP_DANCER,                        "Zombie_dancer",                    0 ),
       new ReanimatorParams(ReanimationType.BOBSLED,                              "Zombie_bobsled",                   0 ),
       new ReanimatorParams(ReanimationType.JACKINTHEBOX,                         "Zombie_jackbox",                   0 ),
       new ReanimatorParams(ReanimationType.SNORKEL,                              "Zombie_snorkle",                   0 ),
       new ReanimatorParams(ReanimationType.BUNGEE,                               "Zombie_bungi",                     0 ),
       new ReanimatorParams(ReanimationType.CATAPULT,                             "Zombie_catapult",                  0 ),
       new ReanimatorParams(ReanimationType.LADDER,                               "Zombie_ladder",                    0 ),
       new ReanimatorParams(ReanimationType.PUFF,                                 "Puff",                             0 ),
       new ReanimatorParams(ReanimationType.SLEEPING,                             "Z",                                0 ),
       new ReanimatorParams(ReanimationType.GRAVE_BUSTER,                         "Gravebuster",                      0 ),
       new ReanimatorParams(ReanimationType.ZOMBIES_WON,                          "ZombiesWon",                       1 ),
       new ReanimatorParams(ReanimationType.MAGNETSHROOM,                         "Magnetshroom",                     0 ),
       new ReanimatorParams(ReanimationType.BOSS,                                 "Zombie_boss",                      0 ),
       new ReanimatorParams(ReanimationType.CABBAGEPULT,                          "Cabbagepult",                      0 ),
       new ReanimatorParams(ReanimationType.KERNELPULT,                           "Cornpult",                         0 ),
       new ReanimatorParams(ReanimationType.MELONPULT,                            "Melonpult",                        0 ),
       new ReanimatorParams(ReanimationType.COFFEEBEAN,                           "Coffeebean",                       1 ),
       new ReanimatorParams(ReanimationType.UMBRELLALEAF,                         "Umbrellaleaf",                     0 ),
       new ReanimatorParams(ReanimationType.GATLINGPEA,                           "GatlingPea",                       0 ),
       new ReanimatorParams(ReanimationType.CATTAIL,                              "Cattail",                          0 ),
       new ReanimatorParams(ReanimationType.GLOOMSHROOM,                          "GloomShroom",                      0 ),
       new ReanimatorParams(ReanimationType.BOSS_ICEBALL,                         "Zombie_boss_iceball",              1 ),
       new ReanimatorParams(ReanimationType.BOSS_FIREBALL,                        "Zombie_boss_fireball",             1 ),
       new ReanimatorParams(ReanimationType.COBCANNON,                            "CobCannon",                        0 ),
       new ReanimatorParams(ReanimationType.GARLIC,                               "Garlic",                           0 ),
       new ReanimatorParams(ReanimationType.GOLD_MAGNET,                          "GoldMagnet",                       0 ),
       new ReanimatorParams(ReanimationType.WINTER_MELON,                         "WinterMelon",                      0 ),
       new ReanimatorParams(ReanimationType.TWIN_SUNFLOWER,                       "TwinSunflower",                    0 ),
       new ReanimatorParams(ReanimationType.POOL_CLEANER,                         "PoolCleaner",                      0 ),
       new ReanimatorParams(ReanimationType.ROOF_CLEANER,                         "RoofCleaner",                      0 ),
       new ReanimatorParams(ReanimationType.FIRE_PEA,                             "FirePea",                          0 ),
       new ReanimatorParams(ReanimationType.IMITATER,                             "Imitater",                         0 ),
       new ReanimatorParams(ReanimationType.YETI,                                 "Zombie_yeti",                      0 ),
       new ReanimatorParams(ReanimationType.BOSS_DRIVER,                          "Zombie_Boss_driver",               0 ),
       new ReanimatorParams(ReanimationType.LAWN_MOWERED_ZOMBIE,                  "LawnMoweredZombie",                0 ),
       new ReanimatorParams(ReanimationType.CRAZY_DAVE,                           "CrazyDave",                        1 ),
       new ReanimatorParams(ReanimationType.TEXT_FADE_ON,                         "TextFadeOn",                       0 ),
       new ReanimatorParams(ReanimationType.HAMMER,                               "Hammer",                           0 ),
       new ReanimatorParams(ReanimationType.SLOT_MACHINE_HANDLE,                  "SlotMachine",                      0 ),
       new ReanimatorParams(ReanimationType.CREDITS_FOOTBALL,                     "Credits_Football",                 1 ),
       new ReanimatorParams(ReanimationType.CREDITS_JACKBOX,                      "Credits_Jackbox",                  1 ),
       new ReanimatorParams(ReanimationType.SELECTOR_SCREEN,                      "SelectorScreen",                   3 ),
       new ReanimatorParams(ReanimationType.PORTAL_CIRCLE,                        "Portal_Circle",                    0 ),
       new ReanimatorParams(ReanimationType.PORTAL_SQUARE,                        "Portal_Square",                    0 ),
       new ReanimatorParams(ReanimationType.ZENGARDEN_SPROUT,                     "ZenGarden_sprout",                 0 ),
       new ReanimatorParams(ReanimationType.ZENGARDEN_WATERINGCAN,                "ZenGarden_wateringcan",            1 ),
       new ReanimatorParams(ReanimationType.ZENGARDEN_FERTILIZER,                 "ZenGarden_fertilizer",             1 ),
       new ReanimatorParams(ReanimationType.ZENGARDEN_BUGSPRAY,                   "ZenGarden_bugspray",               1 ),
       new ReanimatorParams(ReanimationType.ZENGARDEN_PHONOGRAPH,                 "ZenGarden_phonograph",             1 ),
       new ReanimatorParams(ReanimationType.DIAMOND,                              "Diamond",                          0 ),
       new ReanimatorParams(ReanimationType.ZOMBIE_HAND,                          "Zombie_hand",                      1 ),
       new ReanimatorParams(ReanimationType.STINKY,                               "Stinky",                           0 ),
       new ReanimatorParams(ReanimationType.RAKE,                                 "Rake",                             0 ),
       new ReanimatorParams(ReanimationType.RAIN_CIRCLE,                          "Rain_circle",                      0 ),
       new ReanimatorParams(ReanimationType.RAIN_SPLASH,                          "Rain_splash",                      0 ),
       new ReanimatorParams(ReanimationType.ZOMBIE_SURPRISE,                      "Zombie_surprise",                  0 ),
       new ReanimatorParams(ReanimationType.COIN_GOLD,                            "Coin_gold",                        0 ),
       new ReanimatorParams(ReanimationType.TREEOFWISDOM,                         "TreeOfWisdom",                     1 ),
       new ReanimatorParams(ReanimationType.TREEOFWISDOM_CLOUDS,                  "TreeOfWisdomClouds",               1 ),
       new ReanimatorParams(ReanimationType.TREEOFWISDOM_TREEFOOD,                "TreeFood",                         1 ),
       new ReanimatorParams(ReanimationType.CREDITS_MAIN,                         "Credits_Main",                     3 ),
       new ReanimatorParams(ReanimationType.CREDITS_MAIN2,                        "Credits_Main2",                    3 ),
       new ReanimatorParams(ReanimationType.CREDITS_MAIN3,                        "Credits_Main3",                    3 ),
       new ReanimatorParams(ReanimationType.ZOMBIE_CREDITS_DANCE,                 "Zombie_credits_dance",             0 ),
       new ReanimatorParams(ReanimationType.CREDITS_STAGE,                        "Credits_stage",                    1 ),
       new ReanimatorParams(ReanimationType.CREDITS_BIGBRAIN,                     "Credits_BigBrain",                 1 ),
       new ReanimatorParams(ReanimationType.CREDITS_FLOWER_PETALS,                "Credits_Flower_petals",            1 ),
       new ReanimatorParams(ReanimationType.CREDITS_INFANTRY,                     "Credits_Infantry",                 1 ),
       new ReanimatorParams(ReanimationType.CREDITS_THROAT,                       "Credits_Throat",                   1 ),
       new ReanimatorParams(ReanimationType.CREDITS_CRAZYDAVE,                    "Credits_CrazyDave",                1 ),
       new ReanimatorParams(ReanimationType.CREDITS_BOSSDANCE,                    "Credits_Bossdance",                1 ),
       new ReanimatorParams(ReanimationType.ZOMBIE_CREDITS_SCREEN_DOOR,           "Zombie_Credits_Screendoor",        1 ),
       new ReanimatorParams(ReanimationType.ZOMBIE_CREDITS_CONEHEAD,              "Zombie_Credits_Conehead",          1 ),
       new ReanimatorParams(ReanimationType.CREDITS_ZOMBIEARMY1,                  "Credits_ZombieArmy1",              1 ),
       new ReanimatorParams(ReanimationType.CREDITS_ZOMBIEARMY2,                  "Credits_ZombieArmy2",              1 ),
       new ReanimatorParams(ReanimationType.CREDITS_TOMBSTONES,                   "Credits_Tombstones",               1 ),
       new ReanimatorParams(ReanimationType.CREDITS_SOLARPOWER,                   "Credits_SolarPower",               1 ),
       new ReanimatorParams(ReanimationType.CREDITS_ANYHOUR,                      "Credits_Anyhour",                  3 ),
       new ReanimatorParams(ReanimationType.CREDITS_WEARETHEUNDEAD,               "Credits_WeAreTheUndead",           1 ),
       new ReanimatorParams(ReanimationType.CREDITS_DISCOLIGHTS,                  "Credits_DiscoLights",              1 ),
       new ReanimatorParams(ReanimationType.FLAG,                                 "Zombie_FlagPole",                  0 )
    ];

    public static inline final NO_BASE_POSE:Int = -2;

    public static var reanimatorDefArray:Array<ReanimatorDefinition> = [];

    public static var loadingProgress:Float;
    public static var _reanimsLoaded:Int;

    public var reanimationType:ReanimationType;
    public var animTime:Float;
    public var animRate:Float;
    public var definition:ReanimatorDefinition;
    public var loopType:ReanimLoopType;
    public var dead:Bool;
    public var frameStart:Int;
    public var frameCount:Int;
    public var frameBasePose:Int;
    public var overlayMatrix:FlxMatrix;
    public var colorOverride:FlxColor;
    public var trackInstances:Array<ReanimatorTrackInstance>;
    public var loopCount:Int;
    public var reanimationHolder:ReanimationHolder;
    public var isAttachment:Bool;
    public var renderOrder:Int;
    public var extraAdditiveColor:FlxColor;
    public var enableExtraAdditiveColor:Bool;
    public var extraOverlayColor:FlxColor;
    public var enableExtraOverlayColor:Bool;
    public var lastFrameTime:Float;
    public var filterEffect:FilterEffectType;
    public var offset:FlxPoint;

    public function new()
    {
        animTime = 0;
        animRate = 12;
        loopCount = ReanimLoopType.PLAY_ONCE;
        lastFrameTime = -1;
        dead = false;
        frameStart = 0;
        frameCount = 0;
        frameBasePose = -1;
        overlayMatrix = new FlxMatrix();
        overlayMatrix.identity();
        colorOverride = FlxColor.WHITE;
        extraAdditiveColor = FlxColor.WHITE;
        enableExtraAdditiveColor = false;
        extraOverlayColor = FlxColor.WHITE;
        enableExtraOverlayColor = false;
        loopCount = 0;
        isAttachment = false;
        renderOrder = 0;
        trackInstances = [];
        reanimationType = ReanimationType.NONE;
        filterEffect = FilterEffectType.NONE;
        offset = FlxPoint.get();
    }

    public function reanimationDie()
    {
        if (!dead)
        {
            dead = true;
            for (i in 0...definition.tracks.length)
            {
                Attachment.attachmentDie(trackInstances[i].attachment);
            }
        }
    }

    public static function getReanimPath(id:String) : String
    {
        id = id.toLowerCase();

        var musicList = Assets.list(AssetType.TEXT);

        for (path in musicList)
        {
            var file = path.split("/").pop();
            if (file.toLowerCase() == id)
            {
                return path;
            }
        }

        return null;
    }

    public static function definitionLoadXML(fileName:String, definition:ReanimatorDefinition)
    {
        var xml = Xml.parse(Assets.getText(getReanimPath(fileName + ".reanim")));
        for (element in xml.elements())
        {
            switch(element.nodeName)
            {
                case "fps":
                    definition.fps = Std.parseFloat(element.firstChild().nodeValue);
                case "track":
                    var track = new ReanimatorTrack();
                    for (trackChild in element.elements())
                    {
                        switch (trackChild.nodeName)
                        {
                            case "name": track.name = trackChild.firstChild().nodeValue;
                            case "t":
                                var transf = new ReanimatorTransform();
                                for (tChild in trackChild.elements())
                                {
                                    switch (tChild.nodeName)
                                    {
                                        case "a": transf.alpha = Std.parseFloat(tChild.firstChild().nodeValue);
                                        case "f": transf.frame = Std.parseFloat(tChild.firstChild().nodeValue);
                                        case "x":
                                            transf.transX = Std.parseFloat(tChild.firstChild().nodeValue);
                                        case "y":
                                            transf.transY = Std.parseFloat(tChild.firstChild().nodeValue);
                                        case "sx":
                                            transf.scaleX = Std.parseFloat(tChild.firstChild().nodeValue);
                                        case "sy":
                                            transf.scaleY = Std.parseFloat(tChild.firstChild().nodeValue);
                                        case "kx":
                                            transf.skewX = Std.parseFloat(tChild.firstChild().nodeValue);
                                        case "ky":
                                            transf.skewY = Std.parseFloat(tChild.firstChild().nodeValue);
                                        case "text": transf.text = tChild.firstChild().nodeValue;
                                        case "i":
                                            var rawName = tChild.firstChild().nodeValue;
                                            var base = rawName.replace("IMAGE_REANIM_", "");
                                            var parts = base.split("_");
                                            var formatted = [];
                                            for (i in 0...parts.length)
                                            {
                                                var word = parts[i].toLowerCase();
                                                if (i == 0) word = word.charAt(0).toUpperCase() + word.substr(1);
                                                formatted.push(word);
                                            }
                                            var fileName = formatted.join("_");
                                            transf.image = ImageLib.getImage(fileName);
                                    }
                                }
                                track.transforms.push(transf);
                        }
                    }
                    definition.tracks.push(track);
            }
        }
        return true;
    }

    public static function reanimationLoadDefinition(fileName:String, definition:ReanimatorDefinition)
    {
        if (!definitionLoadXML(fileName,definition))
            return false;

        for (track in definition.tracks)
        {
            var prevTransX:Float = 0;
            var prevTransY:Float = 0;
            var prevSkewX:Float = 0;
            var prevSkewY:Float = 0;
            var prevScaleX:Float = 1;
            var prevScaleY:Float = 1;
            var prevFrame:Float = 0;
            var prevAlpha:Float = 1;
            var prevImage:Image = null;
            var prevFont:Font = null;
            var prevText = "";

            for (trans in track.transforms)
            {
                if (trans.transX == null) trans.transX = prevTransX;
                else prevTransX = trans.transX;

                if (trans.transY == null) trans.transY = prevTransY;
                else prevTransY = trans.transY;

                if (trans.skewX == null) trans.skewX = prevSkewX;
                else prevSkewX = trans.skewX;

                if (trans.skewY == null) trans.skewY = prevSkewY;
                else prevSkewY = trans.skewY;

                if (trans.scaleX == null) trans.scaleX = prevScaleX;
                else prevScaleX = trans.scaleX;

                if (trans.scaleY == null) trans.scaleY = prevScaleY;
                else prevScaleY = trans.scaleY;

                if (trans.frame == null)  trans.frame = prevFrame;
                else prevFrame = trans.frame;

                if (trans.alpha == null)  trans.alpha = prevAlpha;
                else prevAlpha = trans.alpha;

                if (trans.image == null)  trans.image = prevImage;
                else prevImage = trans.image;

                if (trans.font == null)  trans.font = prevFont;
                else prevFont = trans.font;

                if (trans.text.charCodeAt(0) == 0)  trans.text = prevText;
                else prevText = trans.text;
            }
        }

        return true;
    }

    public function setPosition(x:Float, y:Float)
    {
        overlayMatrix.translate(x, y);
    }

    public function overrideScale(scaleX:Float, scaleY:Float)
    {
        overlayMatrix.a = scaleX;
        overlayMatrix.d = scaleY;
    }

    public function reanimationCreateAtlas(definition:ReanimatorDefinition, reanimType:Int)
    {
        var param = reanimationParamArray[reanimType];
        if (definition == null || definition.reanimAtlas != null)
            return;

        var atlas = new ReanimAtlas();
        definition.reanimAtlas = atlas;
        atlas.reanimAtlasCreate(definition);
    }

    public function reanimationInitializeType(x:Float, y:Float, reanimType:ReanimationType)
    {
        reanimatorEnsureDefinitionLoaded(reanimType, false);
        this.reanimationType = reanimType;
        reanimationInitialize(x, y, reanimatorDefArray[reanimType]);
    }

    public static function reanimatorLoadDefinitions()
    {
        _reanimsLoaded = 0;
        loadingProgress = 0;

        for (param in reanimationParamArray)
        {
            reanimatorEnsureDefinitionLoaded(param.reanimationType, false);
            _reanimsLoaded++;
            loadingProgress = _reanimsLoaded / (ReanimationType.NUM_REANIMS - 1);
        }

        loadingProgress = 1;
    }

    public function reanimationInitialize(x:Float, y:Float, definition:ReanimatorDefinition)
    {
        reanimationCreateAtlas(definition, reanimationType);
        dead = false;
        setPosition(x, y);
        this.definition = definition;
        animRate = definition.fps;
        lastFrameTime = -1;

        if (definition.tracks.length != 0)
        {
            frameCount = definition.tracks[0].transforms.length;

            for (i in 0...definition.tracks.length)
            {
                var track = new ReanimatorTrackInstance();
                trackInstances.push(track);
            }
        }
        else
        {
            frameCount = 0;
        }
    }

    public static function reanimatorEnsureDefinitionLoaded(reanimType:ReanimationType, isPreloading:Bool)
    {
        var reanimDef = reanimatorDefArray[reanimType];
        if (reanimDef != null && reanimDef.tracks != null)
        {
            return;
        }

        var reanimParams = reanimationParamArray[reanimType];
        //if (isPreloading) {}

        reanimatorDefArray[reanimType] = new ReanimatorDefinition();
        reanimDef = reanimatorDefArray[reanimType];

        if (!reanimationLoadDefinition(reanimParams.reanimFileName, reanimDef))
        {
            Application.current.window.alert("Failed to load reanim " + reanimParams.reanimFileName, "Error");
        }
    }

    public function update(elapsed:Float)
    {
        if (frameCount == 0 || dead)
        {
            return;
        }

        lastFrameTime = animTime;
        animTime += elapsed * animRate / frameCount;

        if (animRate > 0)
        {
            switch (loopType)
            {
                case ReanimLoopType.LOOP | ReanimLoopType.LOOP_FULL_LAST_FRAME:
                    while (animTime >= 1.0)
                    {
                        loopCount += 1;
                        animTime -= 1;
                    }
                case ReanimLoopType.PLAY_ONCE | ReanimLoopType.PLAY_ONCE_FULL_LAST_FRAME:

                    if (animTime >= 1.0)
                    {
                        loopCount = 1;
                        animTime = 1.0;
                        dead = true;
                    }
                case ReanimLoopType.PLAY_ONCE_AND_HOLD | ReanimLoopType.PLAY_ONCE_FULL_LAST_FRAME_AND_HOLD:
                    if (animTime >= 1.0)
                    {
                        loopCount = 1;
                        animTime = 1.0;
                    }
            }
        }
        else
        {
            switch (loopType)
            {
                case ReanimLoopType.LOOP | ReanimLoopType.LOOP_FULL_LAST_FRAME:
                    while (animTime < 0.0)
                    {
                        loopCount += 1;
                        animTime += 1;
                    }
                case ReanimLoopType.PLAY_ONCE | ReanimLoopType.PLAY_ONCE_FULL_LAST_FRAME:
                    if (animTime < 0.0)
                    {
                        loopCount = 1;
                        animTime = 0.0;
                        dead = true;
                    }
                case ReanimLoopType.PLAY_ONCE_AND_HOLD | ReanimLoopType.PLAY_ONCE_FULL_LAST_FRAME_AND_HOLD:
                    if (animTime < 0.0)
                    {
                        loopCount = 1;
                        animTime = 0.0;
                    }
            }
        }

        for (trackIndex in 0...definition.tracks.length)
        {
            var track = trackInstances[trackIndex];
            if (track.blendCounter > 0)
                track.blendCounter -= elapsed;

            if (track.shakeOverride != 0)
            {
                track.shake.set(FlxG.random.float(-track.shakeOverride, track.shakeOverride), FlxG.random.float(-track.shakeOverride, track.shakeOverride));
            }

            if (definition.tracks[trackIndex].name.startsWith("attacher__"))
            {
                updateAttacherTrack(trackIndex, elapsed);
            }

            if (track.attachment != null)
            {
                Attachment.attachmentUpdateAndSetMatrix(elapsed, track.attachment, getAttachmentOverlayMatrix(trackIndex));
            }
            
        }
    }

    public function getFrameTime(frameTime:ReanimatorFrameTime)
    {
        var aFrameCount = 0;

        if (loopType == ReanimLoopType.PLAY_ONCE_FULL_LAST_FRAME || loopType == ReanimLoopType.LOOP_FULL_LAST_FRAME ||
            loopType == ReanimLoopType.PLAY_ONCE_FULL_LAST_FRAME_AND_HOLD)
            aFrameCount = frameCount;
        else
            aFrameCount = frameCount - 1;

        var animPosition = frameStart + animTime * aFrameCount;
        var animFrameBefore = Math.ffloor(animPosition);

        frameTime.fraction = animPosition - animFrameBefore;
        frameTime.animFrameBefore = Std.int(animFrameBefore);

        if (frameTime.animFrameBefore >= frameStart + frameCount - 1)
        {
            frameTime.animFrameBefore = frameStart + frameCount - 1;
            frameTime.animFrameAfter = frameTime.animFrameBefore;
        }
        else
        {
            frameTime.animFrameAfter = frameTime.animFrameBefore + 1;
        }
    }

    public function getTrackIndex(name:String)
    {
        for (track in definition.tracks)
        {
            if (track.name == name)
            {
                return definition.tracks.indexOf(track);
            }
        }
        return 0;
    }

    public function getTransformAtTime(trackIndex:Int, transform:ReanimatorTransform, frameTime:ReanimatorFrameTime)
    {
        var track = definition.tracks[trackIndex];
        var transBefore = track.transforms[frameTime.animFrameBefore];
        var transAfter = track.transforms[frameTime.animFrameAfter];

        transform.transX = FlxMath.lerp(transBefore.transX, transAfter.transX, frameTime.fraction);
        transform.transY = FlxMath.lerp(transBefore.transY, transAfter.transY, frameTime.fraction);

        transform.skewX = FlxMath.lerp(transBefore.skewX, transAfter.skewX, frameTime.fraction);
        transform.skewY = FlxMath.lerp(transBefore.skewY, transAfter.skewY, frameTime.fraction);

        transform.scaleX = FlxMath.lerp(transBefore.scaleX, transAfter.scaleX, frameTime.fraction);
        transform.scaleY = FlxMath.lerp(transBefore.scaleY, transAfter.scaleY, frameTime.fraction);

        transform.alpha = FlxMath.lerp(transBefore.alpha, transAfter.alpha, frameTime.fraction);
        transform.image = transBefore.image;
        transform.font = transBefore.font;
        transform.text = transBefore.text;

        if (transBefore.frame != -1.0 && transAfter.frame == -1.0 && frameTime.fraction > 0.0 &&
            trackInstances[trackIndex].truncateDisappearingFrames)
            transform.frame = -1.0;
        else
            transform.frame = transBefore.frame;
    }

    public function blendTransform(result:ReanimatorTransform, transform1:ReanimatorTransform, transform2:ReanimatorTransform, blendFactor:Float)
    {
        result.transX =  FlxMath.lerp(transform1.transX, transform2.transX, blendFactor);
        result.transY =  FlxMath.lerp(transform1.transY, transform2.transY, blendFactor);

        result.scaleX =  FlxMath.lerp(transform1.scaleX, transform2.scaleX, blendFactor);
        result.scaleY =  FlxMath.lerp(transform1.scaleY, transform2.scaleY, blendFactor);

        result.alpha = FlxMath.lerp(transform1.alpha, transform2.alpha, blendFactor);

        var skewX2 = transform2.skewX;
        var skewY2 = transform2.skewY;

        while (skewX2 > transform1.skewX + 180.0)
            skewX2 = transform1.skewX;
        while (skewX2 < transform1.skewX - 180.0)
            skewX2 = transform1.skewX;
        while (skewY2 > transform1.skewY + 180.0)
            skewY2 = transform1.skewY;
        while (skewY2 < transform1.skewY - 180.0)
            skewY2 = transform1.skewY;

        result.skewX = FlxMath.lerp(transform1.skewX, skewX2, blendFactor);
        result.skewY = FlxMath.lerp(transform1.skewY, skewY2, blendFactor);

        result.frame = transform1.frame;
        result.font = transform1.font;
        result.text = transform1.text;
        result.image = transform1.image;
    }

    public function getCurrentTransform(trackIndex:Int, transformCurrent:ReanimatorTransform)
    {
        var frameTime = new ReanimatorFrameTime();
        getFrameTime(frameTime);
        getTransformAtTime(trackIndex, transformCurrent, frameTime);

        var track = trackInstances[trackIndex];
        if (Math.round(transformCurrent.frame) >= 0 && track.blendCounter > 0)
        {
            var blendFactor = track.blendCounter / track.blendTime;
            var result = new ReanimatorTransform();
            blendTransform(transformCurrent, transformCurrent, track.blendTransform, blendFactor);
            transformCurrent = result;
        }
    }

    public function drawTrack(g:Graphics, trackIndex:Int,renderGroup:Int)
    {
        g.pushState();

        var trackInstance = trackInstances[trackIndex];
        var transform = new ReanimatorTransform();
        getCurrentTransform(trackIndex, transform);

        if (transform.scaleX < 0 && transform.image != null)
        {
            transform.transX += transform.image.bmp.width * Math.abs(transform.scaleX);
        }
        if (transform.scaleY < 0 && transform.image != null)
        {
            transform.transY += transform.image.bmp.height * Math.abs(transform.scaleY);
        }

        var imageFrame = Math.round(transform.frame);
        if (imageFrame < 0)
        {
            g.popState();
            return false;
        }

        var color = trackInstance.trackColor;
        if (!trackInstance.ignoreColorOverride)
        {
            color = FlxColor.multiply(color, colorOverride);
        }
        if (g.getColorizedImages())
        {
            color = FlxColor.multiply(color, g.getColor());
        }
        var imageAlpha:Int = Std.int(FlxMath.bound(Math.round(transform.alpha * color.alpha), 0, 255));
        if (imageAlpha <= 0)
        {
            g.popState();
            return false;
        }
        color.alpha = imageAlpha;

        var aExtraAdditiveColor = FlxColor.TRANSPARENT;

        if (enableExtraAdditiveColor)
        {
            aExtraAdditiveColor = extraAdditiveColor;
            aExtraAdditiveColor.alphaFloat = aExtraAdditiveColor.alphaFloat * imageAlpha;
        }

        var aExtraOverlayColor = FlxColor.TRANSPARENT;

        if (enableExtraOverlayColor)
        {
            aExtraOverlayColor = extraOverlayColor;
            aExtraOverlayColor.alphaFloat = extraOverlayColor.alphaFloat * imageAlpha;
        }

        // var clipRect = g.clipRect;
        // if (trackInstance.ignoreClipRect)
        //     clipRect = g.camera.getViewMarginRect();

        var image = null; 
        if (transform.image != null) 
        {
            image = transform.image.bmp;
        }
        var atlas:ReanimAtlasImage = null;
        if (definition.reanimAtlas != null && image != null)
        {
            atlas = definition.reanimAtlas.getEncodedReanimAtlas(transform.image);
            if (atlas != null)
            {
                image = atlas.originalImage.bmp;
            }
            if (trackInstance.imageOverride != null)
            {
                atlas = null;
            }
        }

        g.setColor(color);

        var matrix = new FlxMatrix();

        var fullscreen = false;
        if (image != null)
        {
            // var aCelWidth = transform.image.getCelWidth();
            // var aCelHeight = transform.image.getCelHeight();
            // matrix.identity();
            // matrix.translate(aCelWidth * 0.5, aCelHeight * 0.5); ALREADY CENTRED???
        }
        else if (transform.font != null && transform.text != String.fromCharCode(0))
        {
            matrix.identity();
            var aWidth = transform.font.stringWidth(transform.text);
            matrix.translate(-aWidth * 0.5, transform.font.ascent);
        }
        else
        {
            if (definition.tracks[trackIndex].name.toLowerCase() == "fullscreen")
            {
                g.popState();
                return false;
            }

            matrix.identity();
            fullscreen = true;
        }
        
        matrix.translate(trackInstance.shake.x, trackInstance.shake.y);

        var aTransformMatrix = new FlxMatrix();
        matrixFromTransform(transform, aTransformMatrix);

        g.matrix.concat(matrix);
        g.matrix.concat(aTransformMatrix);
        g.matrix.concat(overlayMatrix);

        //g.clipRect.x -= g.matrix.tx;
        //g.clipRect.y -= g.matrix.ty;

        if (atlas != null)
        {
            var srcRect = FlxRect.get();
            srcRect.copyFrom(atlas.rect);
            image = definition.reanimAtlas.image;
            if (filterEffect != FilterEffectType.NONE)
            {
                image = FilterEffect.filterEffectGetImage(image, filterEffect);
            }
    
            g.drawSourceImage(image, srcRect);

            if (enableExtraAdditiveColor)
            {
                g.pushState();
                g.blendMode = ADD;
                g.setColor(extraAdditiveColor);
                g.drawSourceImage(image, srcRect);
                g.popState();
            }

            if (enableExtraOverlayColor)
            {
                g.pushState();
                g.blendMode = OVERLAY;
                g.setColor(extraOverlayColor);
                g.drawSourceImage(image, srcRect);
                g.popState();
            }
        }
        else if (image != null)
        {   
            if (trackInstance.imageOverride != null)
            {
                image = trackInstance.imageOverride.bmp;
            }

            if (!transform.image.hasTrans) 
            {
                transform.image.trySanding();
            }

            if (filterEffect != FilterEffectType.NONE)
            {
                image = FilterEffect.filterEffectGetImage(image, filterEffect);
            }

            g.drawImage(image);

            if (enableExtraAdditiveColor)
            {
                g.pushState();
                g.blendMode = ADD;
                g.setColor(extraAdditiveColor);
                g.drawImage(image);
                g.popState();
            }

            if (enableExtraOverlayColor)
            {
                g.pushState();
                g.blendMode = ADD;
                g.setColor(extraOverlayColor);
                g.drawImage(image);
                g.popState();
            }
        }
        else if (fullscreen)
        {
            //g.setColor(color);
            //g.fillRect(FlxRect.get(-g.trans.x - g.scroll.x, -g.trans.y - g.scroll.y, FlxG.game.width, FlxG.game.height));
        }

        g.popState();
        return true;
    }

    public function drawRenderGroup(g:Graphics, renderGroup:RenderGroup)
    {
        if (dead)
        {
            return;
        }

        for (trackIndex in 0...definition.tracks.length)
        {
            var track = trackInstances[trackIndex];

            if (track.renderGroup == renderGroup)
            {
                var aTrackDrawn = false;

                if (track.renderInBack && track.attachment != null)
                {
                    Attachment.attachmentDraw(track.attachment, g, aTrackDrawn);
                }

                if (!track.forceDontRender)
                    aTrackDrawn = drawTrack(g, trackIndex, renderGroup);

                if (!track.renderInBack && track.attachment != null)
                {
                    Attachment.attachmentDraw(track.attachment, g, !aTrackDrawn);
                }
            }
        }
    }

    public function draw(g:Graphics)
    {
        drawRenderGroup(g, RenderGroup.NORMAL);
    }

    public function startBlend(blendTime:Float)
    {
        for (aTrackIndex in 0...definition.tracks.length)
        {
            var transform = new ReanimatorTransform();

            getCurrentTransform(aTrackIndex, transform);
            if (Math.round(transform.frame) >= 0)
            {
                var trackInstance = trackInstances[aTrackIndex];
                trackInstance.blendTransform = transform;
                trackInstance.blendTime = blendTime;
                trackInstance.blendCounter = blendTime;
                trackInstance.blendTransform.font = null;
                trackInstance.blendTransform.text = "";
                trackInstance.blendTransform.image = null;
            }
        }
    }

    public function findTrackIndex(trackName:String)
    {
        for (track in definition.tracks)
        {
            if (track.name.toLowerCase() == trackName.toLowerCase())
                return definition.tracks.indexOf(track);
        }

        return 0;
    }

    public function getFramesForLayer(trackName:String, frameStart:IntRef, frameCount:IntRef)
    {
        if (definition.tracks.length == 0)
        {
            frameStart.value = 0;
            frameCount.value = 0;
            return;
        }

        var trackIndex = findTrackIndex(trackName);
        var track = definition.tracks[trackIndex];
        frameStart.value = 0;
        frameCount.value = 1;
        for (i in 0...track.transforms.length)
            if (track.transforms[i].frame >= 0)
            {
                frameStart.value = i;
                break;
            }
        for (j in frameStart.value...track.transforms.length)
            if (track.transforms[j].frame >= 0)
                frameCount.value = j - frameStart.value + 1;
    }

    public function setFramesForLayer(trackName:String)
    {
        if (animRate >= 0)
            animTime = 0;
        else
            animTime = 0.9999999;
        lastFrameTime = -1;

        var temp = new IntRef(0);
        var temp2 = new IntRef(0);
        getFramesForLayer(trackName, temp, temp2);
        frameStart = temp.value;
        frameCount = temp2.value;
    }

    public function playReanim(trackName:String, loopType:ReanimLoopType, blendTime:Float, animRate:Float)
    {
        if (blendTime > 0)
            startBlend(blendTime);
        if (animRate != 0)
            this.animRate = animRate;

        this.loopType = loopType;
        loopCount = 0;
        setFramesForLayer(trackName);
    }

    public function setBasePoseFromAnim(trackName:String)
    {
        var temp = new IntRef(0);
        var temp2 = new IntRef(0);
        getFramesForLayer(trackName, temp, temp2);
        frameBasePose = temp.value;
    }

    public function matrixFromTransform(transform:ReanimatorTransform, matrix:FlxMatrix)
    {
        var aSkewX = -(transform.skewX * FlxAngle.TO_RAD);
	    var aSkewY = -(transform.skewY * FlxAngle.TO_RAD);

        matrix.a = Math.cos(aSkewX) * transform.scaleX;
        matrix.b = -Math.sin(aSkewX) * transform.scaleX;
        matrix.c = Math.sin(aSkewY) * transform.scaleY;
        matrix.d = Math.cos(aSkewY) * transform.scaleY;
        matrix.tx = transform.transX;
        matrix.ty = transform.transY;
    }

    public function propogateColorToAttachments()
    {
        for (i in 0...definition.tracks.length)
        {
            Attachment.attachmentPropogateColor(
                trackInstances[i].attachment, 
                colorOverride, 
                enableExtraAdditiveColor, 
                extraAdditiveColor, 
                enableExtraOverlayColor, 
                extraOverlayColor
            );
        }
    }

    public function getTrackBasePoseMatrix(trackIndex:Int, basePosMatrix:FlxMatrix)
    {
        if (frameBasePose == NO_BASE_POSE)
        {
            basePosMatrix.identity();
            return;
        }

        var aBasePos = frameBasePose == -1 ? frameStart : frameBasePose;
        var  aStartTime = new ReanimatorFrameTime();
        aStartTime.fraction = 0;
        aStartTime.animFrameBefore = aBasePos;
        aStartTime.animFrameAfter = aBasePos + 1;
        var aTransformStart = new ReanimatorTransform();
        getTransformAtTime(trackIndex, aTransformStart, aStartTime);
        matrixFromTransform(aTransformStart, basePosMatrix);
    }

    public function getAttachmentOverlayMatrix(trackIndex:Int):FlxMatrix
    {
        var aTransform = new ReanimatorTransform();
        getCurrentTransform(trackIndex, aTransform);
    
        var aTransformMatrix = new FlxMatrix();
        matrixFromTransform(aTransform, aTransformMatrix);
    
        TodCommon.sexyMatrix3Multiply(aTransformMatrix, overlayMatrix, aTransformMatrix);
    
        var aBasePoseMatrix = new FlxMatrix();
        getTrackBasePoseMatrix(trackIndex, aBasePoseMatrix);
    
        var aBasePoseMatrixInv = new FlxMatrix();
        TodCommon.sexyMatrix3Inverse(aBasePoseMatrix, aBasePoseMatrixInv);
        
        var r = aBasePoseMatrixInv.clone();
        r.concat(aTransformMatrix);

        var result = new FlxMatrix();
        result.copyFrom(r.clone()); 
        return result;
    }             

    public function parseAttacherTrack(theTransform:ReanimatorTransform, theAttacherInfo:AttacherInfo)
    {
        theAttacherInfo.reanimName = "";
        theAttacherInfo.trackName = "";
        theAttacherInfo.animRate = 12.0;
        theAttacherInfo.loopType = ReanimLoopType.LOOP;

        if (theTransform.frame == -1)
        {
            return;
        }
    
        var text = theTransform.text;
        if (text == null)
            return;
    
        var aReanimName = text.indexOf("__");
        if (aReanimName == -1)
            return;
    
        var aTags = text.indexOf("[", aReanimName + 2);
        var aTrackName = text.indexOf("__", aReanimName + 2);
    
        if (aTags != -1 && aTrackName != -1 && aTags < aTrackName)
            return;
    
        if (aTrackName != -1)
        {
            theAttacherInfo.reanimName = text.substr(aReanimName + 2, aTrackName - (aReanimName + 2));
    
            if (aTags != -1)
                theAttacherInfo.trackName = text.substr(aTrackName + 2, aTags - (aTrackName + 2));
            else
                theAttacherInfo.trackName = text.substr(aTrackName + 2);
        }
        else if (aTags != -1)
        {
            theAttacherInfo.reanimName = text.substr(aReanimName + 2, aTags - (aReanimName + 2));
        }
        else
        {
            theAttacherInfo.reanimName = text.substr(aReanimName + 2);
        }
    
        var searchPos = aTags;
        while (searchPos != -1)
        {
            var aTagEnds = text.indexOf("]", searchPos + 1);
            if (aTagEnds == -1)
                break;
    
            var aCode = text.substr(searchPos + 1, aTagEnds - (searchPos + 1));
    
            var rate = Std.parseFloat(aCode);
            if (!Math.isNaN(rate))
            {
                theAttacherInfo.animRate = rate;
            }
            else
            {
                switch (aCode)
                {
                    case "hold":
                        theAttacherInfo.loopType = ReanimLoopType.PLAY_ONCE_AND_HOLD;
                    case "once":
                        theAttacherInfo.loopType = ReanimLoopType.PLAY_ONCE;
                }
            }
    
            searchPos = text.indexOf("[", aTagEnds + 1);
        }     
    }

    public function trackExists(trackName:String)
    {
        for (track in definition.tracks)
        {
            if (track.name.toLowerCase() == trackName.toLowerCase())
            {
                return true;
            }
        }

        return false;
    }

    public function attacherSynchWalkSpeed(trackIndex:Int, attachReanim:Reanimation, attacherInfo:AttacherInfo)
    {
        var aTrack = definition.tracks[trackIndex];
        var aFrameTime = new ReanimatorFrameTime();
        getFrameTime(aFrameTime);

        var aPlaceHolderFrameStart = aFrameTime.animFrameBefore;
        while (aPlaceHolderFrameStart > frameStart && aTrack.transforms[aPlaceHolderFrameStart - 1].text  == aTrack.transforms[aPlaceHolderFrameStart].text)
        {
            aPlaceHolderFrameStart--;
        }
        var aPlaceHolderFrameEnd = aFrameTime.animFrameBefore;
        while (aPlaceHolderFrameEnd < frameStart + frameCount - 1 && aTrack.transforms[aPlaceHolderFrameEnd + 1].text == aTrack.transforms[aPlaceHolderFrameEnd].text)
        {
            aPlaceHolderFrameEnd++;
        }
        var aPlaceHolderFrameCount = aPlaceHolderFrameEnd - aPlaceHolderFrameStart;
        var aPlaceHolderStartTrans = aTrack.transforms[aPlaceHolderFrameStart];
        var aPlaceHolderEndTrans = aTrack.transforms[aPlaceHolderFrameEnd];
        if (animRate == 0.0)
        {
            attachReanim.animRate = 0;
            return;
        }
        var aPlaceHolderDistance = -(aPlaceHolderEndTrans.transX - aPlaceHolderStartTrans.transX);
        var aPlaceHolderSeconds = aPlaceHolderFrameCount / animRate;
        if (aPlaceHolderSeconds == 0.0) 
        {
            attachReanim.animRate = 0;
            return;
        }

        var aGroundTrackIndex = attachReanim.findTrackIndex("_ground");
        var aGroundTrack = attachReanim.definition.tracks[aGroundTrackIndex];
        var aTransformGuyStart = aGroundTrack.transforms[attachReanim.frameStart];
        var aTransformGuyEnd = aGroundTrack.transforms[attachReanim.frameStart + attachReanim.frameCount - 1];
        var aGuyDistance = aTransformGuyEnd.transX - aTransformGuyStart.transX;
        if (aGuyDistance < FlxMath.EPSILON || aPlaceHolderDistance < FlxMath.EPSILON)
        {
            attachReanim.animRate = 0;
            return;
        }

        var aLoops = aPlaceHolderDistance / aGuyDistance;
        var aTransformGuyCurrent = new ReanimatorTransform();
        attachReanim.getCurrentTransform(aGroundTrackIndex, aTransformGuyCurrent);
        var aAttachEffect = Attachment.findFirstAttachment(trackInstances[trackIndex].attachment);
        if (aAttachEffect != null)
        {
            var aGuyCurrentDistance = aTransformGuyCurrent.transX - aTransformGuyStart.transX;
            var aGuyExpectedDistance = aGuyDistance * attachReanim.animTime;
            aAttachEffect.offset.tx = aGuyExpectedDistance - aGuyCurrentDistance;
        }
        attachReanim.animRate = aLoops * attachReanim.frameCount / aPlaceHolderSeconds;
    }

    public function updateAttacherTrack(trackIndex:Int, elapsed:Float)
    {
        var aTrackInstance = trackInstances[trackIndex];
        var aTransform = new ReanimatorTransform();
        getCurrentTransform(trackIndex, aTransform);
        var aAttacherInfo = new AttacherInfo();
        parseAttacherTrack(aTransform, aAttacherInfo);

        var aReanimType = ReanimationType.NONE;
        if (aAttacherInfo.reanimName != "")
        {
            for (param in reanimationParamArray)
            {
                if (param.reanimFileName.toLowerCase() == aAttacherInfo.reanimName.toLowerCase())
                {
                    aReanimType = param.reanimationType;
                    break;
                }
            }
        }
        if (aReanimType == ReanimationType.NONE)
        {
            Attachment.attachmentDie(aTrackInstance.attachment);
            return;
        }

        var aAttachReanim = Attachment.findReanimAttachment(aTrackInstance.attachment);
        if (aAttachReanim == null || aAttachReanim.reanimationType != aReanimType)
        {
            Attachment.attachmentDie(aTrackInstance.attachment);
            aAttachReanim = Main.effectSystem.reanimtionHolder.allocReanimation(0, 0, 0, aReanimType);
            aAttachReanim.loopType = aAttacherInfo.loopType;
            aAttachReanim.animRate = aAttacherInfo.animRate;
            Attachment.attachReanim(aTrackInstance.attachment, aAttachReanim, 0, 0);
            frameBasePose = NO_BASE_POSE;
        }

        if (aAttacherInfo.trackName != "")
        {
            var aAnimFrameStart:IntRef = new IntRef(0);
            var aAnimFrameCount:IntRef = new IntRef(0);
            aAttachReanim.getFramesForLayer(aAttacherInfo.trackName, aAnimFrameStart, aAnimFrameCount);
            if (aAttachReanim.frameStart != aAnimFrameStart.value || aAttachReanim.frameCount != aAnimFrameCount.value)
            {
                aAttachReanim.startBlend(20);
                aAttachReanim.setFramesForLayer(aAttacherInfo.trackName);
            }

            if (aAttachReanim.animRate == 12.0 && aAttacherInfo.trackName == "anim_walk" && aAttachReanim.trackExists("ground"))
            {
                attacherSynchWalkSpeed(trackIndex, aAttachReanim, aAttacherInfo);
            }
            else 
            {
                aAttachReanim.animRate = aAttacherInfo.animRate;
            }
            aAttachReanim.loopType = aAttacherInfo.loopType;
        }

        var aColor = FlxColor.multiply(colorOverride, aTrackInstance.trackColor);
        aColor.alpha = Std.int(FlxMath.bound(Math.round(aTransform.alpha * aColor.alpha), 0, 255));
        Attachment.attachmentPropogateColor(aTrackInstance.attachment, aColor, enableExtraAdditiveColor, extraAdditiveColor, enableExtraOverlayColor, extraOverlayColor);
    }

    public function getTrackInstanceByName(trackName:String)
    {
        return trackInstances[findTrackIndex(trackName)];
    }

    public function attachToAnotherReanimation(attachReanim:Reanimation, trackName:String)
    {
        if (attachReanim.definition.tracks.length <= 0)
        {
            return;
        }

        if (attachReanim.frameBasePose == -1)
        {
            attachReanim.frameBasePose = attachReanim.frameStart;
        }
        
        var trackInstance = attachReanim.getTrackInstanceByName(trackName);
        var result = Attachment.attachReanim(trackInstance.attachment, this, 0, 0);
        trackInstance.attachment = result.attachment;
    }

    public function assignRenderGroupToPrefix(trackName:String, renderGroup:Int)
    {
        for (i in 0...definition.tracks.length)
        {
            var aTrackName = definition.tracks[i].name;
            if (aTrackName.length >= trackName.length &&
                aTrackName.substr(0, trackName.length).toLowerCase() == trackName.toLowerCase())
            {
                trackInstances[i].renderGroup = renderGroup;
            }
        }
    }

    public function isTrackShowing(trackName:String):Bool
    {
        var frameTime = new ReanimatorFrameTime();
        getFrameTime(frameTime);
        var trackIndex = findTrackIndex(trackName);
        var track = definition.tracks[trackIndex];
        return track.transforms[frameTime.animFrameAfter].frame >= 0.0;
    }

    public function showOnlyTrack(trackName:String):Void
    {
        for (i in 0...definition.tracks.length)
        {
            var aTrackName = definition.tracks[i].name;
            if (aTrackName.toLowerCase() == trackName.toLowerCase())
            {
                trackInstances[i].renderGroup = RenderGroup.NORMAL;
            }
            else
            {
                trackInstances[i].renderGroup = RenderGroup.HIDDEN;
            }
        }
    } 

    public function assignRenderGroupToTrack(trackName:String, renderGroup:Int):Void
    {
        for (i in 0...definition.tracks.length)
        {
            if (definition.tracks[i].name.toLowerCase() == trackName.toLowerCase())
            {
                trackInstances[i].renderGroup = renderGroup;
                return;
            }
        }
    }

    public function getTrackVelocity(trackName:String, elapsed:Float)
    {
        var aFrameTime = new ReanimatorFrameTime();
        getFrameTime(aFrameTime);
        var aTrackIndex = findTrackIndex(trackName);

        var aTrack = definition.tracks[aTrackIndex];
        var aDis = aTrack.transforms[aFrameTime.animFrameAfter].transX - aTrack.transforms[aFrameTime.animFrameBefore].transX;
        return aDis * elapsed * animRate;
    }
}