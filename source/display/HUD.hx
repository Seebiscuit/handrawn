package display;

import flixel.FlxG;
import flixel.group.FlxGroup;

/**
 * ...
 * @author Jonathan Snyder
 */
class HUD extends FlxGroup {
	
	public var rainButton:HUDToggleButton;
	public var stickyButton:HUDToggleButton;
	public var refreshButton:HUDButton;
	public var menuButton:HUDButton;
	

	public function new() {
		super();
		
		
		add(rainButton = new HUDToggleButton(0, 0, "assets/images/rain-btn.png", function(btn:HUDToggleButton) {
			trace("cool dude" + btn.on);
			
			#if android
			AdmobController.showInterstitial();
			#end
		}));
		add(stickyButton = new HUDToggleButton(150, 0, "assets/images/sticky-btn.png", function(btn:HUDToggleButton) {
			trace("cool dude");
			#if android
			AdmobController.showBanner();
			#end
		}));
		add(refreshButton = new HUDButton(FlxG.width - 300, 0, "assets/images/refresh-btn.png", function(btn:HUDButton) {
			Main.clearAdded();
		}));
		add(menuButton = new HUDButton(FlxG.width - 150, 0, "assets/images/menu-btn.png", function(btn:HUDButton) {
			trace("cool dude");
		}));
	}
	
	
}