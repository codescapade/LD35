package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.tile.FlxTilemap;
import flixel.util.FlxTimer;

class Player extends FlxSprite
{
    public var form(default, null):Form = Form.BLOB;
    private var _blobAcceleration:Float = 450;
    private var _chuteAcceleration:Float = 40;
    private var _blockAcceleration:Float = 1000;
    private var _wallAcceleration:Float = 30;
    private var _moveSpeed:Float = 120;
    private var _jumpSpeed:Float = 200;

    private var _grounded:Bool = false;
    private var _onWall:Bool = false;
    private var _isJumping:Bool = false;
    private var _wasOnGround:Bool = false;

    

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
        _wasOnGround = _grounded;
        _grounded = false;

        FlxG.collide(this, _gameState.tileGroup, tileCollsion);
        FlxG.collide(this, _gameState.breakableGroup, blockCollision);
        FlxG.collide(this, _gameState.objectGroup, objectCollision);
        FlxG.collide(this, _gameState.endPipe, endPipeCollision);
        FlxG.collide(this, _gameState.doorsGroup);
        FlxG.overlap(this, _gameState.hazardGroup, hazardCollision);
        FlxG.collide(this, _gameState.buttonsGroup, buttonCollision);

        if (Mgr.levelCleared || Mgr.gameOver)
        {
            acceleration.x = acceleration.y = 0;
            velocity.x = velocity.y = 0;
            return;
        }

        if ((form == Form.WALL && !_onWall))
        {
            updateForm(Form.BLOB);
        }

        acceleration.x = 0;

