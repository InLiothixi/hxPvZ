package lawn.widget;

import flixel.FlxG;
import flixel.FlxState;
import flixel.math.FlxMath;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import lawn.system.Music;
import lawn.system.music.MusicTune;
import lawn.widget.titlescreen.TitleState;
import sexyappbase.BassMusicInterface;
import sexyappbase.Graphics;
import todlib.Reanimation;
import todlib.TodCommon;
import todlib.todcommon.TodCurves;

class TitleScreen extends FlxState 
{
    var curBarWidth:Float;
    var totalBarWidth:Float;
    var barVel:Float;
    var barStartProgress:Float;
    var loadingThreadComplete:Bool;
    var titleAge:Float;
    var quickLoadKey:String;
    var drawnYet:Bool;
    var needToInit:Bool;
    var displayPartnerLogo:Bool;
    var prevLoadingPercent:Float;
    var titleState:TitleState;
    var titleStateCounter:Float;
    var titleStateDuration:Float;
    var loaderScreenIsLoaded:Bool;

    override function create() 
    {
        super.create();
        
        persistentUpdate = true;
        persistentDraw = true;

        curBarWidth = 0;
        totalBarWidth = 314;
        barVel = 0.2;
        barStartProgress = 0;
        prevLoadingPercent = 0;
        titleAge = 0;
        loadingThreadComplete = false;
        drawnYet = false;
        needToInit = true;
        displayPartnerLogo = true;
        quickLoadKey = String.fromCharCode(0);
        titleState = TitleState.WAITING_FOR_FIRST_DRAW;
        titleStateDuration = 0;
        titleStateCounter = 0;
        loaderScreenIsLoaded = true;
    }

    override function draw() 
    {
        super.draw();

        var g = new Graphics(FlxG.camera);
        g.smoothing = true;

        if (titleState == TitleState.WAITING_FOR_FIRST_DRAW)
        {
            g.setColor(FlxColor.BLACK);
            g.fillRect(FlxRect.get(0, 0, FlxG.width, FlxG.height));

            if (!drawnYet)
            {
                drawnYet = true;
            }

            return;
        }

        if (titleState == TitleState.POPCAP_LOGO)
        {
            g.setColor(FlxColor.BLACK);
            g.fillRect(FlxRect.get(0, 0, FlxG.width, FlxG.height));

            var anAlpha:Float = 1;

            if (titleStateCounter < titleStateDuration - 0.5)
            {
                if (!displayPartnerLogo)
                {
                    anAlpha = TodCommon.todAnimateCurve(0.5, 0, titleStateCounter, 1, 0, TodCurves.LINEAR);
                }
            }
            else 
            {
                anAlpha = TodCommon.todAnimateCurve(titleStateDuration, titleStateDuration - 0.5, titleStateCounter, 0, 1, TodCurves.LINEAR);
            }

            var aColor = FlxColor.WHITE;
            aColor.alphaFloat = anAlpha;
            
            g.setColor(aColor);
            var logo = Resources.IMAGE_POPCAP_LOGO;
            g.translate((FlxG.width - logo.bmp.width) / 2, (FlxG.height - logo.bmp.height) / 2);
            g.drawImage(logo.bmp);
        
            return;
        }

        if (titleState == TitleState.PARTNER_LOGO)
        {
            g.setColor(FlxColor.BLACK);
            g.fillRect(FlxRect.get(0, 0, FlxG.width, FlxG.height));

            var anAlpha:Float = 1;

            if (titleStateCounter >= titleStateDuration - 0.35)
            {
                anAlpha = TodCommon.todAnimateCurve(titleStateDuration, titleStateDuration - 0.35, titleStateCounter, 0, 1, TodCurves.LINEAR);
                var aColor = FlxColor.WHITE;
                aColor.alphaFloat = 1 - anAlpha;

                g.pushState();
                g.setColor(aColor);
                var logo = Resources.IMAGE_POPCAP_LOGO;
                g.translate((FlxG.width - logo.bmp.width) / 2, (FlxG.height - logo.bmp.height) / 2);
                g.drawImage(logo.bmp);
                g.popState();
            }
            else 
            {
                anAlpha = TodCommon.todAnimateCurve(0.35, 0, titleStateCounter, 1, 0, TodCurves.LINEAR);
            }

            var aColor = FlxColor.WHITE;
            aColor.alphaFloat = anAlpha;
            
            g.setColor(aColor);
            var logo = Resources.IMAGE_PARTNER_LOGO;
            g.translate((FlxG.width - logo.bmp.width) / 2, (FlxG.height - logo.bmp.height) / 2);
            g.drawImage(logo.bmp);
        
            return;
        }

        if (!loaderScreenIsLoaded)
        {
            g.setColor(FlxColor.BLACK);
            g.fillRect(FlxRect.get(0, 0, FlxG.width, FlxG.height));
            return;
        }

        {
            g.pushState();
            var logo = Resources.IMAGE_TITLESCREEN;
            g.drawImage(logo.bmp);
            g.popState();
        }

        if (needToInit)
        {
            return;
        }

        var aLogoY:Float = 0;

        if (titleStateCounter > 0.6)
        {
            aLogoY = TodCommon.todAnimateCurve(1, 0.6, titleStateCounter, -150, 10, TodCurves.EASE_IN);
        }
        else 
        {
            aLogoY = TodCommon.todAnimateCurve(0.6, 0.5, titleStateCounter, 10, 15, TodCurves.BOUNCE);
        }

        {
            g.pushState();
            var logo = Resources.IMAGE_PVZ_LOGO;
            g.translate((FlxG.width - logo.bmp.width) / 2, aLogoY);
            g.drawImage(logo.bmp);
            g.popState();
        }

        {
            g.font = Resources.FONT_BRIANNETOD16;
            g.drawString("Loading " + Math.floor(Main.getLoadingThreadProgress() * 100) + "%", 350, 529);
        }
    }

