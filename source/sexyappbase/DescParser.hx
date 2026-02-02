package sexyappbase;

import openfl.utils.AssetType;
import openfl.utils.Assets;

class StringRef 
{
    public var value:Null<String>;
    public function new(v:String) 
    {
        value = v;
    }
}

class IntRef {
    public var value:Null<Int>;
    public function new(v:Int) 
    {
        value = v;
    }
}

class DoubleRef 
{
    public var value:Null<Float>;
    public function new(v:Float) 
    {
        value = v;
    }
}


class DataElement
{
    public var isList:Bool;
    public function new() {}
    public function duplicate() : DataElement 
    {
        var temp = new DataElement();
        temp.isList = isList;
        return temp;
    }
}

class SingleDataElement extends DataElement
{
    public var str:String;
    override public function new() 
    {
        super();
        str = "";
        isList = false;
    }

    override function duplicate() : DataElement
    {
        var temp = new SingleDataElement();
        var singleDataElement = cast(this, SingleDataElement);
        temp.str = singleDataElement.str;
        temp.isList = singleDataElement.isList;
        return temp;
    }
}

class ListDataElement extends DataElement
{
    public var elementVector:Array<DataElement> = [];
    override public function new() 
    {
        super();
        isList = true;
    }
}

class DescParser
{
    public static inline var CMDSEP_SEMICOLON:Int = 1;
    public static inline var CMDSEP_NO_INDENT:Int = 2;

    public var defineMap:Map<String, DataElement>;
    public var cmdSep:Int;
    public var errorStr:String;
    public var currentLineNum:Int;
    public var currentLine:StringRef;

    public function new() 
    {
        cmdSep = CMDSEP_SEMICOLON;
        defineMap = new Map<String, DataElement>();
        currentLine = new StringRef("");
    }

    public function error(err:String) : Bool
    {
        errorStr = err;
        return false;
    }

    public function dereference(str:String) : Null<DataElement>
    {
        final defineName = str.toUpperCase();
        if (defineMap.exists(defineName))
        {
            return defineMap.get(defineName);
        }
        else 
        {
            return null;
        }
    }

    public function isImmediate(str:String) : Bool
    {
        return (((str.charAt(0) >= '0') && (str.charAt(0) <= '9')) || 
        (str.charAt(0) == '-') || (str.charAt(0) == '+') || 
        (str.charAt(0) == '\'') || (str.charAt(0) == '"'));
    }

    public function unquote(quotedStr:String) : String
    {
        if ((quotedStr.charAt(0) == '\'') || (quotedStr.charAt(0) == '"'))
        {
            final quoteChar = quotedStr.charAt(0);
            var literalString = "";
            var lastWasQuote = false;

            for (i in 0...quotedStr.length)
            {
                if (quotedStr.charAt(i) == quoteChar)
                {
                    if (lastWasQuote)
                    {
                        literalString += quoteChar;
                    }

                    lastWasQuote = true;
                }
                else 
                {
                    literalString += quotedStr.charAt(i);
                    lastWasQuote = false;
                }
            }
            return literalString;
        }
        else 
        {
            return quotedStr;
        }
    }

    public function getValues(source:ListDataElement, values:ListDataElement) : Bool
    {
        values.elementVector.resize(0);

        for (sourceNum in 0... source.elementVector.length)
        {
            if (source.elementVector[sourceNum].isList)
            {
                final childList = new ListDataElement();
                values.elementVector.push(childList);

                if (!getValues(cast(source.elementVector[sourceNum], ListDataElement), childList))
                    return false;
            }
            else 
            {
                final str = cast(source.elementVector[sourceNum], SingleDataElement).str;
                if (str.length > 0)
                {
                    if (str.charAt(0) == '\'' || str.charAt(0) == '"')
                    {
                        final childData = new SingleDataElement();
                        childData.str = unquote(str);
                        values.elementVector.push(childData);
                    }
                    else if (isImmediate(str))
                    {
                        final childData = new SingleDataElement();
                        childData.str = str;
                        values.elementVector.push(childData);
                    }
                    else 
                    {
                        final defineName = str.toUpperCase();
                        if (!defineMap.exists(defineName))
                        {
                            error("Unable to Dereference \"" + str + "\"");
                            return false;
                        }

                        values.elementVector.push(defineMap.get(defineName));
                    }
                }
            }
        }
        return true;
    }

    public function dataElementToString(dataElement:DataElement) : String
    {
        if (dataElement.isList)
        {
            final listDataElement = cast(dataElement, ListDataElement);
            var str = "(";

            for (i in 0...listDataElement.elementVector.length)
            {
                if (i != 0)
                {
                    str += ", ";
                }

                str += dataElementToString(listDataElement.elementVector[i]);
            }

            str += ")";

            return str;
        }
        else 
        {
            final singleDataElement = cast(dataElement, SingleDataElement);
            return singleDataElement.str;
        }
    }

