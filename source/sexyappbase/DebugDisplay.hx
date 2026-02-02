package sexyappbase;

import cpp.vm.Gc;
import flixel.util.FlxColor;
import flixel.util.FlxStringUtil;
import openfl.display.FPS;
import openfl.display.Memory;
import openfl.display.Sprite;
import openfl.text.AntiAliasType;
import openfl.text.GridFitType;
import openfl.text.TextFormat;
import sexyappbase.debugdisplay.FPSMode;

class DebugDisplay extends Sprite
{
    public var fps:FPS;
    public var mem:Memory;
    public var msCount:Int;
    public var boxWidth:Int;

    public function new(X:Float = 10, Y:Float = 10)
    {
        super();

        this.x = X;
        this.y = Y;

        fps = new FPS(2, 0);
        fps.defaultTextFormat = new TextFormat("assets/fonts/tahoma.ttf", 12, FlxColor.WHITE);
        addChild(fps);

        mem = new Memory(2, 0);
        mem.defaultTextFormat = fps.defaultTextFormat;
        mem.visible = false;
        addChild(mem);

        msCount = 0;

        boxWidth = 75;

        drawBox();

        fps.addEventListener(openfl.events.Event.ENTER_FRAME, function(_) 
        {
            msCount = (msCount + 1) % 2;
			drawBox();
		});
    }

    public function updateMode()
    {
        fps.visible = false; 
        mem.visible = false;
        boxWidth = 125;

        if (Main.fpsMode == FPSMode.SHOW_FPS)
        {
            fps.visible = true; 
            boxWidth = 75;
        }
        else if (Main.fpsMode == FPSMode.SHOW_MEMORY)
        {
            mem.visible = true;
        }
    }

    function drawBox()
    {
        graphics.clear();
        graphics.beginFill();
        graphics.drawRect(0, 0, boxWidth, 24);
        graphics.endFill();

        if (Main.fpsMode == FPSMode.SHOW_FPS)
        {
            graphics.beginFill(msCount == 0 ? FlxColor.LIME.rgb: FlxColor.RED.rgb);
            graphics.drawRect(0, 22, 75, 2);
            graphics.endFill();
        }
        
    }
}