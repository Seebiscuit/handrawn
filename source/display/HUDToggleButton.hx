package display;

import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Jonathan Snyder
 */
class HUDToggleButton extends HUDButton {
	
	public var on(default, set):Bool = false;
	var toggleClick:HUDToggleButton -> Void;

	function set_on(value:Bool):Bool {
		alpha = value ? 1 : .2;
		return on = value;
	}
	

	public function new(?X:Float = 0, ?Y:Float = 0, ?SimpleGraphic:FlxGraphicAsset, ?OnClick:HUDToggleButton -> Void, ?On:Bool) {
		toggleClick = OnClick;
		
		super(X, Y, SimpleGraphic, function(btn:HUDButton) {
			on = !on;
			
			if (toggleClick != null) {
				toggleClick(this);
			}
			
			
		}, On);
		
		set_on(false);
	}
	
}