    public function dataToString(source:DataElement, str:StringRef) : Bool
    {
        str.value = "";

        if (source.isList)
        {
            return false;
        }

        final defineName = cast(source, SingleDataElement).str;
        final dataElement = dereference(defineName);

        if (dataElement != null)
        {
            if (dataElement.isList)
            {
                return false;
            }

            str.value = unquote(cast(dataElement, SingleDataElement).str);
        }
        else 
        {
            str.value = unquote(defineName);
        }

        return true;
    }

    public function dataToInt(source:DataElement, int:IntRef) : Bool 
    {
        int.value = 0; 
        var tempStr:StringRef = new StringRef("");
        if (!dataToString(source, tempStr))
        {
            return false;
        }

        int.value = Std.parseInt(tempStr.value);
        
        return int.value != null;
    }

    public function dataToStringVector(source:DataElement, stringVector:Array<String>) : Bool
    {
        stringVector.resize(0);

        var staticValues:ListDataElement = new ListDataElement();
        var values:ListDataElement = new ListDataElement();

        if (source.isList)
        {
            if (!getValues(cast(source, ListDataElement), staticValues))
                return false;
            values = staticValues;
        }
        else 
        {
            var defName = cast(source, SingleDataElement).str;
            var dataElement = dereference(defName);

            if (dataElement == null)
            {
                error("Unable to Dereference \"" + defName + "\"");
                return false; 
            }

            if (!dataElement.isList)
            {
                return false;
            }

            values = cast(dataElement, ListDataElement);
        }

        for (i in 0...values.elementVector.length)
        {
            if (values.elementVector[i].isList)
            {
                stringVector.resize(0);
                return false;
            }

            var singleDataElement = cast(values.elementVector[i], SingleDataElement);
            stringVector.push(singleDataElement.str);
        }

        return true;
    }

    public function dataToList(source:DataElement) : ListDataElement
    {
        if (source.isList)
        {
            return cast(source, ListDataElement);
        }
    
        var dataElement = dereference(cast(source, SingleDataElement).str);
    
        if (dataElement == null || !dataElement.isList)
        {
            return null;
        }
    
        return cast(dataElement, ListDataElement);
    }
        
    public function dataToIntVector(source:DataElement, intVector:Array<Int>) : Bool
    {
        var stringVector:Array<String> = [];
        if (!dataToStringVector(source, stringVector))
        {
            return false;
        }

        for (i in 0...stringVector.length)
        {
            var intVal = Std.parseInt(stringVector[i]);
            if (intVal == null)
                return false;

            intVector.push(intVal);
        }
        
        return true;
    }

    public function dataToDoubleVector(source:DataElement, doubleVector:Array<Float>) : Bool
    {
        doubleVector.resize(0);
        
        var stringVector:Array<String> = [];
        if (!dataToStringVector(source, stringVector))
        {
            return false;
        }

        for (i in 0...stringVector.length)
        {
            var doubleVal:Null<Float> = Std.parseFloat(stringVector[i]);
            if (doubleVal == null)
                return false;

            doubleVector.push(doubleVal);
        }
        
        return true;
    }

    public function parseToList(str:String, list:ListDataElement, expectedListEnd:Bool, strPos:IntRef):Bool 
    {
        var inSingleQuotes = false;
        var inDoubleQuotes = false;
        var escaped = false;
    
        var curSingleDataElement:SingleDataElement = null;
    
        var localPos = 0;
        if (strPos == null)
        {
            strPos = new IntRef(localPos);
        }
    
        while (strPos.value < str.length) 
        {
            var addSingleChar = false;
            var ch = str.charCodeAt(strPos.value++);
            var isSeparator = (ch == " ".code || ch == "\t".code || ch == "\n".code || ch == ",".code);
    
            if (escaped) 
            {
                addSingleChar = true;
                escaped = false;
            } 
            else 
            {
                if (ch == '\''.code && !inDoubleQuotes)
                {    
                    inSingleQuotes = !inSingleQuotes;
                }
                else if (ch == '"'.code && !inSingleQuotes)
                {   
                    inDoubleQuotes = !inDoubleQuotes;
                }
                if (ch == "\\".code) 
                {
                    escaped = true;
                } 
                else if (!inSingleQuotes && !inDoubleQuotes) 
                {
                    if (ch == ")".code) 
                    {
                        if (expectedListEnd)
                        {
                            return true;
                        }
                        else 
                        {
                            error("Unexpected List End");
                            return false;
                        }
                    } 
                    else if (ch == "(".code) 
                    {
                        if (curSingleDataElement != null) 
                        {
                            error("Unexpected List Start");
                            return false;
                        } 
                        else 
                        {
                            var childList = new ListDataElement();
                            if (!parseToList(str, childList, true, strPos))
                                return false;
                            list.elementVector.push(childList);
                        }
                    } 
                    else if (isSeparator) 
                    {
                        if (curSingleDataElement != null)
                        {
                            curSingleDataElement = null;
                        }
                    } 
                    else 
                    {
                        addSingleChar = true;
                    }
                } 
                else 
                {
                    addSingleChar = true;
                }
            }
    
            if (addSingleChar) 
            {
                if (curSingleDataElement == null) 
                {
                    curSingleDataElement = new SingleDataElement();
                    list.elementVector.push(curSingleDataElement);
                }
                curSingleDataElement.str += String.fromCharCode(ch);
            }
        }
    
        if (inSingleQuotes) 
        {
            error("Unterminated Single Quotes");
            return false;
        }
    
        if (inDoubleQuotes) 
        {
            error("Unterminated Double Quotes");
            return false;
        }
    
        if (expectedListEnd) 
        {
            error("Unterminated List");
            return false;
        }
    
        return true;
    }    