        if (FlxG.keys.justPressed.SPACE)
        {
            if (_grounded && form == Form.BLOB)
            {
                velocity.y = -_jumpSpeed;
                FlxG.sound.play("assets/sounds/BlobJump.mp3", Mgr.sfxVolume);
            }
            else if (form == Form.WALL)
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
                FlxG.sound.play("assets/sounds/BlobJump.mp3", Mgr.sfxVolume);
                _onWall = false;
                updateForm(Form.BLOB);
            }
            else if (form == Form.BLOB)
            {
                updateForm(Form.CHUTE);
                FlxG.sound.play("assets/sounds/BlobChute.mp3", Mgr.sfxVolume);
            }
        }

        if (FlxG.keys.justReleased.SPACE && form == Form.CHUTE)
        {
            updateForm(Form.BLOB);
        }

        if (FlxG.keys.pressed.DOWN)
        {
            updateForm(Form.BLOCK);
        }
        else if (form == Form.BLOCK)
        {
            updateForm(Form.BLOB);
        }

        if (form == Form.BLOB || (form == Form.CHUTE && !_grounded) || form == Form.WALL)
        {
            if (FlxG.keys.pressed.LEFT)
            {
                
                if (form != Form.WALL && _onWall)
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
                
                if (form != Form.WALL && _onWall)
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
        if (_grounded && form == Form.CHUTE)
        {
            acceleration.x = 0;
            velocity.x = 0;
        }
    }

    private function tileCollsion (player:FlxObject, tile:FlxObject):Void
    {
        if (isTouching(FlxObject.FLOOR))
            _grounded = true;

        if (_grounded && !_wasOnGround && form == Form.BLOCK)
        {
            FlxG.sound.play("assets/sounds/blobBlockCrash.mp3", Mgr.sfxVolume);
            FlxG.camera.shake(0.005, 0.2);
        }

        if (FlxG.keys.pressed.LEFT && (isTouching(FlxObject.LEFT) && !_grounded))
        {
            _onWall = true;
        }
        else if (FlxG.keys.pressed.RIGHT && (isTouching(FlxObject.RIGHT) && !_grounded))
        {
            _onWall = true;
        }
    }

    private function blockCollision (player:FlxObject, block:FlxObject):Void
    {
        if (isTouching(FlxObject.FLOOR))
            _grounded = true;

        if (_grounded && !_wasOnGround && form == Form.BLOCK)
        {
            block.kill();
            _grounded = false;
            FlxG.camera.shake(0.005, 0.2);
            FlxG.sound.play("assets/sounds/blobBlockCrash.mp3", Mgr.sfxVolume);

        }

        if (FlxG.keys.pressed.LEFT && (isTouching(FlxObject.LEFT) && !_grounded))
        {
            _onWall = true;
        }
        else if (FlxG.keys.pressed.RIGHT && (isTouching(FlxObject.RIGHT) && !_grounded))
        {
            _onWall = true;
        }
    }

    private function objectCollision (player:FlxObject, object:FlxObject):Void
    {
        if (isTouching(FlxObject.FLOOR))
            _grounded = true;

        if (_grounded && !_wasOnGround && form == Form.BLOCK)
        {
            FlxG.sound.play("assets/sounds/blobBlockCrash.mp3", Mgr.sfxVolume);
            FlxG.camera.shake(0.005, 0.2);
        }
    }

    private function endPipeCollision (player:FlxObject, pipe:FlxObject):Void
    {
        if (player.y < pipe.y && isTouching(FlxObject.FLOOR))
        {
            if (!Mgr.levelCleared)
            {
                Mgr.levelCleared = true;
                immovable = true;
                var clearTimer:FlxTimer = new FlxTimer();
                clearTimer.start(2, levelCleared);
                FlxG.sound.play("assets/sounds/levelComplete.mp3", Mgr.sfxVolume);
            }
        }

        if (_grounded && !_wasOnGround && form == Form.BLOCK)
        {
            //FlxG.sound.play("assets/sounds/blobBlockCrash.mp3", Mgr.sfxVolume);
            FlxG.camera.shake(0.005, 0.2);
        }
    }

    private function hazardCollision (player:FlxObject, hazard:FlxObject):Void
    {
        if (!Mgr.gameOver)
        {
            Mgr.gameOver = true;
            FlxG.camera.follow(null);
            dead();
        }
    }

    private function buttonCollision (player:Player, button:LaserButton):Void
    {
        if (isTouching(FlxObject.FLOOR))
            _grounded = true;

        if (_grounded && !_wasOnGround && form == Form.BLOCK)
        {
            FlxG.camera.shake(0.005, 0.2);
            FlxG.sound.play("assets/sounds/blobBlockCrash.mp3", Mgr.sfxVolume);
        }

        if (button.isTouching(FlxObject.CEILING))
        {
            if (player.form == Form.BLOCK && !_wasOnGround)
            {
                button.updateState("broken");
            }
            else
            {
                button.updateState("pushed");
            }
        }
    }

    private function dead ():Void
    {
        for (i in 0...12)
        {
            var particle:FlxSprite = new FlxSprite(x + width / 2, y + height / 2);
            particle.loadGraphic("assets/images/playerParticles.png", true, 4, 4);
            particle.animation.frameIndex = FlxG.random.int(0, 2);
            particle.velocity.x = FlxG.random.int(-100, 100);
            particle.velocity.y = FlxG.random.int(-80, -150);
            particle.acceleration.y = 200;
            _gameState.add(particle);
        }
        FlxG.sound.play("assets/sounds/BlobDie.mp3", Mgr.sfxVolume);
        visible = false;
        var restartTimer:FlxTimer = new FlxTimer();
        restartTimer.start(5, restart);
    }

    private function updateForm (newForm:Form):Void
    {
        switch (newForm) 
        {
            case Form.BLOB:
                if (form == Form.WALL)
                {
                    if (!flipX)
                    {
                        x -= 6;
                    }
                    y += 6;
                }
                else if (form == Form.BLOCK)
                {
                    y += 3;
                }
                form = Form.BLOB;
                acceleration.y = _blobAcceleration;
                animation.play("blob");
                setSize(14, 9);
                offset.x = 1;
                offset.y = 4;

            case Form.BLOCK:
                if (form == Form.WALL)
                {
                    x -= 4;
                }
                form = Form.BLOCK;
                acceleration.y = _blockAcceleration;
                velocity.x = 0;
                animation.play("block");
                setSize(12, 12);
                offset.x = 2;
                offset.y = 2;

            case Form.CHUTE:
                form = Form.CHUTE;
                velocity.y = 0;
                acceleration.y = _chuteAcceleration;
                animation.play("chute");
                setSize(16, 9);
                offset.x = 0;
                offset.y = 1;

            case Form.WALL:
                if (form == Form.BLOB)
                {
                    if(!flipX)
                        x += 6;
                }
                else if (form == Form.CHUTE)
                {
                    if(!flipX)
                        x += 8;
                }
                form = Form.WALL;
                velocity.y = 0;
                acceleration.y = _wallAcceleration;
                animation.play("wall");
                setSize(8, 14);
                offset.x = 4;
                offset.y = 1;

            default:
                throw "unknown form: " + newForm;
        }
    }

    private function levelCleared (timer:FlxTimer):Void
    {
        FlxG.camera.fade(0xFF000000, 0.5, false, clearFade);
    }

    private function clearFade ():Void
    {
        Mgr.currentLevel += 1;
        if (Mgr.currentLevel <= Mgr.lastLevel)
        {
            FlxG.switchState(new TransitionState());
        }
        else
        {
            FlxG.switchState(new MenuState());
        }
    }

    private function restart (timer:FlxTimer):Void
    {
        FlxG.camera.fade(0xFF000000, 0.5, false, restartLevel);
    }

    private function restartLevel ():Void
    {
        Mgr.lives -= 1;
        if (Mgr.lives < 0)
        {
            FlxG.switchState(new MenuState());
        }
        else
        {
            FlxG.switchState(new TransitionState());
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