package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class PlayState extends FlxState
{
    public var objectGroup(default, null):FlxGroup;
    public var tileGroup(default, null):FlxGroup;
    public var player(default, null):Player;

	override public function create():Void
	{
		super.create();

        var level:TiledLevel = new TiledLevel("level01.tmx", this);
        tileGroup = level.tilemaps;
        add(tileGroup);
        objectGroup = level.objects;
        add(objectGroup);
        player = level.player;
        add(player);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

        //FlxG.collide(_objectGroup, _objectGroup);
        FlxG.collide(objectGroup, tileGroup);
	}
}
