import flixel.math.FlxPoint;

using StringTools;

class XmlTools 
{
    public static function getString(emitter:Xml, name:String, ?defaultValue:String)
    {
        var node = emitter.elementsNamed(name).next();
        return (node != null && node.firstChild() != null)
            ? node.firstChild().nodeValue
            : defaultValue;
    }

    public static function getInt(emitter:Xml, name:String, ?defaultValue:Int = 0)
    {
        var node = emitter.elementsNamed(name).next();
        return (node != null && node.firstChild() != null)
            ? Std.parseInt(node.firstChild().nodeValue)
            : defaultValue;
    }

    public static function getFloat(emitter:Xml, name:String, ?defaultValue:Float = 0)
    {
        var node = emitter.elementsNamed(name).next();
        return (node != null && node.firstChild() != null)
            ? Std.parseFloat(node.firstChild().nodeValue)
            : defaultValue;
    }

    public static function getPoint(emitter:Xml, tag:String, ?defaultValue:Float = 0)
    {
        var node = emitter.elementsNamed(tag).next();
        if (node == null || node.firstChild() == null)
            return FlxPoint.get(defaultValue, defaultValue);
    
        var text = node.firstChild().nodeValue;
        var cleaned = text.replace("[", "").replace("]", "").trim();
        var parts = cleaned.split(" ").filter(p -> p != "");
    
        var minVal = Std.parseFloat(parts[0]);
        var maxVal = parts.length > 1 ? Std.parseFloat(parts[1]) : minVal;
    
        if (Math.isNaN(minVal)) minVal = defaultValue;
        if (Math.isNaN(maxVal)) maxVal = defaultValue;
    
        return FlxPoint.get(minVal, maxVal);
    }   
}
