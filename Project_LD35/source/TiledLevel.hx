package;

import flixel.FlxG;
import flixel.addons.editors.tiled.TiledLayer.TiledLayerType;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.editors.tiled.TiledTileSet;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import haxe.io.Path;

class TiledLevel extends TiledMap
{
    private var _tilemaps:FlxGroup;
    private var _noCollide:FlxGroup;
    private var _objects:FlxGroup;
    private var _hazards:FlxGroup;
    private var _breakables:FlxGroup;
    private var _buttons:FlxTypedGroup<LaserButton>;
    private var _doors:FlxTypedGroup<LaserDoor>;

    private var _tileSize:Int;

    private static inline var _tilemapPath:String = "assets/tilemaps/";

    public function new (level:Dynamic, state:PlayState):Void
    {
        super(_tilemapPath + level);

        _tilemaps = new FlxGroup();
        _noCollide = new FlxGroup();
        _objects = new FlxGroup();
        _breakables = new FlxGroup();
        _hazards = new FlxGroup();
        _buttons = new FlxTypedGroup<LaserButton>();
        _doors = new FlxTypedGroup<LaserDoor>();

        FlxG.camera.setScrollBoundsRect(0, 0, fullWidth, fullHeight, true);

        loadTilemapLayers();
        loadObjects(state);

        state.tileGroup = _tilemaps;
        state.noCollide = _noCollide;
        state.breakableGroup = _breakables;
        state.objectGroup = _objects;
        state.hazardGroup = _hazards;
        state.buttonsGroup = _buttons;
        state.doorsGroup = _doors;
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

            _tileSize = tileset.tileWidth;
            var tilemap:FlxTilemap = new FlxTilemap();
            tilemap.loadMapFromArray(tileLayer.tileArray, width, height, processPath, tileset.tileWidth, tileset.tileHeight, null, 1, 1, 1);
            if (tileLayer.properties.get("collide") == "true")
            {
                _tilemaps.add(tilemap);
            }
            else
            {
                _noCollide.add(tilemap);
            }
        }
    }

    private function loadObjects (state:PlayState):Void
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
                    loadObject(obj, objectLayer, _objects, state);
                }
            }
            else if (layer.name == "hazards")
            {
                for (obj in objectLayer.objects)
                {
                    loadObject(obj, objectLayer, _hazards, state);
                }
            }
            else if (layer.name == "breakables")
            {
                for (obj in objectLayer.objects)
                {
                    loadObject(obj, objectLayer, _breakables, state);
                }
            }
        }
    }

    private function loadObject (obj:TiledObject, lyr:TiledObjectLayer, group:FlxGroup, state:PlayState):Void
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
                var player:Player = new Player(x, y, state);
                FlxG.camera.follow(player, FlxCameraFollowStyle.PLATFORMER);
                state.player = player;

            case "water":
                var water:FlxSprite = new FlxSprite(x,  y, "assets/images/water.png");
                water.setSize(16, 10);
                water.offset.y = 6;
                water.y += 6;
                group.add(water);

            case "spike":
                var spike:FlxSprite = new FlxSprite(x, y, "assets/images/spikes.png");
                spike.angle = Std.parseInt(obj.properties.get("rotation"));
                switch (spike.angle) 
                {
                    case 0:
                        spike.setSize(14, 7);
                        spike.offset.set(1, 9);
                        spike.x += 1;
                        spike.y += 9;
                    case 90:
                        spike.setSize(7, 14);
                        spike.offset.set(0, 1);
                        spike.y += 1;
                    case 180:
                        spike.setSize(14, 7);
                        spike.offset.set(1, 0);
                        spike.x += 1;
                    case 270:
                        spike.setSize(7, 14);
                        spike.offset.set(9, 1);
                        spike.x += 9;
                        spike.y += 1;
                }
                group.add(spike);

            case "circlesaw":
                var minPos:FlxPoint = new FlxPoint(Std.parseInt(obj.properties.get("minX")) * _tileSize, Std.parseInt(obj.properties.get("minY")) * _tileSize);
                var maxPos:FlxPoint = new FlxPoint(Std.parseInt(obj.properties.get("maxX")) * _tileSize, Std.parseInt(obj.properties.get("maxY")) * _tileSize);
                var horizontal:Bool = obj.properties.get("horizontal").toLowerCase() == "true";
                var dir:String = obj.properties.get("startDirection");

                var saw:CircleSaw = new CircleSaw(x, y);
                saw.setPath(minPos, maxPos, horizontal, dir);
                group.add(saw);

            case "block":
                var block:FlxSprite = new FlxSprite(x, y, "assets/images/brokenTile.png");
                block.immovable = true;
                group.add(block);

            case "startpipe":
                var pipe:FlxSprite = new FlxSprite(x, y, "assets/images/startPipe.png");
                pipe.immovable = true;
                group.add(pipe);

            case "endpipe":
                state.endPipe = new FlxSprite(x, y, "assets/images/endPipe.png");
                state.endPipe.immovable = true;

            case "redbutton":
                var button:LaserButton = new LaserButton(x, y, FlxColor.RED, state);
                _buttons.add(button);

            case "redlasermiddle":
                var laser:LaserDoor = new LaserDoor(x, y, FlxColor.RED, Std.parseInt(obj.properties.get("rotation")), false);
                _doors.add(laser);

            case "redlaserend":
                var laser:LaserDoor = new LaserDoor(x, y, FlxColor.RED, Std.parseInt(obj.properties.get("rotation")), true);
                _doors.add(laser);

        }
    }
}