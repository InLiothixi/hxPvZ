package sexyappbase;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxImageFrame;
import flixel.math.FlxMatrix;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.geom.ColorTransform;
import openfl.geom.Rectangle;
import sexyappbase.DescParser.IntRef;
import sexyappbase.imagefont.ActiveFontLayer;
import sexyappbase.imagefont.FontData;
import sexyappbase.imagefont.FontLayer;
import sexyappbase.imagefont.RenderCommand;

class ImageFont extends Font
{
    public var fontData:FontData;
    public var pointSize:Int;
    public var tagVector:Array<String>;
    public var activeListValid:Bool;
    public var activeLayerList:Array<ActiveFontLayer>;
    public var scale:Float;
    public var forceScaledImagesWhite:Bool;
    public var renderCommandPool:Array<RenderCommand>;
    public var renderTail:Array<RenderCommand>;
    public var renderHead:Array<RenderCommand>;
    public var placeHolder:BitmapData;

    public function new() 
    {  
        super();
        tagVector = [];
        activeLayerList = [];
        renderCommandPool = [];
        renderTail = [];
        renderHead = [];
    }

    public function fromImage(fontImage:BitmapData)
    {
        scale = 1.0;
        fontData = new FontData();
        fontData.initialized = true;
        pointSize = fontData.defaultPointSize;
        activeListValid = false;
        forceScaledImagesWhite = false;

        fontData.fontLayerList.push(new FontLayer(fontData));
        var fontLayer = fontData.fontLayerList[fontData.fontLayerList.length-1];

        fontData.fontLayerMap.set("", fontLayer);
        fontLayer.image = fontImage;
        fontLayer.defaultHeight = fontLayer.image.height;
        fontLayer.ascent = fontLayer.image.height;
    }

    public function fromImageFont(imageFont:ImageFont)
    {
        scale = imageFont.scale;
        fontData = imageFont.fontData;
        pointSize = imageFont.pointSize;
        tagVector = imageFont.tagVector.copy();
        activeListValid = imageFont.activeListValid;
        forceScaledImagesWhite = imageFont.forceScaledImagesWhite;

        if (activeListValid)
        {
            activeLayerList = imageFont.activeLayerList;
        }
    }

    public function fromDescriptor(fontDescFileName:String)
    {
        scale = 1.0;
        fontData = new FontData();
        fontData.load(fontDescFileName);	
        pointSize = fontData.defaultPointSize;
        generateActiveFontLayers();
        activeListValid = true;
        forceScaledImagesWhite = false;
    }

    public function fromLegacy(fontImage:BitmapData, fontDescFileName:String)
    {
        scale = 1.0;
        fontData = new FontData();
        //fontData.loadLegacy(fontImage, fontDescFileName);	
        pointSize = fontData.defaultPointSize;
        generateActiveFontLayers();
        activeListValid = true;
    }

