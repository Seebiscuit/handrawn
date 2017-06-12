package display;

import com.goodidea.util.NapeUtil;
import flixel.addons.nape.FlxNapeSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import system.Settings;

/**
 * Automagically creates a body based on the sprite's graphic
 * Graphic must be non null
 * @author Jonathan Snyder
 */
class AutoNapeSprite extends FlxNapeSprite {

	public function new(X:Float = 0.0, Y:Float = 0.0, SimpleGraphic:FlxGraphicAsset, Granularity:Int = 8, EnablePhysics:Bool = true, Kinematic:Bool=false) {
		
		super(X, Y, SimpleGraphic, false, EnablePhysics);
		
		var b:Body = NapeUtil.bitmapToBody(pixels, Granularity, DrawSettings.quality, DrawSettings.simplification);
		var o:Vec2 = b.userData.graphicOffset;
		
		x += o.x;
		y += o.y;
		
		if (Kinematic){
			b.type = BodyType.KINEMATIC;
		}
		
		
		/**
		 * create a body based off pixels
		 */
		addPremadeBody(b);
		
		
		origin.set(o.x, o.y);
		
		
		body.setShapeMaterials(Settings.material);
	}
	
	override public function destroyPhysObjects():Void {
		if (body != null) {
			body.space = null;
		}
	}
	
	override public function destroy():Void {
		super.destroy();
	}
	
}