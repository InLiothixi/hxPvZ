package todlib;

import flixel.math.FlxMatrix;
import flixel.tweens.FlxEase;
import openfl.display.BitmapData;
import sexyappbase.DescParser.IntRef;
import todlib.todcommon.TodCurves;


class TodCommon 
{
    public static inline function modF(a:Float, b:Float):Float {
        return a - b * Math.floor(a / b);
    }

    public static function todCurveEvaluate(Time:Float, PositionStart:Float, PositionEnd:Float, Curve:TodCurves) : Float
    {
        var warpedTime:Float = 0.0;
        switch (Curve)
        {
            case TodCurves.CONSTANT:				    warpedTime = 0.0;													
            case TodCurves.LINEAR:				        warpedTime = Time;												
            case TodCurves.EASE_IN:				        warpedTime = FlxEase.quadIn(Time);								
            case TodCurves.EASE_OUT:				    warpedTime = FlxEase.quadOut(Time);								
            case TodCurves.EASE_IN_OUT:			        warpedTime = FlxEase.smootherStepInOut(FlxEase.smootherStepInOut(Time));						
            case TodCurves.EASE_IN_OUT_WEAK:		    warpedTime = FlxEase.smootherStepInOut(Time);									
            case TodCurves.FAST_IN_OUT:			        warpedTime = FlxEase.quadInOut(FlxEase.quadInOut(Time));			
            case TodCurves.FAST_IN_OUT_WEAK:		    warpedTime = FlxEase.quadInOut(Time);							
            case TodCurves.BOUNCE:				        warpedTime = bounce(Time);								
            case TodCurves.BOUNCE_FAST_MIDDLE:	        warpedTime = FlxEase.quadIn(bounce(Time));				
            case TodCurves.BOUNCE_SLOW_MIDDLE:	        warpedTime = FlxEase.quadOut(bounce(Time));				
            case TodCurves.SIN_WAVE:				    warpedTime = Math.sin(2 * Math.PI * Time);						
            case TodCurves.EASE_SIN_WAVE:		        warpedTime = Math.sin(2 * Math.PI * FlxEase.smootherStepInOut(Time));
            default:                                    warpedTime = 0.0;					
        }

        return (PositionEnd - PositionStart) * warpedTime + PositionStart;
    }

    public static inline function bounce(Time:Float) : Float
    {
        return 1 - Math.abs(2 * Time  - 1);
    }

    public static function todCurveEvaluateClamped(Time:Float, PositionStart:Float, PositionEnd:Float, Curve:TodCurves) : Float
    {
        if (Time <= 0.0) return PositionStart;
        else if (Time >= 1.0)
        {
            if (Curve == TodCurves.BOUNCE  || Curve == TodCurves.BOUNCE_FAST_MIDDLE || 
                Curve == TodCurves.BOUNCE_SLOW_MIDDLE || Curve == TodCurves.SIN_WAVE || 
                Curve == TodCurves.EASE_SIN_WAVE)
                return PositionStart;
            else
                return PositionEnd;
        }

        return todCurveEvaluate(Time, PositionStart, PositionEnd, Curve);
    }

    public static function todAnimateCurve(TimeStart:Float, TimeEnd:Float, TimeAge:Float, PositionStart:Float, PositionEnd:Float, Curve:TodCurves) : Float 
    {
        final warpedAge = (TimeAge - TimeStart) / (TimeEnd - TimeStart);
        return todCurveEvaluateClamped(warpedAge, PositionStart, PositionEnd, Curve);
    }

    static function averageNearByPixels(image:BitmapData, x:Int, y:Int)
    {
        var red = 0;
        var green = 0;
        var blue = 0;
        var bitsCount = 0;

        for (i in -1...2)
        {
            if (i == 0)
            {
                continue;
            }

            for (j in -1...2)
            {
                if ((x != 1 || j != -1) && (x != image.width || j != 2) && 
                    (y != 1 || i != -1) && (y != image.height || i != 2))
                {
                    var aPixel = image.getPixel32(x + j, y + i);
                    if ((aPixel & 0xFF000000) != 0)
                    {
                        red += (aPixel >> 16) & 0xFF;
                        green += (aPixel >> 8) & 0xFF;
                        blue += aPixel & 0xFF;
                        bitsCount += 1;
                    }
                }
            }
        }

        if (bitsCount == 0)
        {
            return 0;
        }

        red = Math.ceil(Math.min(red / bitsCount, 255));
        green = Math.ceil(Math.min(green / bitsCount, 255));
        blue = Math.ceil(Math.min(blue / bitsCount, 255));
        return  (0xFF << 24) | (red << 16) | (green << 8) | (blue);
    }

    public static function fixPixelsOnAlphaEdgeForBlending(image:BitmapData)
    {
        var original = image.clone();
        original.lock();
        image.lock();
        for (y in 0...image.height)
        {
            for (x in 0...image.width)
            {
                if ((original.getPixel32(x, y) & 0xFF000000) == 0)
                {
                    image.setPixel32(x, y, averageNearByPixels(original, x, y)); 
                }
            }
        }
        image.unlock();
        original.unlock();
        original.dispose();
    }

    // IntRef (value) cuz Primatives are immutable

    public static inline function setBit(theNum:IntRef, theIdx:Int, theValue:Bool = true)
    {
        if (theValue)
        {
            theNum.value |= 1 << theIdx;
        }
        else 
        {
            theNum.value &= ~(1 << theIdx);
        }
    }

    public static inline function testBit(theNum:IntRef, theIdx:Int)
    {
        return theNum.value & (1 << theIdx) != 0;
    }

    public static function sexyMatrix3Multiply(m:FlxMatrix, l:FlxMatrix, r:FlxMatrix)
    {
        var temp = new FlxMatrix();
        temp.a = l.a * r.a + l.c * r.b;
        temp.c = l.a * r.c + l.c * r.d;
        temp.tx = l.a * r.tx + l.c * r.ty + l.tx;
        temp.b = l.b * r.a + l.d * r.b;
        temp.d = l.b * r.c + l.d * r.d;
        temp.ty = l.b * r.tx + l.d * r.ty + l.ty;
        m.copyFrom(temp);
    }

    public static function sexyMatrix3Inverse(m:FlxMatrix, r:FlxMatrix)
    {
        var det = m.d * m.a - m.b * m.c;
        var invDet = 1.0 / det;
    
        r.a =  m.d * invDet;
        r.c =  (-m.c) * invDet;
        r.tx = (m.ty * m.c - m.tx * m.d) * invDet;
        r.b = (-m.b) * invDet;
        r.d = m.a * invDet;
        r.ty = (m.tx * m.b - m.ty * m.a) * invDet;
    }
        

    public static function todScaleRotateTransformMatrix(m:FlxMatrix, x:Float, y:Float, rad:Float, scaleX:Float, scaleY:Float)
    {
        m.a = Math.cos(rad) * scaleX;
        m.b = -Math.sin(rad) * scaleX;
        m.c = Math.sin(rad) * scaleY;
        m.d = Math.cos(rad) * scaleY;
        m.tx = x;
        m.ty = y;
    }
}
