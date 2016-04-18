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
    public var objectGroup:FlxGroup;
    public var tileGroup:FlxGroup;
    public var noCollide:FlxGroup;
    public var hazardGroup:FlxGroup;
    public var breakableGroup:FlxGroup;
    public var buttonsGroup:FlxTypedGroup<LaserButton>;
    public var doorsGroup:FlxTypedGroup<LaserDoor>;
    public var player:Player;
    public var endPipe:FlxSprite;

    private var _tutJumpText:FlxText;
    private var _tutChute:FlxText;

    private var _tutGoal:FlxText;

	override public function create():Void
	{
		super.create();

        FlxG.camera.flash(0xFF000000, 0.5);
        Mgr.gameOver = false;
        Mgr.levelCleared = false;

        var levelName:String = "";
        if (Mgr.currentLevel < 10)
        {
            levelName = "level0" + Mgr.currentLevel + ".tmx";
        }
        else
        {
            levelName = "level" + Mgr.currentLevel + ".tmx";
        }
        var level:TiledLevel = new TiledLevel(levelName, this);
        add(tileGroup);
        add(noCollide);
        add(breakableGroup);
        add(hazardGroup);
        add(objectGroup);
        add(endPipe);
        add(buttonsGroup);
        add(doorsGroup);

        if (Mgr.currentLevel == 1)
        {
            _tutJumpText = new FlxText(50, 80, 150, "Press SpaceBar To Jump", 8);
            add(_tutJumpText);

            _tutChute = new FlxText(300, 70, 160, "Press and Hold SpaceBar While in the Air To Float", 8);
            add(_tutChute);

            _tutGoal = new FlxText(558, 166, 50, "Goal >", 8);
            add(_tutGoal);
        }
        else if (Mgr.currentLevel == 2)
        {
            _tutJumpText = new FlxText(20, 390, 120, "Hold Left or Right Against a Wall to Stick to it", 8);
            add(_tutJumpText);

            _tutChute = new FlxText(400, 100, 150, "Hold Down while in the air to break cracked blocks", 8);
            add(_tutChute);
        }

        add(player);


	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

        if (FlxG.keys.justPressed.M)
        {
            Mgr.toggleMusic();
        }

        if (FlxG.keys.justPressed.S)
        {
            Mgr.toggleSound();
        }
	}
}
