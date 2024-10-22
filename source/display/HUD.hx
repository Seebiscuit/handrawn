package display;

#if android
import system.AdmobController;
#end

import flash.display.DisplayObject;
import flash.display.StageQuality;
import flash.events.MouseEvent;
import system.Images;

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
		
		
		add(rainButton = new HUDToggleButton(0, 0, Images.getPath("rain-btn"), function(btn:HUDToggleButton) {
			trace("cool dude" + btn.on);
			
		}));
		add(stickyButton = new HUDToggleButton(150, 0, Images.getPath("sticky-btn"), function(btn:HUDToggleButton) {
			trace("cool dude");
			#if android
			trace("showing banner");
			AdmobController.showBanner();
			#end
		}));
		add(refreshButton = new HUDButton(FlxG.width - 300, 0, Images.getPath("refresh-btn"), function(btn:HUDButton) {
			
			#if android
			AdmobController.showInterstitial();
			#end

			Main.clearAdded();
		}));
		
		
		/**
		 * 	TODO: manage popups differently
		 */
		add(menuButton = new HUDButton(FlxG.width - 150, 0, Images.getPath("menu-btn"), function(btn:HUDButton) {
			
			popup = Assets.getMovieClip("library:settings_modal");
			popup.height = FlxG.stage.stageHeight;
			popup.scaleX = popup.scaleY;
			//popup.scaleX = popup.scaleY = FlxG.camera.totalScaleX;
			
			popup.x = (FlxG.stage.stageWidth / 2);
			popup.y = (FlxG.stage.stageHeight / 2);
			
			
			//var sfx:Dynamic = cast popup.getChildByName("sfx");

			var closeButton:DisplayObject = popup.getChildByName("close_btn");
			closeButton.addEventListener(MouseEvent.CLICK, closeButton_click);
			
			var p:Dynamic = cast popup;

			var musicSlider:SliderButton = new SliderButton(p.togglers.music.slider, function(b:SliderButton) {
				trace("cool " + b.on);
				FlxG.sound.defaultMusicGroup.volume = b.on ? 1 : 0;
			}, "yes", "no");

			var sfxSlider:SliderButton = new SliderButton(p.togglers.sfx.slider, function(b:SliderButton) {
				trace("sfx: " + b.on);
				FlxG.sound.defaultSoundGroup.volume = b.on ? 1 : 0;
			}, "yes", "no");
			
			var qualitySlider:SliderButton = new SliderButton(p.togglers.quality.slider, function(b:SliderButton) {
				trace("quality: " + b.on);
				FlxG.stage.quality = b.on ? StageQuality.HIGH : StageQuality.LOW;
				FlxG.camera.antialiasing = b.on;
			}, "high", "low");


			musicSlider.on = FlxG.sound.defaultMusicGroup.volume != 0;
			sfxSlider.on = FlxG.sound.defaultSoundGroup.volume != 0;
			qualitySlider.on = FlxG.camera.antialiasing;

			var adButton:MovieClip = cast p.remove_ad_btn;
			adButton.addEventListener(MouseEvent.CLICK, adButton_click);

			
			FlxG.state.active = false;
			
			FlxG.stage.addChild(popup);


			#if FLX_DEBUG
			FlxG.console.registerObject("quality", qualitySlider);
			#end
			
			
			trace("cool dude");
		}));
	}
	
	private function adButton_click(e:MouseEvent):Void {
		FlxG.openURL("http://www.google.com");
	}
	
	@:access(flash.events.MouseEvent)
	private function closeButton_click(e:MouseEvent):Void {
		trace(e);
		FlxG.state.active = true;
		popup.parent.removeChild(popup);
		popup.removeChildren();
		popup = null;
	}
	
	
}