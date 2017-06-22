package test;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.util.FlxDestroyUtil.IFlxDestroyable;

/**
 * ...
 * @author Jonathan Snyder
 */
class CannonSprite extends FlxSpriteGroup {
	private var _turnSpeed(default, null):Float = .2;
	
	public var base:FlxSprite;
	public var gun:FlxSprite;

	public function new() {
		super();
		add(base = new FlxSprite(0, 70, "assets/images/game-play-simple-assets/images/hi-def/cannon-base.png"));
		add(gun = new FlxSprite(0, 0, "assets/images/game-play-simple-assets/images/hi-def/cannon-gun.png"));
		
		gun.origin.set(40, 40);
		
		
		#if FLX_DEBUG
		
		FlxG.watch.add(this, "_turnSpeed");
		
		#end
		
	}
	
	
	override public function update(elapsed:Float):Void {
		
		
		#if FLX_KEYBOARD
		
		if (FlxG.keys.pressed.LEFT) {
			gun.angle = FlxMath.bound(gun.angle - _turnSpeed, -215, 30);
		}
		
		if (FlxG.keys.pressed.RIGHT) {
			gun.angle = FlxMath.bound(gun.angle + _turnSpeed, -215, 30);
		}
		
		#end
		
		
		super.update(elapsed);
		
		
	}
	
	
}

