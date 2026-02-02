package;

import flixel.math.FlxMath;

class BoardHelper 
{
    public static function gridToPixelX(GridX:Int, GridY:Int) : Int
    {
        return GridX * 80 + LAWN_XMIN;
    }

    public static function gridToPixelY(GridX:Int, GridY:Int) : Int
    {
        return GridY * 100 + LAWN_YMIN;
    }

    public static function pixelToGridX(X:Float, Y:Float) : Int
    {
        if (X < LAWN_XMIN)
            return -1;

        return Std.int(FlxMath.bound((X - LAWN_XMIN) / 80, 0, MAX_GRID_SIZE_X - 1));
    }

    public static function pixelToGridY(X:Float, Y:Float) : Int
    {
        final gridX = pixelToGridX(X, Y);
        
        if (gridX == -1 || Y < LAWN_YMIN)
            return -1;

        return Std.int(FlxMath.bound((Y - LAWN_YMIN) / 100, 0, MAX_GRID_SIZE_Y - 2));
    }

    public static function pixelToGridXKeepOnBoard(X:Float, Y:Float) : Int
    {
        final gridX = pixelToGridX(X, Y);
        return Std.int(Math.max(gridX, 0));
    }

    public static function pixelToGridYKeepOnBoard(X:Float, Y:Float) : Int
    {
        final gridY = pixelToGridY(Math.max(X, 80), Y);
        return Std.int(Math.max(gridY, 0));
    }

    public static function offsetYForPlanting(SeedType:SeedType)
    {
        return 0;
    }

    public static function plantingPixelToGridX(X:Float, Y:Float, SeedType:SeedType)
    {
        Y += offsetYForPlanting(SeedType);
        return pixelToGridX(X, Y);
    }

    public static function plantingPixelToGridY(X:Float, Y:Float, SeedType:SeedType)
    {
        Y += offsetYForPlanting(SeedType);
        final gridY = pixelToGridY(X, Y);
        return gridY;
    }
}