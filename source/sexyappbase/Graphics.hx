package sexyappbase;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxImageFrame;
import flixel.math.FlxMatrix;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxAssets.FlxShader;
import flixel.util.FlxColor;
import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.geom.ColorTransform;
import openfl.geom.Point;

class Graphics
{
    public static var graphicList:Array<Graphics> = [];
    
    public var camera:FlxCamera;
    public var trans:FlxPoint;
    public var scroll:FlxPoint;
    public var scrollFactor:FlxPoint;
    public var matrix:FlxMatrix;
    public var scale:FlxPoint;
    public var scaleOrigin:FlxPoint;
    public var isClipping:Bool;
    public var clipRect:FlxRect;
    public var colorizedImages:Bool;
    public var colorTransform:ColorTransform;
    public var blendMode:BlendMode;
    public var smoothing:Bool;
    public var shader:Null<FlxShader>;
    public var font:Dynamic;
    
    public function new(target:FlxCamera) 
    {
        camera = target;
        trans = FlxPoint.get();
        scroll = FlxPoint.get(camera.scroll.x, camera.scroll.y);
        scrollFactor = FlxPoint.get(1, 1);
        matrix = new FlxMatrix();
        matrix.identity();
        scale = FlxPoint.get(1, 1);
        scaleOrigin = FlxPoint.get();
        isClipping = false;
        clipRect = FlxRect.get().copyFrom(camera.getViewMarginRect());
        colorizedImages = false;
        colorTransform = new ColorTransform();
        blendMode = BlendMode.NORMAL;
        smoothing = false;
        shader = null;
        font = null;
    }

    public function copyStateFrom(g:Graphics)
    {
        camera = g.camera;
        trans.copyFrom(g.trans);
        scroll.copyFrom(g.scroll);
        scrollFactor.copyFrom(g.scrollFactor);
        matrix.copyFrom(g.matrix.clone());
        scale.copyFrom(g.scale);
        scaleOrigin.copyFrom(g.scaleOrigin);
        isClipping = g.isClipping;
        clipRect = FlxRect.get().copyFrom(g.clipRect);
        colorizedImages = g.colorizedImages;
        colorTransform = g.colorTransform;
        blendMode = g.blendMode;
        smoothing = g.smoothing;
        shader = g.shader;
        font = g.font;
    }

    public function setColorizedImages(value:Bool)
    {
        colorizedImages = true;
    }

    public function getColorizedImages()
    {
        return colorizedImages;
    }

    public function pushState()
    {
        var g = new Graphics(camera);
        g.copyStateFrom(this);
        graphicList.push(g);
    }

    public function popState() 
    {
        if (graphicList.length > 0)
        {
            copyStateFrom(graphicList.pop());
        }
    }

    public function translate(x:Float = 0, y:Float = 0)
    {
        trans.x += x;
        trans.y += y;
    }

    public function setScale(scaleX:Float, scaleY:Float, origX:Float, origY:Float)
    {
        scale.set(scaleX, scaleY);
        scaleOrigin.set(origX + trans.x, origY + trans.y);
    }

    public function stringWidth(str:String)
    {
        return font.stringWidth(str);
    }

    public function isVisible()
    {
        return colorTransform.alphaMultiplier * 255 + colorTransform.alphaOffset > 0;
    }

    public function drawRect(dest:FlxRect)
    {
        if (!isVisible())
        {
            return;
        }
    
        fillRect(FlxRect.get(dest.x, dest.y, dest.width + 1, 1));
        fillRect(FlxRect.get(dest.x, dest.y + dest.height, dest.width + 1, 1));
        fillRect(FlxRect.get(dest.x, dest.y + 1, 1, dest.height - 1));
        fillRect(FlxRect.get(dest.x + dest.width - 1, dest.y + 1, 1, dest.height - 1));
    }
    
