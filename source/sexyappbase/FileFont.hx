package sexyappbase;

import flixel.FlxCamera;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class FileFont extends Font
{ 
    public var text:FlxText;

    override public function new()
    {
        super();
        text = new FlxText();
        text.text = "";
    }

    public function fromFontFile(fileName:String)
    {
        text.font = fileName;
    }

    override public function stringWidth(str:String)
    {
        return Std.int(text.width);
    }

    override public function drawString(g:Graphics, x:Float, y:Float, str:String, color:FlxColor, clipRect:FlxRect)
    {
        text.setPosition(x, y);
        text.text = str;
        text.color = color;
        text.cameras = [g.camera];
        text.clipRect = clipRect;

        if (text.text != str) 
            @:privateAccess text.regenGraphic();

        @:privateAccess text.drawSimple(g.camera);
    }
}