package;

#if (FLX_DEBUG)
import flixel.system.scaleModes.BaseScaleMode;
import nape.phys.Material;
import flixel.system.debug.watch.Tracker.TrackerProfile;
import system.Settings;
import com.goodidea.util.DataSaver;
#end

import flash.display.MovieClip;
import flash.events.MouseEvent;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.addons.nape.FlxNapeSprite;
import flixel.input.mouse.FlxMouseEventManager;
import haxe.Timer;
import openfl.Assets;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.events.Event;
import system.Images;


class Main extends Sprite {
	var splashScreen:MovieClip;
	
	
	public function new() {
		super();

		/**
		 * WORKS!
		 */
		#if (debug && cpp && USING_VS_DEBUGGER && !telemetry)
		new debugger.HaxeRemote(true, "localhost");
		#end
		
		
		Timer.delay(init, 1000);
	}
	
	
	function init():Void{
		#if android
		
		AdmobController.init();
		
		#end
		

		var w:Int = Lib.current.stage.stageWidth;
		var h:Int = Lib.current.stage.stageHeight;

		
		splashScreen = Assets.getMovieClip("splash:splash_screen");
		splashScreen.height = h;
		splashScreen.scaleX = splashScreen.scaleY;
		splashScreen.x = (w / 2) - (splashScreen.width / 2);
		addChild(splashScreen);
		splashScreen.play();
		
		splashScreen.addEventListener(Event.ENTER_FRAME, splashScreen_enterFrame);


		//Lib.current.stage.addEventListener(MouseEvent.CLICK, menubg_click);
	}
	
	private function splashScreen_enterFrame(e:Event):Void 
	{
		if (splashScreen.currentFrame == splashScreen.totalFrames){
			splashScreen.removeEventListener(Event.ENTER_FRAME, splashScreen_enterFrame);
			startGame();
			
		}
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
		Images.init();

		
		FlxMouseEventManager.init();

		
		//Add custom scalemode
		FlxG.scaleMode = new GameScaleMode();


		//remove menubg
		removeChild(splashScreen);
		splashScreen = null;
		
		
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
