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

    private var _fading:Bool = false;

    private var _toggleMusicText:FlxText;
    private var _toggleSoundTex:FlxText;

    private var _background:FlxSprite;

	override public function create ():Void
	{
		super.create();

        FlxG.sound.playMusic("assets/music/ld35Intro.mp3", Mgr.musicVolume, true);

        FlxG.mouse.visible = false;
        
        FlxG.scaleMode = new RatioScaleMode(true);

        _background = new FlxSprite(0, 0, "assets/images/menuBackground.png");
        add(_background);

        _title = new FlxText(0, 20, 180, "Squishy's Escape", 16);
        _title.alignment = FlxTextAlign.CENTER;
        _title.color = 0xFF0033AA;
        _title.screenCenter(FlxAxes.X);
        _title.x -= 25;
        _title.y += 10;
        add(_title);

        _action = new FlxText(0, 100, 200, "Press Space to Start", 8);
        _action.alignment =FlxTextAlign.CENTER;
        _action.screenCenter(FlxAxes.X);
        _action.color = 0xFFAAAA00;
        add(_action);

        _toggleMusicText = new FlxText(220, 150, 100, "M to toggle Music", 8);
        add(_toggleMusicText);

        _toggleSoundTex = new FlxText(220, 160, 100, "S to toggle Sound", 8);
        add(_toggleSoundTex);

        Mgr.lives = 3;
        Mgr.currentLevel = 1;
	}

	override public function update (elapsed:Float):Void
	{
		super.update(elapsed);

        if (FlxG.keys.justPressed.SPACE && !_fading)
        {
            _fading = true;
            FlxG.camera.fade(0xFF000000, 0.5, false, startGame);
        }

        if (FlxG.keys.justPressed.M)
        {
            Mgr.toggleMusic();
        }

        if (FlxG.keys.justPressed.S)
        {
            Mgr.toggleSound();
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
        FlxG.sound.music.stop();
        FlxG.switchState(new TransitionState());
    }
}
