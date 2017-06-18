package system;
import display.HUD;
import flixel.addons.nape.FlxNapeSpace;
import nape.geom.Vec2;
import nape.phys.Material;
import nape.space.Space;
import openfl.display.MovieClip;

/**
 * ...
 * @author Jonathan Snyder
 */
class Settings {


	public static var material:Material = new Material(0.3, 0.01, 0.01, 0.0001, 0.0005);
	public static var space:Space;
	public static var menu:MovieClip;
	public static var gravity:Vec2 = Vec2.get(0, 5000);
	public static var hud:HUD;
	public static var interationAmount(default, set):Int = 5;
	
	public static function togglePhysics(pause:Bool = true):Void {
		if (pause) {
			FlxNapeSpace.space = null;
		} else {
			FlxNapeSpace.space = space;
		}
	}
	
	static function set_interationAmount(value:Int):Int {
		FlxNapeSpace.velocityIterations = FlxNapeSpace.positionIterations = value;
		return interationAmount = value;
	}
}


class DrawSettings {
	public static var quality:Int = 2;
	public static var simplification:Float = 2.5;
}