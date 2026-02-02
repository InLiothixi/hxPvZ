package sexyappbase.imagefont;

import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import lime.app.Application;
import openfl.display.BitmapData;
import openfl.geom.Point;
import openfl.utils.Assets;
import sexyappbase.DescParser.DataElement;
import sexyappbase.DescParser.ListDataElement;
import sexyappbase.DescParser.SingleDataElement;
import sexyappbase.DescParser.StringRef;

using StringTools;

class FontData extends DescParser
{
    public var initialized:Bool;
    public var defaultPointSize:Int;
    public var charMap:Array<String>;
    public var fontLayerList:Array<FontLayer>;
    public var fontLayerMap:Map<String, FontLayer>;
    public var sourceFile:String;
    public var fontErrorHeader:String;
    public var placeHolderChar:String;

    override public function new() 
    {
        super();

        initialized = false;
        defaultPointSize = 0;
        charMap = [];
        fontLayerList = [];
        fontLayerMap = new Map<String, FontLayer>();
        sourceFile = "";
        fontErrorHeader = "";
        placeHolderChar;
    }

    override public function error(err:String) : Bool
    {
        super.error(err);
        
        var errStr = fontErrorHeader + err;

        if (currentLine.value.length > 0)
        {
            errStr +=  " on Line " + '$currentLineNum:\r\n\r\n'+ currentLine.value;
        }

        Application.current.window.alert(errStr, "An error has occured!");

        return false;
    }

    public function dataToLayer(source:DataElement) : FontLayer
    {
        if (source.isList)
        {
            return null;
        }

        final layerName = cast(source, SingleDataElement).str.toUpperCase();
        if (!fontLayerMap.exists(layerName))
        {
            error("Undefined Layer");
            return null;
        }
        
        return fontLayerMap.get(layerName);
    }

    public function getColorFromDataElement(element:DataElement, color:FlxColor) : Bool
    {
        if (element.isList)
        {
            var factorVector:Array<Float> = [];
            if (!dataToDoubleVector(element, factorVector))
            {
                return false;
            }

            color = FlxColor.fromRGBFloat(factorVector[0], factorVector[1], factorVector[2], factorVector[3]);

            return true;
        }

        var aColor = 0;
        var intVal = Std.parseInt(cast(element, SingleDataElement).str);
        if (intVal == null)
            return false;
        aColor = intVal;

        color = FlxColor.fromInt(aColor);
        return true;
    }

