package display;

import flixel.FlxG;
import flixel.addons.nape.FlxNapeSprite;
import flixel.util.FlxColor;
import nape.phys.Body;
import nape.shape.Circle;
import system.Settings;

/**
 * ...
 * @author Jonathan Snyder
 */
class CircleNapeSprite extends FlxNapeSprite {

	public function new(X:Float = 0, Y:Float = 0) {
		super(X, Y, "assets/images/game-play-simple-assets/images/hi-def/rain-circle.png", false, false);
		
		var c:Circle = new Circle(width / 2);
		addPremadeBody(new Body());
		body.shapes.add(c);
		physicsEnabled = true;
		
		//if (Settings.material != null){
		c.material = Settings.material;
		//}
		
		color = FlxG.random.color(FlxColor.WHITE, FlxColor.GRAY);
		
		body.surfaceVel.x = 1;
		//body.disableCCD = true;
	}
	
}