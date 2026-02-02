package sexyappbase;

import flixel.FlxG;
import flixel.math.FlxRect;
import flixel.system.FlxAssets.FlxShader;

class ClipEffect
{
    public var shader(default, null):ClipShader;
    public var clipRect(default, set):FlxRect;
    
    public function new(?rect:FlxRect = null)
    {
        shader = new ClipShader();
        clipRect = rect != null ? rect : new FlxRect(0, 0, FlxG.width, FlxG.height);
        setResolution();
    }
    
    function setResolution():Void
    {
        shader.uResolution.value = [FlxG.width, FlxG.height];
    }
    
    function set_clipRect(v:FlxRect):FlxRect
    {
        clipRect = v;
        if (shader != null && v != null)
        {
            shader.clipRectX.value = [v.x];
            shader.clipRectY.value = [v.y];
            shader.clipRectWidth.value = [v.width];
            shader.clipRectHeight.value = [v.height];
        }
        return v;
    }
    
    public function updateClipRect(x:Float, y:Float, width:Float, height:Float):Void
    {
        clipRect.set(x, y, width, height);
        shader.clipRectX.value = [x];
        shader.clipRectY.value = [y];
        shader.clipRectWidth.value = [width];
        shader.clipRectHeight.value = [height];
    }
}

class ClipShader extends FlxShader
{
    @:glFragmentSource('
        #pragma header
        
        uniform vec2 uResolution;
        uniform float clipRectX;
        uniform float clipRectY;
        uniform float clipRectWidth;
        uniform float clipRectHeight;
        
        vec2 getScreenCoords()
        {
            // Convert texture coordinates to screen coordinates
            return vec2(
                openfl_TextureCoordv.x * uResolution.x,
                openfl_TextureCoordv.y * uResolution.y
            );
        }
        
        bool isInClipRect(vec2 screenPos)
        {
            return screenPos.x >= clipRectX && 
                   screenPos.x <= clipRectX + clipRectWidth &&
                   screenPos.y >= clipRectY && 
                   screenPos.y <= clipRectY + clipRectHeight;
        }
        
        void main()
        {
            vec2 screenPos = getScreenCoords();
            screenPos.x = screenPos.x + 220;
            
            if (isInClipRect(screenPos))
            {
                // Inside clip rect - draw normally
                gl_FragColor = texture2D(bitmap, openfl_TextureCoordv);
            }
            else
            {
                // Outside clip rect - discard or make transparent
                discard; // Or use: gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);
            }
        }')
    public function new()
    {
        super();
    }
}