    public function handleCommand(params:ListDataElement) : Bool 
    {   
        return false;
    }

    public function parseDescriptorLine(descriptorLine:StringRef)
    {
        var params:ListDataElement = new ListDataElement();
        if (!parseToList(descriptorLine.value, params, false, null))
        {
            return false;
        }

        if (params.elementVector.length > 0)
        {
            if (params.elementVector[0].isList)
            {
                error("Missing Command");
                return false;
            }

            if (!handleCommand(params))
            {
                return false;
            }
        }

        return true;
    }

    public function getDescriptorPath(id:String)
    {
        id = id.toLowerCase();

        var txtList = Assets.list(AssetType.TEXT);

        for (path in txtList)
        {
            var file = path.split("/").pop();
            if (file.toLowerCase() == id + ".txt")
            {
                return path;
            }
        }

        return null;
    }

    public function loadDescriptor(fileName:String):Bool 
    {
        var path = getDescriptorPath(fileName);

        if (path == null)
            return false;

        currentLineNum = 0;
        var lineCount = 0;
        var hasErrors = false;
    
        errorStr = "";
        currentLine.value = "";
    
        var fileContent = Assets.getText(path);
    
        var aBuffChar:Int = 0;
        var i:Int = 0;
        var len:Int = fileContent.length;
    
        while (i < len)
        {
            var skipLine:Bool = false;
            var atLineStart:Bool = true;
            var inSingleQuotes:Bool = false;
            var inDoubleQuotes:Bool = false;
            var escaped:Bool = false;
            var isIndented:Bool = false;
    
            while (i < len)
            {
                var aChar:Int;
                if (aBuffChar != 0)
                {
                    aChar = aBuffChar;
                    aBuffChar = 0;
                }
                else
                {
                    aChar = fileContent.charCodeAt(i++);
                }

                if (aChar != '\r'.code)
                {
                    if (aChar == '\n'.code)
                    {
                        lineCount++;
                    }

                    if ((aChar == ' '.code || aChar == '\t'.code) && atLineStart)
                    {
                        isIndented = true;
                    }
                    
                    if (!atLineStart || (aChar != ' '.code && aChar != '\t'.code && aChar != '\n'.code))
                    {
                        if (atLineStart)
                        {
                            if ((cmdSep & CMDSEP_NO_INDENT) != 0 && !isIndented && currentLine.value.length > 0)
                            {
                                aBuffChar = aChar;
                                break;
                            }
        
                            if (aChar == '#'.code)
                                skipLine = true;
        
                            atLineStart = false;
                        }
        
                        if (aChar == '\n'.code)
                        {
                            isIndented = false;
                            atLineStart = true;
                        }
        
                        if (aChar == '\n'.code && skipLine)
                        {
                            skipLine = false;
                        }
                        else if (!skipLine)
                        {
                            if (aChar == '\\'.code && (inSingleQuotes || inDoubleQuotes) && !escaped)
                                escaped = true;
                            else
                            {
                                if (aChar == '\''.code && !inDoubleQuotes && !escaped)
                                    inSingleQuotes = !inSingleQuotes;
        
                                if (aChar == '"'.code && !inSingleQuotes && !escaped)
                                    inDoubleQuotes = !inDoubleQuotes;
        
                                if (aChar == ';'.code && (cmdSep & CMDSEP_SEMICOLON) != 0 && !inSingleQuotes && !inDoubleQuotes)
                                    break;
        
                                if (escaped)
                                {
                                    currentLine.value += "\\";
                                    escaped = false;
                                }
        
                                if (currentLine.value.length == 0)
                                    currentLineNum = lineCount + 1;
        
                                currentLine.value += String.fromCharCode(aChar);
                            }
                        }
                    }
                }
            }
    
            if (currentLine.value.length > 0)
            {
                if (!parseDescriptorLine(currentLine))
                {
                    hasErrors = true;
                    break;
                }
    
                currentLine.value = "";
            }
        }
    
        currentLine.value = "";
        currentLineNum = 0;
    
        return !hasErrors;
    }        
}