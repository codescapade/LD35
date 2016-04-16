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
    private var _objectGroup:FlxGroup;
    private var _tileGroup:FlxGroup;
	override public function create():Void
	{
		super.create();

        var level:TiledLevel = new TiledLevel("level01.tmx");
        _tileGroup = level.tilemaps;
        add(_tileGroup);
        _objectGroup = level.objects;
        add(_objectGroup);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

        FlxG.collide(_objectGroup, _objectGroup);
        FlxG.collide(_objectGroup, _tileGroup);
	}
}
