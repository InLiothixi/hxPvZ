package todlib;

import flixel.math.FlxMath;
import openfl.display.BitmapData;
import sexyappbase.DescParser.DoubleRef;
import todlib.filtereffect.FilterEffectType;

class FilterEffect
{
    public static var imageMap:Array<Map<BitmapData, BitmapData>> = [
        for (filter in 0...FilterEffectType.NUM_FILTER_EFFECTS)
            new Map<BitmapData, BitmapData>()
    ];

    public static function filterEffectInitForApp(){}
    
    public static function rgb_to_hsl(r:DoubleRef, g:DoubleRef, b:DoubleRef, h:DoubleRef, s:DoubleRef, l:DoubleRef)
    {
        var maxval = Math.max(r.value, g.value);
        maxval = Math.max(maxval, b.value);
        var minval = Math.min(r.value, g.value);
        minval = Math.min(minval, b.value);

        l.value = (minval + maxval) / 2;
        if (l.value <= 0)
        {
            return;
        }

        var delta = maxval - minval;
        s.value = delta;

        if (s.value <= 0)
        {
            return;
        }

        s.value /= ((l.value <= 0.5) ? (minval + maxval) : (2 - minval - maxval));

        var r2 = (maxval - r.value) / delta;
        var g2 = (maxval - g.value) / delta;
        var b2 = (maxval - b.value) / delta;

        if (maxval == r.value)
        {
            h.value = ((g.value == minval) ? (5 + b2) : (1 - g2));
        }
        else if (maxval == g.value)
        {
            h.value = ((b.value == minval) ? (1 + r2) : (3 - b2));
        }
        else 
        {
            h.value = ((r.value == minval) ? (3 + g2) : (5 - r2));
        }

        h.value /= 6;
    }

    public static function hsl_to_rgb(h:DoubleRef, sl:DoubleRef, l:DoubleRef, r:DoubleRef, g:DoubleRef, b:DoubleRef)
    {
        var v = (l.value <= 0.5) ? (l.value * (1 + sl.value)) : (l.value + sl.value - l.value * sl.value);
        if (v <= 0)
        {
            r.value = 0;
            g.value = 0;
            b.value = 0;
            return;
        }

        var y = 2 * l.value - v;
        var sv = (v - y) / v;
        h.value *= 6;
        var sextant = Std.int(FlxMath.bound(h.value, 0, 5));
        var vsf = v * sv * (h.value - sextant);
        var x = y + vsf;
        var z = v - vsf;

        switch (sextant)
        {
            case 0:	r.value = v;	g.value = x;	b.value = y;
            case 1:	r.value = z;	g.value = v;	b.value = y;
            case 2:	r.value = y;	g.value = v;	b.value = x;
            case 3:	r.value = y;	g.value = z;	b.value = v;
            case 4:	r.value = x;	g.value = y;	b.value = v;
            case 5:	r.value = v;	g.value = y;	b.value = z;
        }
    }

    public static function filterEffectDoLumSat(image:BitmapData, lum:Float, sat:Float)
    {
        image.lock();
        for (y in 0...image.height)
        {
            for (x in 0...image.width)
            {
                var px = image.getPixel32(x, y);
                var a = (px >> 24) & 0xFF;
                var r = new DoubleRef(((px >> 16) & 0xFF) / 0xFF);
                var g = new DoubleRef(((px >> 8) & 0xFF) / 0xFF);
                var b = new DoubleRef((px & 0xFF) / 0xFF);

                var h = new DoubleRef(0);
                var s = new DoubleRef(0);
                var l = new DoubleRef(0);

                rgb_to_hsl(r, g, b, h, s, l);
                s.value *= sat;
                l.value *= lum;
                hsl_to_rgb(h, s, l, r, g, b);

                image.setPixel32(x, y, 
                    (a << 24) |
                    (Std.int(FlxMath.bound(r.value * 255, 0, 255)) << 16) |
                    (Std.int(FlxMath.bound(g.value * 255, 0, 255)) << 8) |
                    (Std.int(FlxMath.bound(b.value * 255, 0, 255)))
                );

            }
        }
        image.unlock();
    }

    public static function filterEffectDoWhite(image:BitmapData)
    {
        image.lock();
        for (y in 0...image.height)
        {
            for (x in 0...image.width)
            {
                var px = image.getPixel32(x, y);
                image.setPixel32(x, y, px | 0x00FFFFFF);
            }
        }
        image.unlock();
    }

    public static function filterEffectDoWashedOut(image:BitmapData)
    {
        filterEffectDoLumSat(image, 1.8, 0.2);
    }

    public static function filterEffectDoLessWashedOut(image:BitmapData)
    {
        filterEffectDoLumSat(image, 1.2, 0.3);
    }

    public static function filterEffectCreateImage(image:BitmapData, filterEffect:FilterEffectType)
    {
        var filteredImage = image.clone();
        switch (filterEffect)
        {
            case FilterEffectType.LESS_WASHED_OUT:  filterEffectDoLessWashedOut(filteredImage);
            case FilterEffectType.WASHED_OUT:       filterEffectDoWashedOut(filteredImage);
            case FilterEffectType.WHITE:            filterEffectDoWhite(filteredImage);
            default:
        }
        return filteredImage;
    }

    public static function filterEffectGetImage(image:BitmapData, filterEffect:FilterEffectType) : BitmapData
    {
        var filterMap = imageMap[filterEffect];
        if (filterMap.exists(image))
        {
            return filterMap.get(image);
        }
        var filteredImage = filterEffectCreateImage(image, filterEffect);
        filterMap.set(image, filteredImage);
        return filteredImage;
    }
}
