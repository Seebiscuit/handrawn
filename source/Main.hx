package;

#if (FLX_DEBUG)
import flixel.system.scaleModes.BaseScaleMode;
import nape.phys.Material;
import flixel.system.debug.watch.Tracker.TrackerProfile;
import system.Settings;
import com.goodidea.util.DataSaver;
#end

import display.UIMovieClip;
import flash.display.MovieClip;
import flash.events.MouseEvent;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import flixel.addons.nape.FlxNapeSprite;
import flixel.input.mouse.FlxMouseEventManager;
import haxe.Timer;
import openfl.Assets;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.events.Event;
import system.Images;
import system.Audio;


class Main extends Sprite {
	var splashScreen:MovieClip;
	var mainMenu:UIMovieClip;
	
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
	
	
	function init():Void {
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
		
		
		FlxG.signals.gameStarted.addOnce(function() {
			trace("game started");
		});

		FlxG.signals.postDraw.addOnce(function() {
			trace("post draw");
		});

		FlxG.signals.postUpdate.addOnce(function() {
			trace("post update");
		});

		FlxG.signals.preDraw.addOnce(function() {
			trace("predraw");
		});

		FlxG.signals.preUpdate.addOnce(function() {
			trace("preupdate");
		});

		FlxG.signals.preStateCreate.addOnce(function(s:FlxState) {
			trace("state create pre");
		});

		//Lib.current.stage.addEventListener(MouseEvent.CLICK, menubg_click);
	}
	
	private function splashScreen_enterFrame(e:Event):Void {
		if (splashScreen.currentFrame == splashScreen.totalFrames) {
			splashScreen.stop();
			splashScreen.removeEventListener(Event.ENTER_FRAME, splashScreen_enterFrame);
			//startGame();
			showMenu();
		}
	}
	
	function showMenu() {
		mainMenu = new UIMovieClip("main_menu", "splash");
		mainMenu.mc.height = Lib.current.stage.stageHeight;
		mainMenu.mc.scaleX = mainMenu.mc.scaleY;
		mainMenu.currentFrame = 2;
		removeChild(splashScreen);
		addChild(mainMenu.mc);
		mainMenu.playFromTo(1, mainMenu.mc.totalFrames, function(ui) {
			trace("played it");
			mainMenu.playFromTo(mainMenu.mc.currentFrame, 1, function(ui) {
				removeChild(mainMenu.mc);
				startGame();
			});
		});
		
		
		var playButton:MovieClip = cast mainMenu.dynamicMC.buttons.play_btn;
		playButton.addEventListener(MouseEvent.CLICK, playButton_click);
	}
	
	private function playButton_click(e:MouseEvent):Void {
		trace("play game");
		startGame();
	}
	
	
	/**
	 * Starts the game
	 */
	private function startGame():Void {


		addChild(new FlxGame(1920, 1080, MenuState, 1, 60, 60, true, false));
		Images.init();
		Audio.init();
		
		
		//Start Music
		FlxG.sound.playMusic("assets/music/track1.ogg");

		
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
