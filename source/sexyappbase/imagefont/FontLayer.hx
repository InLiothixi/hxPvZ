package sexyappbase.imagefont;

import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import openfl.display.BitmapData;

class FontLayer extends Font
{
    public var fontData:FontData;
    public var requiredTags:Array<String>;
    public var excludedTags:Array<String>;
    public var charData:Array<CharData>;
    public var colorMult:FlxColor;
    public var colorAdd:FlxColor;
    public var image:BitmapData;
    public var drawMode:Int;
    public var offset:FlxPoint;
    public var spacing:Int;
    public var minPointSize:Int;
    public var maxPointSize:Int;
    public var pointSize:Int;
    public var defaultHeight:Int;
    public var baseOrder:Null<Int>;

    public function new(fontData:FontData) 
    { 
        super();
        ascent = 0;
        ascentPadding = 0;
        height = 0;
        lineSpacingOffset = 0;
        requiredTags = [];
        excludedTags = [];
        charData = [];
        colorMult = FlxColor.WHITE;
        colorAdd = FlxColor.TRANSPARENT;
        drawMode = -1;
        offset = FlxPoint.get();
        spacing = 0;
        minPointSize = -1;
        maxPointSize = -1;
        pointSize = 0;
        defaultHeight = 0;
        baseOrder = null;
    }

    public function fromFontData(fontData:FontData)
    {
        this.fontData = fontData;
    }

    public function fromFontLayer(fontLayer:FontLayer)
    {
        fontData = fontLayer.fontData;
        requiredTags = fontLayer.requiredTags;
        excludedTags = fontLayer.excludedTags;
        image = fontLayer.image;
        drawMode = fontLayer.drawMode;
        offset = fontLayer.offset;
        spacing = fontLayer.spacing;
        minPointSize = fontLayer.minPointSize;
        maxPointSize = fontLayer.maxPointSize;
        pointSize = fontLayer.pointSize;
        ascent = fontLayer.ascent;
        ascentPadding = fontLayer.ascentPadding;
        height = fontLayer.height;
        defaultHeight = fontLayer.defaultHeight;
        colorMult = fontLayer.colorMult;
        colorAdd = fontLayer.colorAdd;
        lineSpacingOffset = fontLayer.lineSpacingOffset;
        baseOrder = fontLayer.baseOrder;

        charData = fontLayer.charData;
    }
    
    public function getCharData(value:String) 
    { 
        return charData[value.charCodeAt(0)]; 
    }
}