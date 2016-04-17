package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.util.FlxTimer;
import flixel.util.FlxAxes;
import flixel.util.FlxDestroyUtil;

class TransitionState extends FlxState
{
    private var _levelText:FlxText;
    private var _livesText:FlxText;

    private var _playerSprite:FlxSprite;

    override public function create ():Void
    {
        super.create();
        FlxG.sound.playMusic("assets/music/ld35Music02.mp3", Mgr.musicVolume, true);

        FlxG.camera.flash(0xFF000000, 0.5);

        _levelText = new FlxText(0, 0, 100, "Level: " + Mgr.currentLevel, 16);
        _levelText.screenCenter();
        _levelText.y -= 20;
        add(_levelText);

        _playerSprite = new FlxSprite(135, 100);
        _playerSprite.loadGraphic("assets/images/player.png", true, 16, 16);
        add(_playerSprite);

        _livesText = new FlxText(155, 102, 50, "X " + Mgr.lives, 8);
        add(_livesText);

        var timer:FlxTimer = new FlxTimer();
        timer.start(2, startFade);
    }

    override public function update (elapsed:Float):Void
    {
        super.update(elapsed);
    }

    override public function destroy ():Void
    {
        super.destroy();

        _levelText = FlxDestroyUtil.destroy(_levelText);
        _livesText = FlxDestroyUtil.destroy(_levelText);
        _playerSprite = FlxDestroyUtil.destroy(_playerSprite);
    }

    private function startFade (timer:FlxTimer):Void
    {
        FlxG.camera.fade(0xFF000000, 0.5, false, startLevel);
    }

    private function startLevel ():Void
    {
        FlxG.switchState(new PlayState());
    }
}