import flixel.util.FlxColor;
import openfl.display.BitmapData;
import sexyappbase.Image;
import sexyappbase.ImageFont;
import sexyappbase.ImageLib;

class Resources
{
    public static var IMAGE_BLANK:Image;
    public static var IMAGE_POPCAP_LOGO:Image;
    public static var IMAGE_PARTNER_LOGO:Image;

    public static function extractInitResources()
    {
        IMAGE_BLANK = new Image(new BitmapData(1, 1, true, FlxColor.TRANSPARENT));
        IMAGE_POPCAP_LOGO = ImageLib.getImage("PopCap_Logo");
        IMAGE_PARTNER_LOGO = ImageLib.getImage("Partner_Logo");
    }

    public static var IMAGE_TITLESCREEN:Image;
    public static var IMAGE_LOADBAR_GRASS:Image;
    public static var IMAGE_PVZ_LOGO:Image;
    public static var IMAGE_REANIM_SODROLLCAP:Image;
    public static var FONT_BRIANNETOD16:ImageFont;

    public static function extractLoaderBarResources()
    {
        IMAGE_TITLESCREEN = ImageLib.getImage("titlescreen");
        IMAGE_LOADBAR_GRASS = ImageLib.getImage("LoadBar_grass");
        IMAGE_PVZ_LOGO = ImageLib.getImage("PvZ_Logo");
        IMAGE_REANIM_SODROLLCAP = ImageLib.getImage("sodrollcap");
        FONT_BRIANNETOD16 = new ImageFont();
        FONT_BRIANNETOD16.fromDescriptor("briannetod16");
    }

    public static var IMAGE_POOL:Image;

    public static function extractLoadingImagesResources()
    {
        IMAGE_POOL = ImageLib.getImage("pool");
    }
    
}