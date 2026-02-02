package lawn.system;

import flixel.FlxG;
import flixel.util.FlxColor;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import sexyappbase.Graphics;
import sexyappbase.ImageLib;

class PoolEffect
{
    public static inline final CAUSTIC_IMAGE_WIDTH:Int = 128;
    public static inline final CAUSTIC_IMAGE_HEIGHT:Int = 64;

    public var mCausticGrayscaleImage:Array<Int>;
    public var mCausticImage:BitmapData;
    public var mPoolCounter:Float;

    public var graphic:Sprite;

    public function new() {}

    public function poolEffectInitialize()
    {
        mCausticImage = new BitmapData(CAUSTIC_IMAGE_WIDTH, CAUSTIC_IMAGE_HEIGHT, true, FlxColor.TRANSPARENT);

        mCausticGrayscaleImage = [];
        var aCausticGrayscaleImage = ImageLib.getImage("pool_caustic_effect").bmp;
        aCausticGrayscaleImage.lock();
        var index = 0;
        for (x in 0...256)
        {
            for (y in 0...256)
            {
                mCausticGrayscaleImage[index] = aCausticGrayscaleImage.getPixel32(x, y);
                index++;
            }
        }
        aCausticGrayscaleImage.unlock();
        mPoolCounter = 0;

        graphic = new Sprite();
    }

    public function poolEffectDispose()
    {
        mCausticImage.dispose();
        mCausticGrayscaleImage.resize(0);
        mCausticGrayscaleImage = null;
    }

    public function bilinearLookupFixedPoint(u:Int, v:Int)
    {
        var timeU = u & 0xFFFF0000;
        var timeV = v & 0xFFFF0000;
        var factorU1 = ((u - timeU) & 0x0000FFFE) + 1;
        var factorV1 = ((v - timeV) & 0x0000FFFE) + 1;
        var factorU0 = 65536 - factorU1;
        var factorV0 = 65536 - factorV1;
        var indexU0 = (timeU >> 16) % 256;
        var indexU1 = ((timeU >> 16) + 1) % 256;
        var indexV0 = (timeV >> 16) % 256;
        var indexV1 = ((timeV >> 16) + 1) % 256;

        return
            ((((factorU0 * factorV1) / 65536) * mCausticGrayscaleImage[indexV1 * 256 + indexU0]) / 65536) +
            ((((factorU1 * factorV1) / 65536) * mCausticGrayscaleImage[indexV1 * 256 + indexU1]) / 65536) +
            ((((factorU0 * factorV0) / 65536) * mCausticGrayscaleImage[indexV0 * 256 + indexU0]) / 65536) +
            ((((factorU1 * factorV0) / 65536) * mCausticGrayscaleImage[indexV0 * 256 + indexU1]) / 65536);
    }

    public function updateWaterEffect(elapsed:Float)
    {
        mCausticImage.lock();
        var idx = 0;
        for (y in 0...CAUSTIC_IMAGE_HEIGHT)
        {
            var timeV1 = (256 - y) << 17;
            var timeV0 = y << 17;

            for (x in 0...CAUSTIC_IMAGE_WIDTH)
            {
                var pix = mCausticImage.getPixel32(x, y);

                var timeU = x << 17;
                var timePool0 = Math.floor(mPoolCounter) << 16;
                var timePool1 = (Math.floor((Math.floor(mPoolCounter) & 65535) + elapsed)) << 16;
                var a1 = Math.floor(bilinearLookupFixedPoint(Math.floor(timeU - timePool1 / 6), Math.floor(timeV1 + timePool0 / 8)));
                var a0 = Math.floor(bilinearLookupFixedPoint(Math.floor(timeU + timePool0 / 10), timeV0));
                var a = Math.floor(((a0 + a1) / 2));
                var alpha:Int;

                if (a >= 160)
                {
                    alpha = 255 - 2 * (a - 160);
                }
                else if (a >= 128)
                {
                    alpha = 5 * (a - 128);
                }
                else 
                {
                    alpha = 0;
                }

                pix = (pix & 0x00FFFFFF) + (Math.floor(alpha / 3) << 24);
                mCausticImage.setPixel32(x, y, pix);
                idx++;
            }
        }
        mCausticImage.unlock();
    }

    public function poolEffectDraw(g:Graphics)
    {return;
        var aGridSquareX = Resources.IMAGE_POOL.getWidth() / 15.0;
        var aGridSquareY = Resources.IMAGE_POOL.getHeight() / 5.0;
        var aOffsetArray:Array<Array<Array<Array<Float>>>> = [[[[]]]];

        for (x in 0...16)
        {
            for (y in 0...6)
            {
                aOffsetArray[2][x][y][0] = x / 15.0;
                aOffsetArray[2][x][y][1] = y / 5.0;
                if (x != 0 && x != 15 && y!= 0 && y!=5)
                {
                    var aPoolPhase = mPoolCounter * 2 * Math.PI;
                    var aWaveTime1 = aPoolPhase / 800.0;
                    var aWaveTime2 = aPoolPhase / 150.0;
                    var aWaveTime3 = aPoolPhase / 900.0;
                    var aWaveTime4 = aPoolPhase / 800.0;
                    var aWaveTime5 = aPoolPhase / 110.0;
                    var xPhase = x * 3.0 * 2 * Math.PI / 15.0;
                    var yPhase = y * 3.0 * 2 * Math.PI / 5.0;
    
                    aOffsetArray[0][x][y][0] = Math.sin(yPhase + aWaveTime2) * 0.002 + Math.sin(yPhase + aWaveTime1) * 0.005;
                    aOffsetArray[0][x][y][1] = Math.sin(xPhase + aWaveTime5) * 0.01 + Math.sin(xPhase + aWaveTime3) * 0.015 + Math.sin(xPhase + aWaveTime4) * 0.005;
                    aOffsetArray[1][x][y][0] = Math.sin(yPhase * 0.2 + aWaveTime2) * 0.015 + Math.sin(yPhase * 0.2 + aWaveTime1) * 0.012 ;
                    aOffsetArray[1][x][y][1] = Math.sin(xPhase * 0.2 + aWaveTime5) * 0.005 + Math.sin(xPhase * 0.2 + aWaveTime3) * 0.015 + Math.sin(xPhase * 0.2 + aWaveTime4) * 0.02;
                    aOffsetArray[2][x][y][0] += Math.sin(yPhase + aWaveTime1 * 1.5) * 0.004 + Math.sin(yPhase + aWaveTime2 * 1.5) * 0.005;
                    aOffsetArray[2][x][y][1] += Math.sin(xPhase * 4.0 + aWaveTime5 * 2.5) * 0.005 + Math.sin(xPhase * 2.0 + aWaveTime3 * 2.5) * 0.04 + Math.sin(xPhase * 3.0 + aWaveTime4 * 2.5) * 0.02;
                }
                else 
                {
                    aOffsetArray[0][x][y][0] = 0.0;
                    aOffsetArray[0][x][y][1] = 0.0;
                    aOffsetArray[1][x][y][0] = 0.0;
                    aOffsetArray[1][x][y][1] = 0.0;
                }
            }
        }

        var aIndexOffsetX = [ 0, 0, 1, 0, 1, 1 ];
        var aIndexOffsetY = [ 0, 1, 1, 0, 1, 0 ];
    }

    public function poolEffectUpdate(elapsed:Float)
    {
        mPoolCounter += elapsed;
        updateWaterEffect(elapsed);
    }
}