    public function generateActiveFontLayers()
    {
        if (!fontData.initialized)
        {
            return;
        }

        activeLayerList = [];

        ascent = 0;
        ascentPadding = 0;
        height = 0;
        lineSpacingOffset = 0;

        var firstLayer = true;

        for (layerIndex in 0...fontData.fontLayerList.length)
        {
            var fontLayer = fontData.fontLayerList[layerIndex];

            if ((pointSize >= fontLayer.minPointSize) &&
                ((pointSize <= fontLayer.maxPointSize) || (fontLayer.maxPointSize == -1)))
            {
                var active = true;

                for (i in 0...fontLayer.requiredTags.length)
                {
                    if (active && !tagVector.contains(fontLayer.requiredTags[i]))
                    {
                        active = false;
                    }
                }

                for (i in 0...tagVector.length)
                {
                    if (active && !fontLayer.excludedTags.contains(tagVector[i]))
                    {
                        active = false;
                    }
                }

                if (active)
                {
                    var activeFontLayer = new ActiveFontLayer();
                    activeFontLayer.baseFontLayer = fontLayer;

                    for (ch in fontData.charMap)
                    {
                        var code = ch.charCodeAt(0);
                        activeFontLayer.scaledCharImageRects[code] = FlxRect.get();
                    }

                    activeLayerList.push(activeFontLayer);

                    var layerPointSize = 1.0;
                    var pointSize = scale;

                    if ((scale == 1.0) && ((fontLayer.pointSize == 0) || (this.pointSize == fontLayer.pointSize)))
                    {
                        activeFontLayer.scaledImage = fontLayer.image;

                        for (ch in fontData.charMap)
                        {
                            var code = ch.charCodeAt(0);
                            activeFontLayer.scaledCharImageRects[code].copyFrom(fontLayer.charData[code].imageRect);
                        }
                    }
                    else
                    {
                        if (fontLayer.pointSize != 0)
                        {
                            layerPointSize = fontLayer.pointSize;
                            pointSize = this.pointSize * scale;
                        }

                        var curX = 0;
                        var maxHeight = 0;

                        for (ch in fontData.charMap)
                        {
                            var code = ch.charCodeAt(0);

                            var origRect = fontLayer.charData[code].imageRect;
                            var scaledRect = FlxRect.get(curX, 0, 
                                Std.int((origRect.width * pointSize) / layerPointSize),
                                Std.int((origRect.height * pointSize) / layerPointSize));
                            activeFontLayer.scaledCharImageRects[code].copyFrom(scaledRect);

                            if (scaledRect.height > maxHeight)
                            {
                                maxHeight = Std.int(scaledRect.height);
                            }

                            curX += Std.int(scaledRect.width);
                        }

                        var image = new BitmapData(curX, maxHeight, true, FlxColor.TRANSPARENT);

                        activeFontLayer.scaledImage = image;

                        for (ch in fontData.charMap)
                        {
                            var code = ch.charCodeAt(0);

                            if (fontLayer.image != null)
                            {
                                final graphic = FlxGraphic.fromBitmapData(fontLayer.image);
                                final matrix = new FlxMatrix();
                                final point = new FlxPoint();
                                final colorTransform = new ColorTransform();
                                final clipRect = new Rectangle(activeFontLayer.scaledCharImageRects[code].x, activeFontLayer.scaledCharImageRects[code].y,
                                    activeFontLayer.scaledCharImageRects[code].width, activeFontLayer.scaledCharImageRects[code].height);
                
                                graphic.imageFrame.frame.prepareMatrix(matrix);
                                matrix.scale(activeFontLayer.scaledCharImageRects[code].width / fontLayer.charData[code].imageRect.width, 
                                    activeFontLayer.scaledCharImageRects[code].height /fontLayer.charData[code].imageRect.height);
                                
                                point.add(activeFontLayer.scaledCharImageRects[code].x,  activeFontLayer.scaledCharImageRects[code].y);
                                matrix.translate(point.x, point.y);

                                image.drawWithQuality(fontLayer.image, matrix, colorTransform, BlendMode.NORMAL, clipRect, true, StageQuality.BEST);
                            }
                        }

                        if (forceScaledImagesWhite)
                        {
                            for (y in 0...image.height)
                            {
                                for (x in 0...image.width)
                                {
                                    var color = image.getPixel32(x, y);
                                    var alpha = color & 0xFF000000;
                                    image.setPixel32(x, y, alpha | 0x00FFFFFF);
                                }
                            }
                        }

                        var layerAscent = (fontLayer.ascent * pointSize) / layerPointSize;
                        if (layerAscent > ascent)
                        {
                            ascent = Std.int(layerAscent);
                        }

                        if (fontLayer.height != 0)
                        {
                            var layerHeight = (fontLayer.height * pointSize) / layerPointSize;
                            if (layerHeight > height)
                            {
                                height = Std.int(layerHeight);
                            }
                        }
                        else
                        {
                            var layerHeight = (fontLayer.defaultHeight * pointSize) / layerPointSize;
                            if (layerHeight > height)
                            {
                                height = Std.int(layerHeight);
                            }
                        }

                        var ascentPadding = (fontLayer.ascentPadding * pointSize) / layerPointSize;
                        if ((firstLayer) || (ascentPadding < this.ascentPadding))
                            this.ascentPadding = Std.int(ascentPadding);

                        var lineSpacingOffset = (fontLayer.lineSpacingOffset * pointSize) / layerPointSize;
                        if ((firstLayer) || (lineSpacingOffset < this.lineSpacingOffset))
                            this.lineSpacingOffset = Std.int(lineSpacingOffset);

                        firstLayer = false;
                    }
                }
            }
        }
    }

