package todlib;

import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import openfl.display.BitmapData;
import openfl.geom.Point;
import openfl.utils.Assets;
import sexyappbase.DescParser.IntRef;
import sexyappbase.Image;
import todlib.reanimatlas.ReanimAtlasImage;
import todlib.reanimator.ReanimatorDefinition;

class ReanimAtlas
{
    public var imageArray:Array<ReanimAtlasImage>;
    public var imageCount:Int;
    public var image:BitmapData;

    public function new()
    {
        imageArray = [];
        imageCount = 0;
    }

    public function findImage(image:Image)
    {
        for (atlas in imageArray)
        {
            if (atlas.originalImage == image)
            {
                return imageArray.indexOf(atlas);
            }
        }
        return -1;
    }

    public function getEncodedReanimAtlas(image:Image)
    {
        if (image == null)
            return null;

        for (atlasImage in imageArray) {
            if (atlasImage.originalImage == image)
                return atlasImage;
        }

        return null;
    }

    public function addImage(image:Image)
    {
        var atlas = new ReanimAtlasImage();
        atlas.rect = FlxRect.get();
        atlas.rect.height = image.bmp.height;
        atlas.rect.width = image.bmp.width;
        atlas.originalImage = image;
        imageArray[imageCount++] = atlas;
    }

    public static function getClosestPowerOf2Above(num:Int)
    {
        var power2 = 1;
        while (power2 < num)
        {
            power2 <<= 1;
        }
        return power2;
    }

    public function pickAtlasWidth()
    {
        var totalArea = 0;
        var maxWidth = 0;

        for (image in imageArray)
        {
            totalArea += Std.int(image.rect.width * image.rect.height);
            if (maxWidth <= image.rect.width + 2)
            {
                maxWidth = Std.int(image.rect.width + 2);
            }
        }

        var width = Math.round(Math.sqrt(totalArea));
        return getClosestPowerOf2Above(Std.int(Math.min(Math.max(width, maxWidth), 2048)));
    }

    static function inflate(Rect:FlxRect, X:Float, Y:Float) : FlxRect
    {
        Rect.x -= X;
        Rect.y -= Y;
        Rect.width += X * 2;
        Rect.height += Y * 2;
        return Rect;
    }

    public function imageFits(imageCount:Int, rectTest:FlxRect, maxWidth:Int)
    {
        if (rectTest.right > maxWidth)
        {
            return false;
        }

        for (i in 0...imageCount)
        {
            var atlas = imageArray[i];
            var rect = FlxRect.get();
            rect.copyFrom(atlas.rect);
            if (inflate(rect, 1, 1).overlaps(rectTest))
            {
                return false;
            }
        }

        return true;
    }

    public function imageFindPlaceOnSide(atlasImageToPlace:ReanimAtlasImage, imageCount:Int, maxWidth:Int, toRight:Bool)
    {
        var rectTest = FlxRect.get();
        rectTest.setSize(atlasImageToPlace.rect.width + 2, atlasImageToPlace.rect.height + 2);

        for (i in 0...imageCount)
        {
            var atlas = imageArray[i];
            if (toRight)
            {
                rectTest.setPosition(atlas.rect.right + 1, atlas.rect.y);
            }
            else
            {
                rectTest.setPosition(atlas.rect.x, atlas.rect.bottom + 1);
            }

            if (imageFits(imageCount, rectTest, maxWidth))
            {
                atlasImageToPlace.rect.setPosition(rectTest.x, rectTest.y);
                if (toRight)
                {
                    atlasImageToPlace.rect.x += 1;
                }
                else
                {
                    atlasImageToPlace.rect.y += 1;
                }

                return true;
            }
        }

        return false;
    }

    public function imageFindPlace(atlasImageToPlace:ReanimAtlasImage, imageCount:Int, maxWidth:Int)
    {
        return imageFindPlaceOnSide(atlasImageToPlace, imageCount, maxWidth, true) ||
        imageFindPlaceOnSide(atlasImageToPlace, imageCount, maxWidth, false);
    }

    public function placeAtlasImage(atlasImageToPlace:ReanimAtlasImage, imageCount:Int, maxWidth:Int)
    {
        if (imageCount == 0)
        {
            atlasImageToPlace.rect.setPosition(1, 1);
            return true;
        }

        if (imageFindPlace(atlasImageToPlace, imageCount, maxWidth))
            return true;

        return false;
    }

    public function arrangeImages(atlasWidth:IntRef, atlasHeight:IntRef)
    {
        imageArray.sort(function(a, b) {
            if (a.rect.height != b.rect.height)
            {
                return Reflect.compare(b.rect.height, a.rect.height);
            }
            else if (a.rect.width != b.rect.width)
            {
                return Reflect.compare(b.rect.width, a.rect.width);
            }
            else 
            {
                var image1Ptr:Int = untyped __cpp__('(uintptr_t)&{0}', a);
                var image2Ptr:Int = untyped __cpp__('(uintptr_t)&{0}', b);

                return (image1Ptr > image2Ptr) ? 1 : 0;
            }
        });

        atlasWidth.value = pickAtlasWidth();
        atlasHeight.value = 0;

        for (i in 0...imageArray.length)
        {
            var atlas = imageArray[i];
            placeAtlasImage(atlas, i, atlasWidth.value);

            var imageHeight = getClosestPowerOf2Above(Std.int(atlas.rect.y + atlas.rect.height));
            atlasHeight.value = Std.int(Math.max(imageHeight, atlasHeight.value));
        }
    }

    public function reanimAtlasMakeBlankImage(width:Int, height:Int)
    {
        var image = FlxG.bitmap.add(new BitmapData(width, height, true, FlxColor.TRANSPARENT), false, FlxG.bitmap.getUniqueKey("reanimatlas_reanimAtlasMakeBlankImage"));
        return image.bitmap;
    }

    public function reanimAtlasCreate(reanimDef:ReanimatorDefinition)
    {
        for (track in reanimDef.tracks)
        {
            for (transform in track.transforms)
            {
                var image = transform.image;
                if (image != null && image.bmp != null && image.bmp.width <= 254 && image.bmp.height <= 254 && findImage(image) < 0)
                {
                    if (!image.hasTrans)
                        image.trySanding();
                    addImage(image);
                }
            }
        }

        var atlasWidth = new IntRef(0);
        var atlasHeight = new IntRef(0);

        arrangeImages(atlasWidth, atlasHeight);

        for (track in reanimDef.tracks)
        {
            for (transform in track.transforms)
            {
                var img = transform.image;
                if (image != null && image.width <= 254 && image.height <= 254)
                {
                    var imageIndex = findImage(img);
                    img = imageArray[imageIndex].originalImage;
                }
            }
        }

        image = reanimAtlasMakeBlankImage(atlasWidth.value, atlasHeight.value);
        image.lock();
        for (atlas in imageArray)
        {
            var img = atlas.originalImage;
            var point = FlxPoint.get(atlas.rect.x, atlas.rect.y);
            if (atlas.originalImage.checkIsSanded())
            {
                point.x -=1;
                point.y -=1;
            }
            image.copyPixels(img.bmp, img.bmp.rect, point.copyToFlash());
        }
        image.unlock();
    }
}