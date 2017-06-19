package display;

import flash.display.DisplayObject;
import flash.events.MouseEvent;
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
	var popup:MovieClip;
	
	public var rainButton:HUDToggleButton;
	public var stickyButton:HUDToggleButton;
	public var refreshButton:HUDButton;
	public var menuButton:HUDButton;
	

	public function new() {
		super();
		
		
		add(rainButton = new HUDToggleButton(0, 0, "assets/images/rain-btn.png", function(btn:HUDToggleButton) {
			trace("cool dude" + btn.on);
			
		}));
		add(stickyButton = new HUDToggleButton(150, 0, "assets/images/sticky-btn.png", function(btn:HUDToggleButton) {
			trace("cool dude");
			
			
			#if android
			trace("showing banner");
			AdmobController.showBanner();
			#end
		}));
		add(refreshButton = new HUDButton(FlxG.width - 300, 0, "assets/images/refresh-btn.png", function(btn:HUDButton) {
			
			#if android
			AdmobController.showInterstitial();
			#end

			Main.clearAdded();
		}));
		
		
		/**
		 * 	TODO: manage popups differently
		 */
		add(menuButton = new HUDButton(FlxG.width - 150, 0, "assets/images/menu-btn.png", function(btn:HUDButton) {
			
			popup = Assets.getMovieClip("splash:settings_modal");
			popup.scaleX = popup.scaleY = FlxG.camera.totalScaleX;
			
			popup.x = (FlxG.stage.stageWidth / 2);
			popup.y = (FlxG.stage.stageHeight / 2);


			//var sfx:Dynamic = cast popup.getChildByName("sfx");

			var closeButton:DisplayObject = popup.getChildByName("close_btn");
			closeButton.addEventListener(MouseEvent.CLICK, closeButton_click);
			
			var p:Dynamic = cast popup;
			var musicSlider:SliderButton = new SliderButton(p.togglers.music.slider, function(b:SliderButton){
				trace("cool " + b.on);
			}, "yes", "no");

			var sfxSlider:SliderButton = new SliderButton(p.togglers.sfx.slider, function(b:SliderButton){
				trace("sfx: " + b.on);
			});
			
			var qualitySlider:SliderButton = new SliderButton(p.togglers.quality.slider, function(b:SliderButton){
				trace("quality: " + b.on);
			});
			

			
			FlxG.state.active = false;
			
			FlxG.stage.addChild(popup);


			#if FLX_DEBUG
				FlxG.console.registerObject("quality", qualitySlider);
			#end
			
			
			
			trace("cool dude");
		}));
	}
	
	@:access(flash.events.MouseEvent)
	private function closeButton_click(e:MouseEvent):Void 
	{
		trace(e);
		FlxG.state.active = true;
		popup.parent.removeChild(popup);
		popup.removeChildren();
		popup = null;
	}
	
	
}