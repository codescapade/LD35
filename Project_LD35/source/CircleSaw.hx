package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;

class CircleSaw extends FlxSprite
{
    private var _minPos:FlxPoint;
    private var _maxPos:FlxPoint;
    private var _horizontal:Bool;

    private var _moveSpeed:Float = 80;

    private var _started:Bool = false;

    public function new (x:Float, y:Float):Void
    {
        super(x, y);
        loadGraphic("assets/images/sawBlade.png");
        setSize(12, 12);
        offset.set(2, 2);
        
    }

    override public function update (elapsed:Float):Void
    {
        super.update(elapsed);

        if (!_started)
            return;

        if (_horizontal)
        {
            if (x < _minPos.x)
            {
                velocity.x = _moveSpeed;
            }
            else if (x > _maxPos.x)
            {
                velocity.x = -_moveSpeed;
            }
        }
        else
        {
            if (y < _minPos.y)
            {
                velocity.y = _moveSpeed;
            }
            else if (y > _maxPos.y)
            {
                velocity.y = -_moveSpeed;
            }
        }
    }

    public function setPath (minPos:FlxPoint, maxPos:FlxPoint, horizontal:Bool, dir:String):Void
    {
        _minPos = minPos;
        _maxPos = maxPos;
        _horizontal = horizontal;
        x += 2;
        y += 2;

        var enumDir:Direction = Type.createEnum(Direction, dir);
        switch (enumDir) 
        {
            case Direction.LEFT:
                velocity.x = -_moveSpeed;

            case Direction.RIGHT:
                velocity.x = _moveSpeed;

            case Direction.UP:
                velocity.y = -_moveSpeed;

            case Direction.DOWN:
                velocity.y = _moveSpeed;

            default:
                throw "Unknown direction: " + dir;
        }

        _started = true;
    }
}

enum Direction
{
    LEFT;
    RIGHT;
    UP;
    DOWN;
}