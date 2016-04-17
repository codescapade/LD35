package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.util.FlxAxes;
import flixel.util.FlxDestroyUtil;

class GameComplete extends FlxState
{
    private var _completeText:FlxText;
    private var _creditsText:FlxText;

    private var _anyKeyText:FlxText;

    private var _fading:Bool = false;

    private var _background:FlxSprite;

    override public function create ():Void
    {
        super.create();
        FlxG.sound.playMusic("assets/music/ld35Intro.mp3", Mgr.musicVolume, true);

        FlxG.camera.flash(0xFF000000, 0.5);

        _background = new FlxSprite(0, 0, "assets/images/menuBackground.png");
        add(_background);

        _completeText = new FlxText(0, 0, 300, "Congratulations, You Completed the Game!", 16);
        _completeText.alignment = FlxTextAlign.CENTER;
        _completeText.color = FlxColor.ORANGE;
        _completeText.screenCenter();
        _completeText.y -= 30;
        add(_completeText);

        _creditsText = new FlxText(155, 102, 300, "A Game by Juriën Meerlo for Ludum Dare 35", 8);
        _creditsText.alignment = FlxTextAlign.CENTER;
        _creditsText.color = FlxColor.WHITE;
        _creditsText.screenCenter();
        _creditsText.y += 50;
        add(_creditsText);
    }

    override public function update (elapsed:Float):Void
    {
        super.update(elapsed);

        if (FlxG.keys.justPressed.ANY && !_fading)
            startFade();
    }

    override public function destroy ():Void
    {
        super.destroy();

    }

    private function startFade ():Void
    {
        FlxG.camera.fade(0xFF000000, 0.5, false, startLevel);
    }

    private function startLevel ():Void
    {
        FlxG.switchState(new MenuState());
    }
}