    override function update(elapsed:Float) 
    {
        super.update(elapsed);

        if (!drawnYet)
        {
            return;
        }

        if (titleState == TitleState.WAITING_FOR_FIRST_DRAW)
        {
            Main.music.musicTitleScreenInit();

            titleState = TitleState.POPCAP_LOGO;

            if (displayPartnerLogo)
            {
                titleStateDuration = 1.5;
            }
            else
            {
                titleStateDuration = 2;
            }

            titleStateCounter = titleStateDuration;
        }

        if (quickLoadKey != String.fromCharCode(0) && titleState != TitleState.SCREEN)
        {
            titleState = TitleState.SCREEN;
            titleStateDuration = 0;
            titleStateCounter = 100;
        }

        titleAge += elapsed;
        if (titleStateCounter > 0)
        {
            titleStateCounter -= elapsed;
        }

        if (titleStateCounter < 0)
        {
            titleStateCounter = 0;
        }

        if (titleState == TitleState.POPCAP_LOGO)
        {
            if (Math.ceil(titleStateCounter) == 0)
            {
                if (displayPartnerLogo)
                {
                    titleState = TitleState.PARTNER_LOGO;
                    titleStateDuration = 2;
                    titleStateCounter = 2;
                }
                else 
                {
                    titleState = TitleState.SCREEN;
                    titleStateDuration = 1;
                    titleStateCounter = 1;
                }
            }

            return;
        }
        else if (titleState == TitleState.PARTNER_LOGO)
        {
            if (Math.ceil(titleStateCounter) == 0)
            {
                titleState = TitleState.SCREEN;
                titleStateDuration = 1;
                titleStateCounter = 1;
            }

            return;
        }

        if (!loaderScreenIsLoaded)
        {
            return;
        }

        if (needToInit)
        {
            needToInit = false;
        }

        if (Math.ceil(titleStateCounter) == 0)
        {
            if (!Main.loadingThreadStarted) Main.startLoadingThread();

            if (Main.loadingThreadCompleted)
            {
                FlxG.switchState(Board.new);
            }
        }
    }
    
}