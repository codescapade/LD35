package;

import flixel.FlxG;

import flixel.addons.editors.tiled.TiledLayer.TiledLayerType;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.editors.tiled.TiledTileSet;
import flixel.FlxSprite;
import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import haxe.io.Path;

class TiledLevel extends TiledMap
{
    public var tilemaps:FlxGroup;
    public var objects:FlxGroup;

    private static inline var tilemapPath:String = "assets/tilemaps/";

    public function new (level:Dynamic):Void
    {
        super(tilemapPath + level);

        tilemaps = new FlxGroup();
        objects = new FlxGroup();

        FlxG.camera.setScrollBoundsRect(0, 0, fullWidth, fullHeight, true);

        loadTilemapLayers();
        loadObjects();
    }

    private function loadTilemapLayers ():Void
    {
        for (layer in layers)
        {
            if (layer.type != TiledLayerType.TILE)
                continue;

            var tileLayer:TiledTileLayer = cast layer;
            var tilesheetName:String = tileLayer.properties.get("tileset");

            if (tilesheetName == null)
                throw "you have no 'tileset' property in: " + tileLayer.name;

            var tileset:TiledTileSet = null;
            for (ts in tilesets)
            {
                if (ts.name == tilesheetName)
                {
                    tileset = ts;
                    break;
                }
            }

            if (tileset == null)
                throw "Tileset '" + tilesheetName + "' not found";

            var imagePath:Path = new Path(tileset.imageSource);
            var processPath:String = "assets/images/" + imagePath.file + "." + imagePath.ext;

            var tilemap:FlxTilemap = new FlxTilemap();
            tilemap.loadMapFromArray(tileLayer.tileArray, width, height, processPath, tileset.tileWidth, tileset.tileHeight, null, 1, 1, 1);
            tilemaps.add(tilemap);
        }
    }

    private function loadObjects ():Void
    {
        for (layer in layers)
        {
            if (layer.type != TiledLayerType.OBJECT)
                continue;

            var objectLayer:TiledObjectLayer = cast layer;

            if (layer.name == "objects")
            {
                for (obj in objectLayer.objects)
                {
                    loadObject(obj, objectLayer, objects);
                }
            }
        }
    }

    private function loadObject (obj:TiledObject, lyr:TiledObjectLayer, group:FlxGroup):Void
    {
        var x:Int = obj.x;
        var y:Int = obj.y;

        // tiled objects are bottom left aligned so flip them to match haxeflixel
        if (obj.gid != -1)
            y -= lyr.map.getGidOwner(obj.gid).tileHeight;

        // load all objects that are in the object layer by name
        switch (obj.name.toLowerCase()) 
        {
            case "player":
                var player:Player = new Player(x, y);
                objects.add(player);
                FlxG.camera.follow(player, FlxCameraFollowStyle.PLATFORMER);
        }
    }
}