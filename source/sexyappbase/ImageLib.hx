package sexyappbase;

import openfl.display.BitmapData;
import openfl.display.BitmapDataChannel;
import openfl.geom.Point;
import openfl.utils.AssetType;
import openfl.utils.Assets;
import sexyappbase.Image;

using StringTools;

class ImageLib
{
    public static var alphaComposeColor = 0xFFFFFF;
    public static var autoLoadAlpha = true;

    public static function getImagePath(id:String) : String
    {
        id = id.toLowerCase();

        var imgList = Assets.list(AssetType.IMAGE);

        for (path in imgList)
        {
            var file = path.split("/").pop();
            var nameOnly = file.substr(0, file.lastIndexOf("."));
            if (nameOnly.toLowerCase() == id)
            {
                return path;
            }
        }

        return null;
    }

    public static function getImage(fileName:String, lookForAlphaImage:Bool = true)
    {
        var path = getImagePath(fileName);
        if (Assets.cache.hasBitmapData(path))
        {
            var img = new Image(Assets.getBitmapData(path));
            img.hasTrans = path.endsWith('.png');
            return img;
        }

        if (!autoLoadAlpha)
        {
            lookForAlphaImage = false;
        }

        var img = new Image(Assets.getBitmapData(path));
        img.hasTrans = path.endsWith('.png');
        var anImage:Image = img;
        var anAlphaImage:Image = null;

        if (lookForAlphaImage)
        {
            var curFile = getImagePath("_" + fileName);
            if (curFile != null && Assets.exists(curFile))
            {
                var curImg = new Image(Assets.getBitmapData(curFile));
                anAlphaImage = curImg;
            }

            if (anAlphaImage == null)
            {
                curFile = getImagePath(fileName + "_");
                if (Assets.exists(curFile))
                {
                    var curImg = new Image(Assets.getBitmapData(curFile));
                    anAlphaImage = curImg;
                }
            }
        }

        if (anAlphaImage != null)
        {
            if (anImage != null)
            {
                if (anImage.bmp.width == anAlphaImage.bmp.width &&
                    anImage.bmp.height == anAlphaImage.bmp.height)
                {
                    anImage.bmp.lock();
                    for (y in 0...anImage.bmp.height)
                    {
                        for (x in 0...anImage.bmp.width)
                        {
                            var res = (anImage.bmp.getPixel32(x, y) & 0x00FFFFFF) | ((anAlphaImage.bmp.getPixel32(x, y) & 0xFF) << 24);
                            anImage.bmp.setPixel32(x, y, res);
                        }
                    }
                    anImage.hasTrans = true;
                    anImage.bmp.unlock();
                }
            }
            else if (alphaComposeColor == 0xFFFFFF)
            {
                anImage = anAlphaImage;
                anImage.bmp.lock();
                for (y in 0...anImage.bmp.height)
                {
                    for (x in 0...anImage.bmp.width)
                    {
                        var res = (0x00FFFFFF) | ((anImage.bmp.getPixel32(x, y) & 0xFF) << 24);
                        anImage.bmp.setPixel32(x, y, res);
                    }
                }
                anImage.hasTrans = true;
                anImage.bmp.unlock();
            }
            else
            {
                anImage = anAlphaImage;
                anImage.bmp.lock();
                for (y in 0...anImage.bmp.height)
                {
                    for (x in 0...anImage.bmp.width)
                    {
                        var res = (alphaComposeColor) | ((anImage.bmp.getPixel32(x, y) & 0xFF) << 24);
                        anImage.bmp.setPixel32(x, y, res);
                    }
                }
                anImage.hasTrans = true;
                anImage.bmp.unlock();
            }
        }

        return anImage;
    }
}