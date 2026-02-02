package entities;

import RenderItem.RenderObject;
import entities.Projectile.Pea;
import flixel.group.FlxGroup.FlxTypedGroup;

class Entities
{
    //public var plants:FlxTypedGroup<Plant>;
    public var projectiles:FlxTypedGroup<Projectile>;

    public function new()
    {
        //plants = new FlxTypedGroup<Plant>();
        projectiles = new FlxTypedGroup<Projectile>();
    }

    // public function addPlant(GridX:Int, GridY:Int, SeedType:SeedType) : Plant
    // {
    //     final definition = EntityDefinition.plantDefinitions.get(SeedType);
    //     final plant = Type.createInstance(definition.type, [Main, GridX, GridY, SeedType, definition]);
    //     return plants.add(plant);
    // }

    public function addProjectile(X:Float, Y:Float, Row:Int)
    {
        final projectile = new Pea(X, Y, Row);
        return projectiles.add(projectile);
    }

    public function update(elapsed:Float)
    {
        //plants.update(elapsed);
        projectiles.update(elapsed);

        cleanup();
    }

    public function cleanup()
    {
        // plants.forEachDead(function(plant) {
        //     plants.remove(plant, true);
        //     plants.destroy();
        // });

        projectiles.forEachDead(function(projectile) {
            projectiles.remove(projectile, true);
            projectile.destroy();
        });
    }

    public function draw()
    {
        // plants.forEachAlive(function(plant){
        //     Main.board.renderHelper.addRenderItem(RenderObject.Plant(plant));
        // });

        // projectiles.forEachAlive(function(projectile) {
        //     Main.board.renderHelper.addRenderItem(RenderObject.ProjectileShadow(projectile));
        //     Main.board.renderHelper.addRenderItem(RenderObject.Projectile(projectile));
        // });
    }
}