    public function fillRect(dest:FlxRect)
    {
        if (!isVisible())
        {
            return;
        }

        dest.x += scroll.x * scrollFactor.x;
        dest.y += scroll.y * scrollFactor.y;

        if (dest.x < clipRect.left)
        {
            var diff = Math.floor(clipRect.left - dest.x);
            dest.x += diff;
            dest.width -= diff;
        }

        if (dest.x + dest.width > clipRect.right)
        {
            var diff = Math.floor((dest.x + dest.width) - clipRect.right);
            dest.width -= diff;
        }

        if (dest.y < clipRect.top)
        {
            var diff = Math.floor(clipRect.top - dest.y);
            dest.y += diff;
            dest.height -= diff;
        }

        if (dest.y + dest.height > clipRect.bottom)
        {
            var diff = Math.floor((dest.y + dest.height) - clipRect.bottom);
            dest.height -= diff;
        }

        if (dest.width <= 0 || dest.height <= 0) return;
            
        var bmp:FlxGraphic = FlxG.bitmap.create(Std.int(dest.width), Std.int(dest.height), FlxColor.WHITE, 
        false, 'graphic_fillrect(${dest.width}, ${dest.height})');
        camera.copyPixels(bmp.imageFrame.frame, bmp.bitmap, bmp.imageFrame.frame.frame.copyToFlash(), 
        new Point(dest.x, dest.y), colorTransform, blendMode, smoothing, shader);
    }

    public function drawString(str:String, x:Float, y:Float)
    {
        x += scroll.x * scrollFactor.x;
        y += scroll.y * scrollFactor.y;
        font.drawString(this, x, y, str, colorTransform.color, clipRect);
    }

    public function setColor(color:FlxColor) 
    {
        colorTransform.redMultiplier = color.redFloat;
        colorTransform.greenMultiplier = color.greenFloat;
        colorTransform.blueMultiplier = color.blueFloat;
        colorTransform.alphaMultiplier = color.alphaFloat;
    }

    public function getColor()
    {
        return new FlxColor(colorTransform.color);
    }

    public function clip(srcRect:FlxRect, point:FlxPoint)
    {
        // if (point.x < clipRect.left)
        // {
        //     var diff = Math.floor(clipRect.left - point.x);
        //     srcRect.x += diff / scale.x;
        //     srcRect.width -= diff / scale.x;
        //     point.x = clipRect.left;
        // }

        // if (point.x + srcRect.width * scale.x > clipRect.right)
        // {
        //     var diff = Math.floor((point.x + srcRect.width * scale.x) - clipRect.right);
        //     srcRect.width -= diff / scale.x;
        // }

        // if (point.y < clipRect.top)
        // {
        //     var diff = Math.floor(clipRect.top - point.y);
        //     srcRect.y += diff  / scale.y;
        //     srcRect.height -= diff  / scale.y;
        //     point.y = clipRect.top;
        // }

        // if (point.y + srcRect.height * scale.y> clipRect.bottom)
        // {
        //     var diff = Math.floor((point.y + srcRect.height * scale.y) - clipRect.bottom);
        //     srcRect.height -= diff / scale.y;
        // }
    }

    public function drawImage(bmp:BitmapData)
    {
        if (bmp == null)
        {
            return;
        }

        var graphic = FlxGraphic.fromBitmapData(bmp);
        var aMatrix = new FlxMatrix();
        aMatrix.translate(-scaleOrigin.x, -scaleOrigin.y);
        aMatrix.scale(scale.x, scale.y);
        aMatrix.concat(matrix);
        aMatrix.translate(scaleOrigin.x - scroll.x * scrollFactor.x + trans.x, scaleOrigin.y - scroll.y * scrollFactor.y + trans.y);
        camera.drawPixels(graphic.imageFrame.frame, graphic.bitmap, aMatrix, colorTransform, blendMode, smoothing, shader);
    }

    public function drawSourceImage(bmp:BitmapData, srcRect:FlxRect)
    {
        if (bmp == null)
        {
            return;
        }
        
        if (srcRect.width <= 0 || srcRect.height <= 0)
        {
            return;
        }

        var graphic = FlxGraphic.fromBitmapData(bmp);
        var aMatrix = new FlxMatrix();
        aMatrix.translate(-scaleOrigin.x, -scaleOrigin.y);
        aMatrix.scale(scale.x, scale.y);
        aMatrix.concat(matrix);
        aMatrix.translate(scaleOrigin.x - scroll.x * scrollFactor.x + trans.x, scaleOrigin.y - scroll.y * scrollFactor.y + trans.y);
        camera.drawPixels(FlxImageFrame.fromRectangle(graphic, srcRect).frame, graphic.bitmap, aMatrix, colorTransform, blendMode, smoothing, shader);
    }
}