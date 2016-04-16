package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.tile.FlxTilemap;

class Player extends FlxSprite
{
    private var _blobAcceleration:Float = 450;
    private var _chuteAcceleration:Float = 40;
    private var _blockAcceleration:Float = 1000;
    private var _moveSpeed:Float = 80;
    private var _jumpSpeed:Float = 200;

    private var _grounded:Bool = false;
    private var _isJumping:Bool = false;

    private var _form:Form = Form.BLOB;

    public function new (x:Float, y:Float):Void
    {
        super(x, y);
        loadGraphic("assets/images/player.png", true, 16, 16);
        animation.add("blob", [0]);
        animation.add("block", [1]);
        animation.add("chute", [2]);

        updateForm(Form.BLOB);
        animation.play("blob");

        setSize(14, 9);
        centerOffsets();

        acceleration.y = _blobAcceleration;
    }

    override public function update (elapsed:Float):Void
    {
        _grounded = isTouching(FlxObject.FLOOR);

        if (FlxG.keys.justPressed.SPACE)
        {
            if (_grounded && _form == Form.BLOB)
            {
                velocity.y = -_jumpSpeed;
            }
            else if (_form == Form.BLOB)
            {
                updateForm(Form.CHUTE);
            }
        }

        if (FlxG.keys.justReleased.SPACE && _form == Form.CHUTE)
        {
            updateForm(Form.BLOB);
        }

        if (FlxG.keys.pressed.DOWN)
        {
            updateForm(Form.BLOCK);
        }
        else if (_form == Form.BLOCK)
        {
            updateForm(Form.BLOB);
        }

        velocity.x = 0;
        if (_form == Form.BLOB || (_form == Form.CHUTE && !_grounded))
        {
            if (FlxG.keys.pressed.LEFT)
            {
                flipX = true;
                velocity.x = -_moveSpeed;
            }
            else if (FlxG.keys.pressed.RIGHT)
            {
                flipX = false;
                velocity.x = _moveSpeed;
            }
        }
        
        super.update(elapsed);
    }

    private function updateForm (newForm:Form):Void
    {
        switch (newForm) 
        {
            case Form.BLOB:
                _form = Form.BLOB;
                acceleration.y = _blobAcceleration;
                animation.play("blob");
                setSize(14, 9);
                offset.x = 1;
                offset.y = 4;

            case Form.BLOCK:
                _form = Form.BLOCK;
                acceleration.y = _blockAcceleration;
                animation.play("block");
                setSize(12, 12);
                offset.x = 2;
                offset.y = 2;

            case Form.CHUTE:
                _form = Form.CHUTE;
                velocity.y = 0;
                acceleration.y = _chuteAcceleration;
                animation.play("chute");
                setSize(16, 9);
                offset.x = 0;
                offset.y = 1;

            default:
                throw "unknown form: " + newForm;
        }
    }
}

enum Form
{
    BLOB;
    BLOCK;
    CHUTE;
}