package lawn;

import RenderItem.RenderLayer;
import sexyappbase.Graphics;

class GameObject {
    public var app:Main;
    public var board:Board;
    public var x:Float;
    public var y:Float;
    public var width:Float;
    public var height:Float;
    public var visible:Bool;
    public var row:Int;
    public var renderOrder:Int;

    public function new() {
        app = Main.instance;
        board = Board.instance;
        x = 0;
        y = 0;
        width = 0;
        height = 0;
        visible = true;
        row = -1;
        renderOrder = RenderLayer.TOP;
    }

    public function beginDraw(g:Graphics) {
        if (!visible) return false;
        g.translate(x, y);
        return true;
    }

    public function endDraw(g:Graphics) {
        g.translate(-x, -y);
    }

    public function makeParentsGraphicsFrame(g:Graphics) {
        g.translate(-x, -y);
    }
    

}