package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class LaserButton extends FlxSprite
{
    private var _gameState:PlayState;

    public var _pushed:Bool = false;
    private var _broken:Bool = false;
    private var _isOpen:Bool = false;

    private var startX:Float;
    private var startY:Float;

    private var _wasDown:Bool = false;

    public function new (x:Float, y:Float, color:FlxColor, state:PlayState)
    {
        super(x, y);
        _gameState = state;
        startX = x;
        startY = y;

        var image:String = "";
        switch (color) 
        {
            case FlxColor.RED:
                image = "assets/images/redButton.png";

            default:
                throw "no button with color: " + color;
        }

        loadGraphic(image, true, 16, 16);
        animation.add("normal", [0]);
        animation.add("pushed", [1]);
        animation.add("broken", [2]);
        animation.play("normal");
        setSize(12, 2);
        offset.set(2, 14);
        this.x = startX + 1;
        this.y = startY + 14;
        immovable = true;
    }

    override public function update (elapsed:Float):Void
    {
        _wasDown = isTouching(FlxObject.CEILING);
        if (!isTouching(FlxObject.CEILING) && !_wasDown)
        {
            _pushed = false;
        }
        super.update(elapsed);

        if (_pushed && !_isOpen)
        {
            _isOpen = true;
            if (_broken)
            {
                animation.play("broken");
            }
            else
            {
                animation.play("pushed");
            }
            
            // setSize(12, 2);
            // offset.set(2, 14);
            // this.y = startY + 14;
            _gameState.doorsGroup.forEachAlive(function (door:LaserDoor)
            {

                if (door.doorColor == FlxColor.RED)
                {
                    door.updateDoor("open");
                }
            });
        }
        else if (!_pushed && !_broken && _isOpen)
        {
            _isOpen = false;
            animation.play("normal");
            // setSize(12, 2);
            // offset.set(2, 14);
            // this.x = startX + 1;
            // this.y = startY + 14;
            _gameState.doorsGroup.forEachAlive(function (door:LaserDoor)
            {

                if (door.doorColor == FlxColor.RED)
                {
                    door.updateDoor("closed");
                }
            });
        }
    }

    public function updateState (state:String):Void
    {
        switch (state) 
        {
            case "pushed":
                _pushed = true;
            case "normal":
                _pushed = false;
            case "broken":
                _pushed = true;
                _broken = true;
        }
    }

    private function playerCollision (button:FlxObject, player:Player)
    {
        if (button.isTouching(FlxObject.CEILING))
        {
            _pushed = true;
            if (player.form == Player.Form.BLOCK)
                _broken = true;
        }
    }
}