    public function prepare()
    {
        if (!activeListValid)
        {
            generateActiveFontLayers();
            activeListValid = true;
        }
    }

    override public function charWidthKern(char:String, prevChar:String)
    {
        prepare();

        var maxXPos = 0;
        var pointSize = pointSize * scale;

        char = fontData.charMap[char.charCodeAt(0)];
        if (prevChar.charCodeAt(0) != 0)
        {
            prevChar = fontData.charMap[prevChar.charCodeAt(0)];
        }

        for (layer in activeLayerList)
        {
            var layerXPos = 0;
            var charWidth = 0;
            var spacing = 0;
            var layerPointSize = layer.baseFontLayer.pointSize;

            if (layerPointSize == 0)
            {
                charWidth = Std.int(layer.baseFontLayer.charData[char.charCodeAt(0)].width * scale);

                if (prevChar.charCodeAt(0) != 0)
                {
                    spacing = Std.int((layer.baseFontLayer.spacing + layer.baseFontLayer.charData[prevChar.charCodeAt(0)].kerningOffset[char.charCodeAt(0)]) * scale);
                }
                else 
                {
                    spacing = 0;
                }
            }
            else 
            {
                charWidth = Std.int(layer.baseFontLayer.charData[char.charCodeAt(0)].width * pointSize / layerPointSize);

                if (prevChar.charCodeAt(0) != 0)
                {
                    spacing = Std.int((layer.baseFontLayer.spacing + layer.baseFontLayer.charData[prevChar.charCodeAt(0)].kerningOffset[char.charCodeAt(0)]) * pointSize / layerPointSize);
                }
                else 
                {
                    spacing = 0;
                }

            }

            layerXPos += charWidth + spacing;

            if (layerXPos > maxXPos)
            {
                maxXPos = layerXPos;
            }
        }

        return maxXPos;
    }

    override public function charWidth(char:String)
    {
        return charWidthKern(char, String.fromCharCode(0));
    }

    override public function stringWidth(str:String)
    {
        var width = 0;
        var prevChar = String.fromCharCode(0);

        for (i in 0...str.length)
        {
            var char = str.charAt(i);
            width += charWidthKern(char, prevChar);
            prevChar = char;
        }

        return width;
    }

