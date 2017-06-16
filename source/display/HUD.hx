package display;

#if android
import extension.admob.AdMob;
#end

import flash.display.MovieClip;
import flixel.FlxG;
import flixel.group.FlxGroup;
import openfl.Assets;

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
			trace("showing banner");
			AdmobController.showBanner();
			#end
		}));
		add(refreshButton = new HUDButton(FlxG.width - 300, 0, "assets/images/refresh-btn.png", function(btn:HUDButton) {
			Main.clearAdded();
		}));
		
		
		
		add(menuButton = new HUDButton(FlxG.width - 150, 0, "assets/images/menu-btn.png", function(btn:HUDButton) {
			
			var popup:MovieClip = Assets.getMovieClip("splash:settings_modal");
			popup.scaleX = popup.scaleY = FlxG.camera.totalScaleX;
			
			popup.x = (FlxG.stage.stageWidth / 2) - (popup.width / 2);
			popup.y = (FlxG.stage.stageHeight / 2) - (popup.height / 2);
			
			FlxG.stage.addChild(popup);
			
			
			
			trace("cool dude");
		}));
	}
	
	
}