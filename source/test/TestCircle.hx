package test;

import flixel.addons.nape.FlxNapeSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import nape.phys.Body;
import nape.shape.Circle;

/**
 * ...
 * @author Jonathan Snyder
 */
class TestCircle extends FlxNapeSprite {
	public var _shape:Circle;

	public function new(X:Float = 0, Y:Float = 0) {
		super(X, Y, "assets/images/ball.png", false, false);
		
		_shape = new Circle(width / 2);
		var b:Body = new Body();
		b.shapes.add(_shape);
		
		addPremadeBody(b);
		
		physicsEnabled = true;
		
		//makeGraphic
	}
	
}