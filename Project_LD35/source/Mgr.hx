package;

import flixel.FlxG;

class Mgr 
{
    public static var gameOver:Bool = false;
    public static var levelCleared:Bool = false;
    public static var lives:Int = 3;
    public static var currentLevel:Int = 1;
    public static var lastLevel:Int = 6;

    public static var sfxVolume:Float = 0.6;
    public static var musicVolume:Float = 0.5;

    public static function toggleMusic ():Void
    {
        if (musicVolume > 0)
        {
            musicVolume = 0;
        }
        else
        {
            musicVolume = 0.5;
        }
        FlxG.sound.music.volume = musicVolume;
    }

    public static function toggleSound ():Void
    {
        if (sfxVolume > 0)
        {
            sfxVolume = 0;
        }
        else
        {
            sfxVolume = 0.6;
        }
    }
}