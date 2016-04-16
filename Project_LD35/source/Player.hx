package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.tile.FlxTilemap;

class Player extends FlxSprite
{
    private var _blobAcceleration:Float = 450;
    private var _chuteAcceleration:Float = 40;
    private var _blockAcceleration:Float = 1000;
    private var _wallAcceleration:Float = 30;
    private var _moveSpeed:Float = 120;
    private var _jumpSpeed:Float = 200;

    private var _grounded:Bool = false;
    private var _onWall:Bool = false;
    private var _isJumping:Bool = false;

    private var _form:Form = Form.BLOB;

    private var _gameState:PlayState;

    public function new (x:Float, y:Float, state:PlayState):Void
    {
        super(x, y);
        _gameState = state;
        loadGraphic("assets/images/player.png", true, 16, 16);
        animation.add("blob", [0]);
        animation.add("block", [1]);
        animation.add("chute", [2]);
        animation.add("wall", [3]);

        updateForm(Form.BLOB);
        animation.play("blob");

        setSize(14, 9);
        centerOffsets();
        maxVelocity.x = 100;
        acceleration.y = _blobAcceleration;
    }

    override public function update (elapsed:Float):Void
    {

        super.update(elapsed);
        _onWall = false;
        _grounded = false;
        FlxG.collide(this, _gameState.tileGroup, tileCollsion);
        if ((_form == Form.WALL && !_onWall))
        {
            updateForm(Form.BLOB);
        }

        acceleration.x = 0;

        if (FlxG.keys.justPressed.SPACE)
        {
            if (_grounded && _form == Form.BLOB)
            {
                velocity.y = -_jumpSpeed;
            }
            else if (_form == Form.WALL)
            {
                velocity.y = -_jumpSpeed;
                if (flipX)
                {
                    velocity.x = _jumpSpeed;
                }
                else
                {
                    velocity.x = -_jumpSpeed;
                }
                _onWall = false;
                updateForm(Form.BLOB);
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

        if (_form == Form.BLOB || (_form == Form.CHUTE && !_grounded) || _form == Form.WALL)
        {
            if (FlxG.keys.pressed.LEFT)
            {
                
                if (_form != Form.WALL && _onWall)
                {
                    updateForm(Form.WALL);
                }

                flipX = true;
                if (velocity.x > 0)
                {
                    acceleration.x = -_moveSpeed * 4;
                }
                else
                {
                    acceleration.x = -_moveSpeed;
                }
            }
            else if (FlxG.keys.pressed.RIGHT)
            {
                
                if (_form != Form.WALL && _onWall)
                {
                    updateForm(Form.WALL);
                }

                flipX = false;
                if (velocity.x < 0)
                {
                    acceleration.x = _moveSpeed * 4;
                }
                else
                {
                    acceleration.x = _moveSpeed;
                }
            }
            else
            {
                if (velocity.x > 10)
                {
                    acceleration.x = -_moveSpeed * 2;
                }
                else if (velocity.x < -10)
                {
                    acceleration.x = _moveSpeed * 2;
                }
                else
                {
                    velocity.x = 0;
                }
            }
        }
        trace(_onWall);
    }

    private function tileCollsion (player:FlxObject, tile:FlxObject):Void
    {
        if (isTouching(FlxObject.FLOOR))
            _grounded = true;

        if (FlxG.keys.pressed.LEFT && (isTouching(FlxObject.LEFT) && !_grounded))
        {
            _onWall = true;
        }
        else if (FlxG.keys.pressed.RIGHT && (isTouching(FlxObject.RIGHT) && !_grounded))
        {
            _onWall = true;
        }
    }

    private function updateForm (newForm:Form):Void
    {
        switch (newForm) 
        {
            case Form.BLOB:
                if (_form == Form.WALL)
                {
                    if (!flipX)
                    {
                        x -= 6;
                    }
                    y += 6;
                }
                else if (_form == Form.BLOCK)
                {
                    y += 3;
                }
                _form = Form.BLOB;
                acceleration.y = _blobAcceleration;
                animation.play("blob");
                setSize(14, 9);
                offset.x = 1;
                offset.y = 4;

            case Form.BLOCK:
                if (_form == Form.WALL)
                {
                    x -= 4;
                }
                _form = Form.BLOCK;
                acceleration.y = _blockAcceleration;
                velocity.x = 0;
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

            case Form.WALL:
                _form = Form.WALL;
                velocity.y = 0;
                acceleration.y = _wallAcceleration;
                animation.play("wall");
                setSize(8, 14);
                offset.x = 4;
                offset.y = 1;
                if(!flipX)
                    x += 6;

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
    WALL;
}