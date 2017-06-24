package display;

import flixel.FlxSprite;
import flixel.addons.nape.FlxNapeSpace;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.math.FlxAngle;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Polygon;
import system.Settings;

/**
 * ...
 * @author Jonathan Snyder
 */
class HUDButton extends FlxSprite {
	
	
	var onClick:HUDButton -> Void;
	
	var pressed:Bool;
	
	var body:Body;
	
	var size:Int = 150;

	public function new(?X:Float = 0, ?Y:Float = 0, ?SimpleGraphic:FlxGraphicAsset, ?OnClick:HUDButton -> Void, ?On:Bool) {
		super(X, Y, SimpleGraphic);
		
		addButtonBody(X, Y);
		
		setSize(size, size);
		draw();
		centerOffsets(false);
		
		
		this.onClick = OnClick;
		
		//offset.set(_halfSize.x, _halfSize.y);
		//x -= _halfSize.x;
		//y -= _halfSize.y;
		
		
		FlxMouseEventManager.add(this, _down, _up, _over, _out, false, true, false);
	}
	
	
	function _down(obj:HUDButton):Void {
		pressed = true;
	}
	
	function _up(obj:HUDButton):Void {
		if (pressed) {
			pressed = false;
			
			if (onClick != null) {
				onClick(obj);
			}
		}
		
		_out(obj);
	}
	
	function _over(obj:HUDButton):Void {
		var ops:TweenOptions = {};
		ops.ease = FlxEase.circOut;
		// ops.onUpdate = function(t:FlxTween) this.updateHitbox();
		FlxTween.num(1, 1.5, .3, ops, function(f:Float) {
			this.scale.x = this.scale.y = f;
		});
	}
	
	function _out(obj:HUDButton):Void {
		var ops:TweenOptions = {};
		ops.ease = FlxEase.circOut;
		// ops.onUpdate = function(t:FlxTween) this.updateHitbox();
		FlxTween.num(1.5, 1, .3, ops, function(f:Float) {
			this.scale.x = this.scale.y = f;
		});
	}
	
	
	override public function update(elapsed:Float):Void {
		
		if (Settings.space != null) {
			angle += (((Settings.space.gravity.angle * FlxAngle.TO_DEG) - 90) - angle) / 8;
		}
		
		
		super.update(elapsed);
	}
	
	function addButtonBody(X:Float, Y:Float) {
		var pos = size / 2;
		body = new Body(BodyType.KINEMATIC);
		body.shapes.add(new Polygon(Polygon.box(size, size)));
		body.position.setxy(X + pos, Y + pos);
		FlxNapeSpace.space.bodies.add(body);
	}
}