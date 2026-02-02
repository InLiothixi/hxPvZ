package sexyappbase;

import flixel.math.FlxRect;
import flixel.util.FlxColor;
import openfl.display.BitmapData;
import openfl.geom.Point;
import todlib.TodCommon;

class Image
{
    public static var sandedBitmapDatas:Array<BitmapData> = [];
    
    public var bmp:BitmapData;
    public var hasTrans:Bool;
    public var isSanded:Bool;
    public var numRows:Int;
    public var numCols:Int;

    public function new(data:BitmapData, rows:Int = 1, cols:Int = 1) 
    {
        bmp = data;
        hasTrans = true;
        isSanded = false;
        numRows = rows;
        numCols = cols;
    }

    public function getCelWidth()
    {
        return Math.floor(getWidth() / numCols);
    }

    public function getCelHeight()
    {
        return Math.floor(getHeight() / numRows);
    }

    public function getWidth()
    {
        return bmp.width;
    }

    public function getHeight()
    {
        return bmp.height;
    }
        

    public function getCelRect(col:Int, row:Int)
    {
        var h = getCelHeight();
        var w = getCelWidth();
        var x = col * w;
        var y = col * h;
        return FlxRect.get(x, y, w, h);
    }

    public function checkIsSanded() 
    {
        if (isSanded) 
        {
            return true; 
        }
        else if (sandedBitmapDatas.contains(bmp))
        {
            isSanded = true;
            return true;
        }
        
        return false;
    }

    public function trySanding()
    {
        if (checkIsSanded())
        {
            return;
        }

        isSanded = true;
        var buffer = new BitmapData(bmp.width + 2, bmp.height + 2, true, FlxColor.TRANSPARENT);
        buffer.copyPixels(bmp, bmp.rect, new Point(1,1));
        TodCommon.fixPixelsOnAlphaEdgeForBlending(buffer);
        bmp = buffer;
        sandedBitmapDatas.push(bmp);
    }
}