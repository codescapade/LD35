package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxAxes;
import flixel.system.scaleModes.RatioScaleMode;

using flixel.util.FlxDestroyUtil;

class MenuState extends FlxState
{
    private var _title:FlxText;
    private var _action:FlxText;

	override public function create ():Void
	{
		super.create();
        
        FlxG.scaleMode = new RatioScaleMode(true);
        _title = new FlxText(0, 20, 200, "Shape Shifter", 16);
        _title.alignment = FlxTextAlign.CENTER;
        _title.color = 0xFF0033AA;
        _title.screenCenter(FlxAxes.X);
        add(_title);

        _action = new FlxText(0, 100, 300, "Press Space to Start", 8);
        _action.alignment =FlxTextAlign.CENTER;
        _action.color = 0xFFAAAA00;
        add(_action);
	}

	override public function update (elapsed:Float):Void
	{
		super.update(elapsed);

        if (FlxG.keys.justPressed.SPACE)
        {
            startGame();
        }
	}

    override public function destroy ():Void
    {
        super.destroy();

        _title = FlxDestroyUtil.destroy(_title);
        _action = FlxDestroyUtil.destroy(_action);
    }

    private function startGame ():Void
    {
        FlxG.switchState(new PlayState());
    }
}
