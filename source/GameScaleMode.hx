package;

import flixel.FlxG;
import flixel.system.scaleModes.BaseScaleMode;

/**
 * ...
 * @author Jonathan Snyder
 */
class GameScaleMode extends BaseScaleMode {

	private var fillScreen:Bool;
	
	/**
	 * @param fillScreen Whether to cut the excess side to fill the
	 * screen or always display everything.
	 */
	public function new(fillScreen:Bool = false) {
		super();
		this.fillScreen = fillScreen;
	}
	
	override private function updateGameSize(Width:Int, Height:Int):Void {
		var ratio:Float = FlxG.width / FlxG.height;
		var realRatio:Float = Width / Height;
		
		var scaleY:Bool = realRatio < ratio;
		if (fillScreen) {
			scaleY = !scaleY;
		}
		
		if (scaleY) {
			gameSize.x = Width;
			gameSize.y = Math.floor(gameSize.x / ratio);
		}
		else {
			gameSize.y = Height;
			gameSize.x = Math.floor(gameSize.y * ratio);
			
			if (FlxG.camera != null) {
				FlxG.camera.setSize(Std.int(Width / scale.x), Std.int(Height / scale.y));
			}
		}
	}

	
}