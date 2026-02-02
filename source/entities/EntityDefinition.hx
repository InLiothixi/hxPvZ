package entities;

import ConstEnums.SeedType;
import entities.Plant;
import flixel.util.FlxColor;

typedef PlantDefinition = {
    var type:Class<Plant>;
    var health:Float;
    var color:FlxColor;
    var cost:Int;
    var refreshTime:Float;
    var launchRate:Float;
}

typedef PlantDefinitionParams = {
    ?type:Class<Plant>,
    ?health:Float,
    ?color:FlxColor,
    ?cost:Int,
    ?refreshTime:Float,
    ?launchRate:Float
}

class EntityDefinition 
{
    public static function makePlantDefinition(?params:PlantDefinitionParams) 
    {
        return {
            type: params?.type ?? Plant,
            health: params?.health ?? 300,
            color: params?.color ?? FlxColor.WHITE,
            cost: params?.cost ?? 0,
            refreshTime: params?.refreshTime ?? 0,
            launchRate: params?.launchRate ?? 0
        };
    }
        
    public static final plantDefinitions:Map<SeedType, PlantDefinition> = [
        PEASHOOTER => makePlantDefinition({type: Peashooter, color: FlxColor.LIME, cost: 100, launchRate: 1.5}),
        SUNFLOWER => makePlantDefinition({type: Sunflower, color: FlxColor.BROWN, cost: 50, launchRate: 25})
    ];
}