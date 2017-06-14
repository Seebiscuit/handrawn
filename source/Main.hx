package;

#if (FLX_DEBUG)
import flixel.system.scaleModes.BaseScaleMode;
import nape.phys.Material;
import flixel.system.debug.watch.Tracker.TrackerProfile;
import system.Settings;
import com.goodidea.util.DataSaver;
#end

import flash.display.Bitmap;
import flash.display.PixelSnapping;
import flash.events.MouseEvent;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.addons.nape.FlxNapeSprite;
import flixel.input.mouse.FlxMouseEventManager;
import openfl.Assets;
import openfl.Lib;
import openfl.display.Sprite;
import system.Images;


class Main extends Sprite {
	var menubg:Bitmap;
	
	
	public function new() {
		super();
		
		
		#if android
		
		AdmobController.init();
		
		#end
		

		var w:Int = Lib.current.stage.stageWidth;
		var h:Int = Lib.current.stage.stageHeight;

		
		menubg = new Bitmap(Assets.getBitmapData("assets/images/main_menu-assets/images/hi-def/menu-bg.jpg"), PixelSnapping.AUTO, true);
		addChild(menubg);
		menubg.width = w;
		menubg.scaleY = menubg.scaleX;
		menubg.x = (w / 2) - (menubg.width / 2);
		menubg.y = (h / 2) - (menubg.height / 2);


		Lib.current.stage.addEventListener(MouseEvent.CLICK, menubg_click);
	}
	
	
	//Click to start game
	private function menubg_click(e:MouseEvent):Void {
		Lib.current.stage.removeEventListener(MouseEvent.CLICK, menubg_click);
		trace("ok start game");
		startGame();
	}
	
	
	/**
	 * Starts the game
	 */
	private function startGame():Void {
		
		
		addChild(new FlxGame(1920, 1080, MenuState, 1, 60, 60, true, false));
		
		
		FlxMouseEventManager.init();
		Images.init();
		
		
		//Add custom scalemode
		FlxG.scaleMode = new GameScaleMode();


		//remove menubg
		removeChild(menubg);
		menubg.bitmapData.dispose();
		menubg = null;
		
		
		#if (FLX_DEBUG && windows)
		
		FlxG.console.registerClass(Settings);
		FlxG.console.registerClass(DataSaver);
		FlxG.console.registerClass(Main);
		FlxG.debugger.addTrackerProfile(new TrackerProfile(BaseScaleMode, ['deviceSize', 'gameSize', 'scale', 'offset', 'horizontalAlign', 'verticalAlign']));
		FlxG.debugger.addTrackerProfile(new TrackerProfile(Material, ['elasticity', 'dynamicFriction', 'staticFriction', 'density', 'rollingFriction']));
		#end
	}


	public static function clearAdded():Void {
		FlxG.state.forEachOfType(FlxNapeSprite, function(s:FlxNapeSprite) s.destroy());
	}
}
