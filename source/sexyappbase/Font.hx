package sexyappbase;

import flixel.FlxCamera;
import flixel.math.FlxRect;
import flixel.util.FlxColor;

class Font 
{
    public var ascent:Int;
    public var ascentPadding:Int;
    public var height:Int;
    public var lineSpacingOffset:Int;

    public function new() 
    {
        ascent = 0;
        ascentPadding = 0;
        height = 0;
        lineSpacingOffset = 0;
    }

    public function getLineSpacing()
    {
        return height + lineSpacingOffset;
    }

    public function stringWidth(str:String)
    {
        return  0;
    }

    public function charWidth(char:String)
    {
        return stringWidth(char.charAt(0));
    }

    public function charWidthKern(char:String, prevChar:String)
    {
        return charWidth(char.charAt(0));
    }

    public function drawString(g:Graphics, x:Float, y:Float, str:String, color:FlxColor, clipRect:FlxRect) {}
}