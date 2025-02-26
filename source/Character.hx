import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.tweens.FlxTween;

class Character extends FlxSprite
{
    public function new(){
        antialiasing = true;
        super(0,0);
    }

    public function playAnimation(name:String, fps:Float, ?thewidth = 768):Void{
        frames = FlxAtlasFrames.fromSparrow('assets/images/$name.png', 'assets/images/$name.xml');
		animation.addByPrefix('idle', 'idle', 4);
		animation.play('idle');
        setGraphicSize(Std.int(thewidth * .5));
        updateHitbox();
    }

    public function walk(distance:Float, prefix:String, time:Float):Void{
        var preflip = flipX;

        if(distance > 0) flipX = false; else flipX = true;
        
        playAnimation(prefix + 'walk', 2);

        FlxTween.tween(this, {x: this.x + distance}, time, {onComplete: function(f):Void{
            flipX = preflip;
        }});
    }
}