package entities;

import flixel.FlxG;
import flixel.FlxSprite;

class Projectile extends FlxSprite
{
    public var shadow:FlxSprite;
    var shadowY:Float;
    public var row:Int;
    public var renderOrder:Int;
    
    function initializeShadow() 
    {
        shadow.loadGraphic(AssetPaths.pea_shadows__png, true, 21, 9);

        //final gridX = pixelToGridXKeepOnBoard(x, y);
        //shadowY = gridToPixelY(gridX, row) + 67;
    };

    function initialize() 
    {
        width = 40;
        height = 40;
    };
    
    override public function new(X:Float, Y:Float, Row:Int) 
    {
        super(X, Y);
        row = Row;
        initialize();
        shadow = new FlxSprite(X, Y);
        initializeShadow();
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        updateShadow();
    }

    function updateShadow()
    {
        shadow.x = x;
        shadow.y = shadowY;
    }

    override function draw() 
    {
        super.draw();
    }

    override function kill() 
    {
        super.kill();
        shadow.kill();
    }

    override function destroy() 
    {
        super.destroy();
        shadow.destroy();
    }
}

class Straight extends Projectile
{
    override function update(elapsed:Float)
    {
        super.update(elapsed);
        checkForCollision();
    }

    function checkForCollision()
    {
        if (x > 800 + GameConstants.BOARD_OFFSET || x + width < GameConstants.BOARD_OFFSET )
            kill();
    }
}

class Lobbed extends Projectile
{
    
}

class Pea extends Straight
{
    override function initialize() 
    {
        loadGraphic(AssetPaths.ProjectilePea__png);
        super.initialize();
    }

    override function updateShadow() 
    {
        super.updateShadow();
        shadow.x += 3;
    }
}