    public function drawStringEx(g:Graphics, x:Float, y:Float, str:String, color:FlxColor, clipRect:FlxRect, drawnAreas:Array<FlxRect>, width:IntRef)
    {
        renderHead.resize(0);
        renderTail.resize(0);
        
        if (drawnAreas != null)
        {
            drawnAreas.resize(0);
        }

        if (!fontData.initialized)
        {
            if (width != null)
            {
                width.value = 0;
            }
            return;
        }

        prepare();

        var curXPos = x;
        var curPoolIdx = 0;
        
        for (charNum in 0...str.length)
        {
            var char:String;

            var isInvalidChar = false;
            if (fontData.charMap[str.charCodeAt(charNum)] == null)
            {
                isInvalidChar = true;
                char = fontData.placeHolderChar;
            }
            else 
            {
                char = fontData.charMap[str.charCodeAt(charNum)];
            }

            var nextChar = String.fromCharCode(0);
            if (charNum < str.length - 1)
            {
                if (fontData.charMap[str.charCodeAt(charNum + 1)] != null)
                {
                    nextChar = fontData.charMap[str.charCodeAt(charNum + 1)];
                }
            }

            var maxXpos = curXPos;
            var layerCount = 0;

            for (layer in activeLayerList)
            {
                var layerXPos = curXPos;
                var imagePos = FlxPoint.get();
                var charWidth = 0.0;
                var spacing = 0.0;
                var layerPointSize = layer.baseFontLayer.pointSize;
                var scale = this.scale;
                if (layerPointSize != 0)
                {
                    scale *= this.pointSize / layerPointSize;
                }

                if (scale == 1.0)
                {
                    imagePos.x = layerXPos + layer.baseFontLayer.offset.x + layer.baseFontLayer.charData[char.charCodeAt(0)].offset.x;
                    imagePos.y = y - (layer.baseFontLayer.ascent - layer.baseFontLayer.offset.y - layer.baseFontLayer.charData[char.charCodeAt(0)].offset.y);
                    charWidth = layer.baseFontLayer.charData[char.charCodeAt(0)].width;

                    if (nextChar != String.fromCharCode(0))
                    {
                        spacing = layer.baseFontLayer.spacing + layer.baseFontLayer.charData[char.charCodeAt(0)].kerningOffset[nextChar.charCodeAt(0)];
                    }
                    else 
                    {
                        spacing = 0.0;
                    }
                }
                else 
                {
                    imagePos.x = layerXPos + (layer.baseFontLayer.offset.x + layer.baseFontLayer.charData[char.charCodeAt(0)].offset.x) * scale;
                    imagePos.y = y - (layer.baseFontLayer.ascent - layer.baseFontLayer.offset.y - layer.baseFontLayer.charData[char.charCodeAt(0)].offset.y) * scale;
                    charWidth = layer.baseFontLayer.charData[char.charCodeAt(0)].width * scale;

                    if (nextChar != String.fromCharCode(0))
                    {
                        spacing = (layer.baseFontLayer.spacing + layer.baseFontLayer.charData[char.charCodeAt(0)].kerningOffset[nextChar.charCodeAt(0)]) * scale;
                    }
                    else 
                    {
                        spacing = 0.0;
                    }
                }

                var aColor:FlxColor = new FlxColor();
                aColor.redFloat = Math.min(color.redFloat * layer.baseFontLayer.colorMult.redFloat + layer.baseFontLayer.colorAdd.redFloat, 1.0);
                aColor.greenFloat = Math.min(color.greenFloat * layer.baseFontLayer.colorMult.greenFloat  + layer.baseFontLayer.colorAdd.greenFloat, 1.0);
                aColor.blueFloat = Math.min(color.blueFloat * layer.baseFontLayer.colorMult.blueFloat + layer.baseFontLayer.colorAdd.blueFloat, 1.0);
                aColor.alphaFloat = Math.min(color.alphaFloat * layer.baseFontLayer.colorMult.alphaFloat  + layer.baseFontLayer.colorAdd.alphaFloat, 1.0);

                var baseOrder = layer.baseFontLayer.baseOrder;
                if (baseOrder == null || baseOrder == 0)
                {
                    baseOrder = layerCount++;
                }
                var order = baseOrder + layer.baseFontLayer.charData[char.charCodeAt(0)].order;

                var renderCommand = renderCommandPool[curPoolIdx++];
                if (renderCommand == null)
                    renderCommand = new RenderCommand();
                renderCommand.image = layer.scaledImage;
                renderCommand.color = aColor;
                renderCommand.dest = imagePos;
                renderCommand.src.copyFrom(layer.scaledCharImageRects[char.charCodeAt(0)]);
                renderCommand.mode = layer.baseFontLayer.drawMode;
                renderCommand.isPlaceHolder = isInvalidChar;
                renderCommand.next = null;

                var orderIdx = Std.int(Math.min(Math.max(0, order + 128), 255));

                if (renderTail[orderIdx] == null)
                {
                    renderTail[orderIdx] = renderCommand;
                    renderHead[orderIdx] = renderCommand;
                }
                else 
                {
                    renderTail[orderIdx].next = renderCommand;
                    renderTail[orderIdx] = renderCommand;
                }

                if (drawnAreas != null)
                {
                    var destRect = new FlxRect(imagePos.x, imagePos.y, renderCommand.src.width, renderCommand.src.height);
                    drawnAreas.push(destRect);
                }

                layerXPos += charWidth + spacing;

                if (layerXPos > maxXpos)
                {
                    maxXpos = layerXPos;
                }
            }

            curXPos = maxXpos;
        }

        if (width != null)
        {
            width.value = Std.int(curXPos - x);
        }

        for (poolIdx in 0...renderHead.length)
        {
            var renderCommand = renderHead[poolIdx];
        
            while (renderCommand != null)
            {
                if (renderCommand.isPlaceHolder)
                {
                    if (placeHolder == null)
                    {
                        var w = Std.int(renderCommand.src.width);
                        var h = Std.int(renderCommand.src.height);
                        var thickness = Std.int(Math.max((w + h) / 12, 1));

                        var placeHolderGraphic = FlxG.bitmap.create(w, h, FlxColor.TRANSPARENT, 
                            false, 'imagefont_placeholder(${fontData.sourceFile})');

                        placeHolder = placeHolderGraphic.bitmap;
                        placeHolder.lock();
                        for (_y in 0...h)
                        {
                            for (_x in 0...w)
                            {
                                var isBorder = 
                                (_x < thickness) || 
                                (_x >= w - thickness) ||
                                (_y < thickness) ||
                                (_y >= h - thickness); 

                            if (isBorder)
                                placeHolder.setPixel32(_x, _y, FlxColor.WHITE);
                            }
                        }
                        placeHolder.unlock();
                    }

                    renderCommand.image = placeHolder;
                }


                // if (renderCommand.dest.x < clipRect.left)
                // {
                //     var diff = Math.floor(clipRect.left - renderCommand.dest.x);
                //     renderCommand.src.x += diff;
                //     renderCommand.src.width -= diff;
                //     renderCommand.dest.x = clipRect.left;
                // }
                
                // if (renderCommand.dest.x + renderCommand.src.width > clipRect.right)
                // {
                //     var diff = Math.floor((renderCommand.dest.x + renderCommand.src.width) - clipRect.right);
                //     renderCommand.src.width -= diff;
                // }

                // if (renderCommand.dest.y < clipRect.top)
                // {
                //     var diff = Math.floor(clipRect.top - renderCommand.dest.y);
                //     renderCommand.src.y += diff;
                //     renderCommand.src.height -= diff;
                //     renderCommand.dest.y = clipRect.top;
                // }
                
                // if (renderCommand.dest.y + renderCommand.src.height > clipRect.bottom)
                // {
                //     var diff = Math.floor((renderCommand.dest.y + renderCommand.src.height) - clipRect.bottom);
                //     renderCommand.src.height -= diff;
                // }

                // var graphic = FlxGraphic.fromBitmapData(renderCommand.image);

                // if (renderCommand.src.width <= 0 || renderCommand.src.height <= 0 || graphic == null)          
                // {
                //     renderCommand = renderCommand.next;
                //     continue;
                // }
                
                // var matrix = new FlxMatrix();
                // var point = new FlxPoint();
                
                // var colorTransform = new ColorTransform(
                //     renderCommand.color.redFloat,
                //     renderCommand.color.greenFloat,
                //     renderCommand.color.blueFloat,
                //     renderCommand.color.alphaFloat
                // );
    
                // var frame = FlxImageFrame.fromRectangle(graphic, renderCommand.src);
        
                // //matrix.scale(1.0, 1.0);
        
                // point.set(renderCommand.dest.x, renderCommand.dest.y);
                // // point.subtract(camera.scroll.x, camera.scroll.y);

                // frame.frame.prepareMatrix(matrix);
                // matrix.translate(point.x, point.y);

                // matrix.tx = Math.floor(matrix.tx);
                // matrix.ty = Math.floor(matrix.ty);
        
                // camera.drawPixels(
                //     frame.frame,
                //     graphic.bitmap, 
                //     matrix,
                //     colorTransform,
                //     renderCommand.mode == -1 ? BlendMode.NORMAL : BlendMode.ADD,
                //     true
                // );

                g.pushState();
                g.translate(renderCommand.dest.x, renderCommand.dest.y);
                g.blendMode = renderCommand.mode == -1 ? BlendMode.NORMAL : BlendMode.ADD;
                g.drawSourceImage(renderCommand.image, renderCommand.src);
                g.popState();
        
                renderCommand = renderCommand.next;
            }
        }
            
    }

    public function getMappedChar(value:String)
    {
        return fontData.charMap[value.charCodeAt(0)];
    }

    override public function drawString(g:Graphics, x:Float, y:Float, str:String, color:FlxColor, clipRect:FlxRect)
    {
        drawStringEx(g, x, y, str, color, clipRect, null, null);
    }
}
