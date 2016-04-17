package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class LaserDoor extends FlxSprite
{
    public var doorColor(default, null):FlxColor;
    public var end(default, null):Bool;

    private var _startX:Float;
    private var _startY:Float;

    public function new (x:Float, y:Float, color:FlxColor, angle:Float, end:Bool):Void
    {
        super(x, y);

        _startX = x;
        _startY = y;

        doorColor = color;
        this.end = end;

        var image:String = "";
        switch (doorColor) 
        {
            case FlxColor.RED:
                image = "assets/images/redLaser.png";

            default:
                throw "unknown door color";
        }

        loadGraphic(image, true, 16, 16);
        animation.add("onMiddle", [0]);
        animation.add("onEnd", [1]);
        animation.add("offEnd", [2]);
        animation.add("offMiddle", [3]);

        if (angle == 0 || angle == 180)
        {
            setSize(6, 16);
            offset.set(5, 0);
            this.x = _startX + 5;
        }
        else
        {
            setSize(16, 6);
            offset.set(0, 5);
            this.y = _startY + 5;
        }
        this.angle = angle;

        if (end)
        {
            animation.play("onEnd");
        }
        else
        {
            animation.play("onMiddle");
        }

        immovable = true;
    }

    public function updateDoor (doorState:String):Void
    {
        switch (doorState) 
        {
            case "open":
                if (end)
                {
                    animation.play("offEnd");
                    if (angle == 0)
                    {
                        setSize(6, 3);
                        offset.set(6, 13);
                        y = _startY + 13;
                        x = _startX + 6;
                    }
                    else if (angle == 90)
                    {
                        setSize(3, 6);
                        offset.set(13, 6);
                        x = _startX + 13;
                        y = _startY + 6;
                    }
                    else if (angle == 180)
                    {
                        setSize(6, 3);
                        offset.set(6, 0);
                        x = _startX + 6;
                        y = _startY;
                    }
                    else if (angle == 270)
                    {
                        setSize(3, 6);
                        offset.set(6, 13);
                        x = _startX + 6;
                        y = _startY + 13;
                    }
                }
                else
                {
                    animation.play("offMiddle");
                    setSize(0, 0);
                    offset.set(0, 0);
                    x = _startX;
                    y = _startY;
                }

            case "closed":
                if (end)
                {
                    animation.play("onEnd");
                    if (angle == 0 || angle == 180)
                    {
                        setSize(6, 16);
                        offset.set(5, 0);
                        x = _startX + 5;
                        y = _startY;
                    }
                    else
                    {
                        setSize(16, 6);
                        offset.set(0, 5);
                        x = _startX;
                        y = _startY + 5;
                    }
                }
                else
                {
                    animation.play("onMiddle");
                    if (angle == 0 || angle == 180)
                    {
                        setSize(6, 16);
                        offset.set(5, 0);
                        x = _startX + 5;
                        y = _startY;
                    }
                    else
                    {
                        setSize(16, 6);
                        offset.set(0, 5);
                        x = _startX;
                        y = _startY + 5;
                    }
                }

            default:
                throw "unknown door state: " + doorState;
        }
    }
}