    override public function handleCommand(params:ListDataElement) : Bool
    {
        var cmd = cast(params.elementVector[0], SingleDataElement).str;

        var invalidNumParams = false;
        var invalidParamFormat = false;
        var literalError = false;
        var sizeMismatch = false;

        var cleanCmd = cmd.trim();
        if (cleanCmd.charAt(0) == '\uFEFF') cleanCmd = cleanCmd.substr(1); 

        switch(cleanCmd)
        {
            case "Define":
                if (params.elementVector.length == 3)
                {
                    if (!params.elementVector[1].isList)
                    {
                        var defineName = cast(params.elementVector[1], SingleDataElement).str.toUpperCase();

                        if (!isImmediate(defineName))
                        {
                            if (defineMap.exists(defineName))
                            {
                                defineMap.set(defineName, null);
                                defineMap.remove(defineName);
                            }

                            if (params.elementVector[2].isList)
                            {
                                var values = new ListDataElement();
                                if (!getValues(cast(params.elementVector[2], ListDataElement), values))
                                {
                                    values = null;
                                    return false;
                                }

                                defineMap.set(defineName, values);

                                if (defineName.startsWith("CHARLIST"))
                                {
                                    for (element in values.elementVector)
                                    {
                                        var ch = cast(element, SingleDataElement).str;
                                        charMap[ch.charCodeAt(0)] = ch.charAt(0);

                                        if (placeHolderChar == null) placeHolderChar = ch.charAt(0);
                                    }

                                    if (!charMap.contains(' '))
                                        charMap[' '.code] = ' ';
                                }
                            }
                            else 
                            {
                                var defParam = cast(params.elementVector[2], SingleDataElement);

                                var derefVal = dereference(defParam.str);

                                if (derefVal != null)
                                {
                                    defineMap.set(defineName, derefVal.duplicate());
                                }
                                else 
                                {
                                    defineMap.set(defineName, defParam.duplicate());
                                }
                            }
                        }
                        else 
                        {
                            invalidParamFormat = true;
                        }
                    }
                    else
                    {
                        invalidParamFormat = true;
                    }
                }
                else 
                {
                    invalidNumParams = true;
                }
                
            case "CreateHorzSpanRectList":
                if (params.elementVector.length == 4)
                {
                    var rectIntVector:Array<Int> = [];
                    var rectWidthsVector:Array<Int> = [];

                    if ((!params.elementVector[1].isList) && 
                        dataToIntVector(params.elementVector[2], rectIntVector) &&
                        rectIntVector.length == 4 &&
                        dataToIntVector(params.elementVector[3], rectWidthsVector))
                    {
                        final defineName = cast(params.elementVector[1], SingleDataElement).str;
                        
                        var xPos = 0;

                        var rectList = new ListDataElement();

                        for (wdithNum in 0...rectWidthsVector.length)
                        {
                            var rectElement = new ListDataElement();
                            rectList.elementVector.push(rectElement);

                            {
                                var singleDataElem = new SingleDataElement();
                                singleDataElem.str = Std.string(rectIntVector[0] + xPos);
                                rectElement.elementVector.push(singleDataElem);
                            }
                            {
                                var singleDataElem = new SingleDataElement();
                                singleDataElem.str = Std.string(rectIntVector[1]);
                                rectElement.elementVector.push(singleDataElem);
                            }
                            {
                                var singleDataElem = new SingleDataElement();
                                singleDataElem.str = Std.string(wdithNum);
                                rectElement.elementVector.push(singleDataElem);
                            }
                            {
                                var singleDataElem = new SingleDataElement();
                                singleDataElem.str = Std.string(rectIntVector[3]);
                                rectElement.elementVector.push(singleDataElem);
                            }

                            xPos += rectWidthsVector[wdithNum];
                        }

                        if (defineMap.exists(defineName))
                        {
                            defineMap.set(defineName, null);
                            defineMap.remove(defineName);
                        }

                        defineMap.set(defineName, rectList);
                    }
                    else 
                    {
                        invalidParamFormat = true;
                    }
                }
                else 
                {
                    invalidNumParams = true;
                }

            case  "SetDefaultPointSize":
                if (params.elementVector.length == 2)
                {
                    var pointSize = Std.parseInt(cast(params.elementVector[1], SingleDataElement).str);
                    if ((!params.elementVector[1].isList) && 
                        pointSize != null)
                    {
                        defaultPointSize = pointSize;
                    }
                    else 
                    {
                        invalidParamFormat = true;
                    }
                    
                }
                else 
                {
                    invalidNumParams = true;
                }
            
            case "SetCharMap":
                if (params.elementVector.length == 3)
                {
                    var fromVector:Array<String> = [];
                    var toVector:Array<String> = [];

                    if ((dataToStringVector(params.elementVector[1], fromVector)) && 
                        (dataToStringVector(params.elementVector[2], toVector)))
                    {
                        if (fromVector.length == toVector.length)
                        {
                            for (mapIdx in 0...fromVector.length)
                            {
                                charMap[fromVector[mapIdx].charCodeAt(0)] = toVector[mapIdx].charAt(0);
                            }
                        }
                        else 
                        {
                            sizeMismatch = true;
                        }
                    }
                    else 
                    {
                        invalidParamFormat = true;
                    }
                }
                else
                {
                    invalidNumParams = true;
                }

            case "CreateLayer":
                if (params.elementVector.length == 2)
                {
                    if (!params.elementVector[1].isList)
                    {
                        final layerName = cast(params.elementVector[1], SingleDataElement).str.toUpperCase();

                        var fontLayer = new FontLayer(this);
                        for (i in 0...charMap.length)
                        {
                            fontLayer.charData[i] = new CharData();
                        }
                        fontLayerList.push(fontLayer);
                        if (!fontLayerMap.exists(layerName)) 
                        {
                            fontLayerMap.set(layerName, fontLayer);
                        }
                        else 
                        {
                            error("Layer Already Exists");
                        }
                    }
                    else 
                    {
                        invalidParamFormat = true;
                    }
                }
                else 
                {
                    invalidNumParams = true;
                }

            case "CreateLayerFrom":
                if (params.elementVector.length == 3)
                {
                    var sourceLayer = dataToLayer(params.elementVector[2]);

                    if ((!params.elementVector[1].isList) && (sourceLayer != null))
                    {
                        final layerName = cast(params.elementVector[1],SingleDataElement).str.toUpperCase();
                        var fontLayer = new FontLayer(this);
                        fontLayer.fromFontLayer(sourceLayer);
                        fontLayerList.push(fontLayer);
                        if (!fontLayerMap.exists(layerName)) 
                        {
                            fontLayerMap.set(layerName, fontLayer);
                        }
                        else 
                        {
                            error("Layer Already Exists");
                        }
                    }
                    else 
                    {
                        invalidParamFormat = true;
                    }
                }
                else 
                {
                    invalidNumParams = true;
                }

            case "LayerRequireTags":
                if (params.elementVector.length == 3)
                {
                    var layer = dataToLayer(params.elementVector[1]);
                    var strVector:Array<String> = [];

                    if ((layer != null) && 
                        (dataToStringVector(params.elementVector[2], strVector)))
                    {
                        for (i in 0...strVector.length)
                        {
                            layer.requiredTags.push(strVector[i].toUpperCase());
                        }
                    }
                    else 
                    {
                        invalidParamFormat = true;
                    }
                }
                else 
                {
                    invalidNumParams = true;
                }

            case "LayerExcludeTags":
                if (params.elementVector.length == 3)
                {
                    var layer = dataToLayer(params.elementVector[1]);
                    var strVector:Array<String> = [];

                    if ((layer != null) && 
                        (dataToStringVector(params.elementVector[2], strVector)))
                    {
                        for (i in 0...strVector.length)
                        {
                            layer.excludedTags.push(strVector[i].toUpperCase());
                        }
                    }
                    else 
                    {
                        invalidParamFormat = true;
                    }
                }
                else 
                {
                    invalidNumParams = true;
                }
            
            case "LayerPointRange":
                if (params.elementVector.length == 4)
                {
                    var layer = dataToLayer(params.elementVector[1]);

                    if ((layer != null) && 
                        (!params.elementVector[2].isList) &&
                        (!params.elementVector[3].isList))
                    {
                        var minPointSize = Std.parseInt(cast(params.elementVector[2], SingleDataElement).str);
                        var maxPointSize = Std.parseInt(cast(params.elementVector[3], SingleDataElement).str);

                        if (minPointSize != null && maxPointSize != null)
                        {
                            layer.minPointSize = minPointSize;
                            layer.maxPointSize = maxPointSize;
                        }
                        else 
                        {
                            invalidParamFormat = true;
                        }
                    }
                    else 
                    {
                        invalidParamFormat = true;
                    }
                }
                else 
                {
                    invalidNumParams = true;
                }
                
            case "LayerSetPointSize":
                if (params.elementVector.length == 3)
                {
                    var layer = dataToLayer(params.elementVector[1]);
                    if ((layer != null) && 
                        (!params.elementVector[2].isList))
                    {
                        var pointSize = Std.parseInt(cast(params.elementVector[2], SingleDataElement).str);
                        if (pointSize != null)
                        {
                            layer.pointSize = pointSize;
                        }
                        else 
                        {
                            invalidParamFormat = true;
                        }
                    }
                    else 
                    {
                        invalidParamFormat = true;
                    }
                }
                else 
                {
                    invalidNumParams = true;
                }
            
            case "LayerSetHeight":
                if (params.elementVector.length == 3)
                {
                    var layer = dataToLayer(params.elementVector[1]);
                    if ((layer != null) &&
                        (!params.elementVector[2].isList))
                    {
                        var height = Std.parseInt(cast(params.elementVector[2], SingleDataElement).str);
                        if (height != null)
                        {
                            layer.height = height;
                        }
                        else 
                        {
                            invalidParamFormat = true;
                        }
                    }
                    else 
                    {
                        invalidParamFormat = true;
                    }
                }
                else 
                {
                    invalidNumParams = true; 
                }
            
            case "LayerSetImage":
                if (params.elementVector.length == 3)
                {
                    var layer = dataToLayer(params.elementVector[1]) ;
                    var fileNameString = new StringRef("");
                    if ((layer != null) && 
                        (dataToString(params.elementVector[2], fileNameString)))
                    {
                        final alphaName = "assets/fonts/_" + fileNameString.value + ".png";
                        if (Assets.exists(alphaName))
                        {
                            var alphaImage = Assets.getBitmapData(alphaName);

                            var composed = new BitmapData(alphaImage.width, alphaImage.height, true, FlxColor.WHITE);
                            composed.lock();
                            for (y in 0...alphaImage.height)
                            {
                                for (x in 0...alphaImage.width)
                                {
                                    var alphaPx = alphaImage.getPixel(x, y) & 0xFF;
                                    var argb = 0xFFFFFF | (alphaPx << 24);
                                    composed.setPixel32(x, y, argb);
                                }
                            }
                            composed.unlock();
                            layer.image = composed;
                        }
                        else
                        {
                            final fileName = "assets/fonts/" + fileNameString.value + ".png";
                            if (Assets.exists(fileName))
                            {
                                var image = Assets.getBitmapData(fileName);
                                layer.image = image;
                            }
                            else 
                            {
                                error("Failed to Load Image");
                                return false;
                            }
                        }
                        
                    }
                    else 
                    {
                        invalidParamFormat = true;
                    }
                }
                else 
                {
                    invalidNumParams = true;
                }

            case "LayerSetDrawMode":
                if (params.elementVector.length == 3)
                {
                    var layer = dataToLayer(params.elementVector[1]);
                    if ((layer != null) &&
                        (!params.elementVector[2].isList))
                    {
                        var drawMode = Std.parseInt(cast(params.elementVector[2], SingleDataElement).str);
                        if (drawMode != null)
                        {
                            layer.drawMode = drawMode;
                        }
                        else 
                        {
                            invalidParamFormat = true;
                        }
                    }
                    else 
                    {
                        invalidParamFormat = true;
                    }
                }
                else 
                {
                    invalidNumParams = true;
                }

            case "LayerSetColorMult":
                if (params.elementVector.length == 3)
                {
                    var layer = dataToLayer(params.elementVector[1]);
                    if (layer != null)
                    {
                        if (!getColorFromDataElement(params.elementVector[2], layer.colorMult))
                        {
                            invalidParamFormat = true;
                        }
                    }
                    else 
                    {
                        invalidParamFormat = true;
                    }
                }
                else 
                {
                    invalidNumParams = true;
                }
            
            case "LayerSetColorAdd":
                if (params.elementVector.length == 3)
                {
                    var layer = dataToLayer(params.elementVector[1]);
                    if (layer != null)
                    {
                        if (!getColorFromDataElement(params.elementVector[2], layer.colorAdd))
                        {
                            invalidParamFormat = true;
                        }
                    }
                    else 
                    {
                        invalidParamFormat = true;
                    }
                }
                else 
                {
                    invalidNumParams = true;
                }

            case "LayerSetAscent":
                if (params.elementVector.length == 3)
                {
                    var layer = dataToLayer(params.elementVector[1]);
                    if ((layer != null) &&
                        (!params.elementVector[2].isList))
                    {
                        var ascent = Std.parseInt(cast(params.elementVector[2], SingleDataElement).str);
                        if (ascent != null)
                        {
                            layer.ascent = ascent;
                        }
                        else 
                        {
                            invalidParamFormat = true;
                        }
                    }
                    else 
                    {
                        invalidParamFormat = true;
                    }
                }
                else 
                {
                    invalidNumParams = true;
                }

            case "LayerSetAscentPadding":
                if (params.elementVector.length == 3)
                {
                    var layer = dataToLayer(params.elementVector[1]);
                    if ((layer != null) &&
                        (!params.elementVector[2].isList))
                    {
                        var ascentPadding = Std.parseInt(cast(params.elementVector[2], SingleDataElement).str);
                        if (ascentPadding != null)
                        {
                            layer.ascentPadding = ascentPadding;
                        }
                        else 
                        {
                            invalidParamFormat = true;
                        }
                    }
                    else 
                    {
                        invalidParamFormat = true;
                    }
                }
                else 
                {
                    invalidNumParams = true;
                }

            case "LayerSetLineSpacingOffset":
                if (params.elementVector.length == 3)
                {
                    var layer = dataToLayer(params.elementVector[1]);
                    if ((layer != null) &&
                        (!params.elementVector[2].isList))
                    {
                        var lineSpacingOffset = Std.parseInt(cast(params.elementVector[2], SingleDataElement).str);
                        if (lineSpacingOffset != null)
                        {
                            layer.lineSpacingOffset = lineSpacingOffset;
                        }
                        else 
                        {
                            invalidParamFormat = true;
                        }
                    }
                    else 
                    {
                        invalidParamFormat = true;
                    }
                }
                else 
                {
                    invalidNumParams = true;
                }

            case "LayerSetOffset":
                if (params.elementVector.length == 3)
                {
                    var layer = dataToLayer(params.elementVector[1]);
                    var offsets:Array<Int> = [];

                    if ((layer != null) && 
                        (dataToIntVector(params.elementVector[2], offsets)))
                    {
                        layer.offset = FlxPoint.get(offsets[0], offsets[1]);
                    }
                    else 
                    {
                        invalidParamFormat = true;
                    }
                }
                else 
                {
                    invalidNumParams = true;
                }
    
            case "LayerSetCharWidths":
                if (params.elementVector.length == 4)
                {
                    var layer = dataToLayer(params.elementVector[1]);
                    var charsVector:Array<String> = [];
                    var charWidthsVector:Array<Int> = [];
                    if ((layer != null) &&
                        (dataToStringVector(params.elementVector[2], charsVector)) && 
                        (dataToIntVector(params.elementVector[3], charWidthsVector)))
                    {
                        if (charsVector.length == charWidthsVector.length)
                        {
                            for (i in 0...charsVector.length)
                            {
                                //if (charsVector[i].length == 1)
                                {
                                    layer.charData[charsVector[i].charCodeAt(0)].width = charWidthsVector[i];
                                }
                                // else 
                                // {
                                //     invalidParamFormat = true;
                                // }
                            }
                        }   
                        else 
                        {
                            sizeMismatch = true;
                        }
                    }
                    else 
                    {
                        invalidParamFormat = true;
                    }
                }
                else 
                {
                    invalidNumParams = true;
                }
            
            case "LayerSetSpacing":
                if (params.elementVector.length == 3)
                {
                    var layer = dataToLayer(params.elementVector[1]);
                    var offset:Array<Int> = [];

                    if ((layer != null) &&
                        (!params.elementVector[2].isList))
                    {
                        var spacing = Std.parseInt(cast(params.elementVector[2], SingleDataElement).str);
                        if (spacing != null)
                        {
                            layer.spacing = spacing;
                        }
                        else 
                        {
                            invalidParamFormat = true;
                        }
                    }
                    else 
                    {
                        invalidParamFormat = true;
                    }
                }
                else 
                {
                    invalidNumParams = true;
                }

            case "LayerSetImageMap":
                if (params.elementVector.length == 4)
                {
                    var layer = dataToLayer(params.elementVector[1]);
                    var charsVector:Array<String> = [];
                    var rectList:ListDataElement = dataToList(params.elementVector[3]);

                    if ((layer != null) &&
                        (dataToStringVector(params.elementVector[2], charsVector)) &&
                        (rectList != null))
                    {
                        if (charsVector.length == rectList.elementVector.length)
                        {
                            if (layer.image != null)
                            {
                                final imageWidth = layer.image.width;
                                final imageHeight = layer.image.height;

                                for (i in 0...rectList.elementVector.length)
                                {
                                    var rectElement:Array<Int> = [];

                                    if (/*(charsVector[i].length == 1) && */
                                        (dataToIntVector(rectList.elementVector[i], rectElement)) &&
                                        (rectElement.length == 4))
                                    {
                                        var rect = FlxRect.get(rectElement[0], rectElement[1], rectElement[2], rectElement[3]);

                                        if ((rect.x < 0) || (rect.y < 0) ||
                                            (rect.x + rect.width > imageWidth) || (rect.y + rect.height > imageHeight))
                                        {
                                            error("Image rectangle out of bounds");
									        return false;
                                        }

                                        layer.charData[charsVector[i].charCodeAt(0)].imageRect.copyFrom(rect);
                                    }
                                    else 
                                    {
                                        invalidParamFormat = true;
                                    }
                                }

                                layer.defaultHeight = 0;
                                
                                for (ch in charMap)
                                {
                                    var code = ch.charCodeAt(0);
                                    if (layer.charData[code].imageRect.height + layer.charData[code].offset.y > layer.defaultHeight)
                                    {
                                        layer.defaultHeight = Std.int(layer.charData[code].imageRect.height + layer.charData[code].offset.y);
                                    }
                                }
                            }
                            else 
                            {
                                error("Layer image not set");
						        return false;
                            }
                        }
                        else 
                        {
                            sizeMismatch = true;
                        }
                    } 
                    else 
                    {
                        invalidParamFormat = true;
                    }
                }
                else 
                {
                    invalidNumParams = true;
                }

            case "LayerSetCharOffsets":
                if (params.elementVector.length == 4)
                {
                    var layer = dataToLayer(params.elementVector[1]);
                    var charsVector:Array<String> = [];
                    var rectList:ListDataElement = dataToList(params.elementVector[3]);

                    if ((layer != null) &&
                        (dataToStringVector(params.elementVector[2], charsVector)) &&
                        (rectList != null))
                    {
                        if (charsVector.length == rectList.elementVector.length)
                        {
                            for (i in 0...rectList.elementVector.length)
                            {
                                var offsetElement:Array<Int> = [];

                                if (/*(charsVector[i].length == 1) && */
                                    (dataToIntVector(rectList.elementVector[i], offsetElement)) &&
                                    (offsetElement.length == 2))
                                {
                                    layer.charData[charsVector[i].charCodeAt(0)].offset = FlxPoint.get(offsetElement[0], offsetElement[1]);
                                }
                                else 
                                {
                                    invalidParamFormat = true;
                                }
                            }
                        }
                        else 
                        {
                            sizeMismatch = true;
                        }
                    } 
                    else 
                    {
                        invalidParamFormat = true;
                    }
                }
                else 
                {
                    invalidNumParams = true;
                }

            case "LayerSetKerningPairs":
                if (params.elementVector.length == 4)
                {
                    var layer = dataToLayer(params.elementVector[1]);
                    var pairsVector:Array<String> = [];
                    var offsetsVector:Array<Int> = [];

                    if ((layer != null) &&
                        (dataToStringVector(params.elementVector[2], pairsVector)) &&
                        (dataToIntVector(params.elementVector[3], offsetsVector)))
                    {
                        if (pairsVector.length == offsetsVector.length)
                        {
                            for (i in 0...pairsVector.length)
                            {
                                if ((pairsVector[i].length == 2))
                                {
                                    layer.charData[pairsVector[i].charCodeAt(0)].kerningOffset[pairsVector[i].charCodeAt(1)] = offsetsVector[i];
                                }
                                else 
                                {
                                    invalidParamFormat = true;
                                }
                            }
                        }
                        else 
                        {
                            sizeMismatch = true;
                        }
                    } 
                    else 
                    {
                        invalidParamFormat = true;
                    }
                }
                else 
                {
                    invalidNumParams = true;
                }

            case "LayerSetBaseOrder":
                if (params.elementVector.length == 3)
                {
                    var layer = dataToLayer(params.elementVector[1]);
                    if ((layer != null) &&
                        (!params.elementVector[2].isList))
                    {
                        var baseOrder = Std.parseInt(cast(params.elementVector[2], SingleDataElement).str);
                        if (baseOrder != null)
                        {
                            layer.baseOrder = baseOrder;
                        }
                        else 
                        {
                            invalidParamFormat = true;
                        }
                    }
                    else 
                    {
                        invalidParamFormat = true;
                    }
                }
                else 
                {
                    invalidNumParams = true;
                }

            case "LayerSetCharOrders":
                if (params.elementVector.length == 4)
                    {
                        var layer = dataToLayer(params.elementVector[1]);
                        var charsVector:Array<String> = [];
                        var charOrdersVector:Array<Int> = [];
    
                        if ((layer != null) &&
                            (dataToStringVector(params.elementVector[2], charsVector)) &&
                            (dataToIntVector(params.elementVector[3], charOrdersVector)))
                        {
                            if (charsVector.length == charOrdersVector.length)
                            {
                                for (i in 0...charsVector.length)
                                {
                                    //if (charsVector[i].length == 1)
                                    {
                                        layer.charData[charsVector[i].charCodeAt(0)].order = charOrdersVector[i];
                                    }
                                    // else
                                    // {
                                    //     invalidParamFormat = true;
                                    // }
                                }
                            }
                            else 
                            {
                                sizeMismatch = true;
                            }
                        } 
                        else 
                        {
                            invalidParamFormat = true;
                        }
                    }
                    else 
                    {
                        invalidNumParams = true;
                    }

            default:
                error("Unknown Command: " + cmd);
		        return false;
        }

        if (invalidNumParams)
        {
            error("Invalid Number of Parameters");
            return false;
        }
    
        if (invalidParamFormat)
        {
            error("Invalid Paramater Type");
            return false;
        }
    
        if (literalError)
        {
            error("Undefined Value");
            return false;
        }
    
        if (sizeMismatch)
        {
            error("List Size Mismatch");
            return false;
        }

        return true;
    }

    public function load(fontDescFileName:String) : Bool
    {
        if (initialized)
        {
            return false;
        }

        currentLine.value = "";

        fontErrorHeader = "Font Descriptor Error in " + fontDescFileName + "\r\n";
        sourceFile = fontDescFileName;
        initialized = loadDescriptor(fontDescFileName);

        return true;
    } 
}