package;

// import entities.Plant;
import entities.Projectile;

enum RenderObject 
{
    //Plant(p:Plant);
    Projectile(p:Projectile);
    ProjectileShadow(p:Projectile);
    GridY(y:Int);
}

class RenderItem 
{
    public var zPos:Int;
    public var object:RenderObject;
    
    public function new(Object:RenderObject) 
    {
        object = Object;
        zPos = switch (Object) {
            //case Plant(p): p.renderOrder;
            case Projectile(p): p.renderOrder;
            case ProjectileShadow(p): RenderHelper.makeRenderOrder(RenderLayer.GROUND, p.row, 3);
            case GridY(y) : y;
        }
    }

    public function draw() {
        switch (object) {
            //case Plant(p): p.draw();
            case Projectile(p): p.draw();
            case ProjectileShadow(p): p.shadow.draw();
            case GridY(y): return;
        }
    }
}

abstract RenderLayer(Int) from Int to Int {
    public static final ROW_OFFSET = 10000;
    public static final UI_BOTTOM = 100000;
    public static final GROUND = 200000;
    public static final LAWN = 300000;
    public static final GRAVE_STONE = 301000;
    public static final PLANT = 302000;
    public static final ZOMBIE = 303000;
    public static final BOSS = 304000;
    public static final PROJECTILE = 305000;
    public static final LAWN_MOWER = 305000;
    public static final PARTICLE  = 305000;
    public static final TOP = 400000;
    public static final FOG = 500000;
    public static final COIN_BANK = 600000;
    public static final UI_TOP = 700000;
    public static final ABOVE_UI = 800000;
    public static final SCREEN_FADE = 900000;
}

class RenderHelper 
{
    public var renderList:Array<RenderItem>;

    public function new() 
    {
        renderList = [];
    }

    public function addRenderItem(Object:RenderObject) 
    {
        renderList.push(new RenderItem(Object));
    }

    public function draw() 
    {
        renderList.sort((a, b) -> a.zPos - b.zPos);

        for (item in renderList) {
            item.draw();
        }

        renderList.resize(0);
    }

    public static function makeRenderOrder(Layer:RenderLayer, Row:Int, LayerOffset:Int):Int
    {
        return Row * RenderLayer.ROW_OFFSET + Layer + LayerOffset;
    }
}