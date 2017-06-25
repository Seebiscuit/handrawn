package;

#if (FLX_DEBUG)
import flixel.system.scaleModes.BaseScaleMode;
import nape.phys.Material;
import flixel.system.debug.watch.Tracker.TrackerProfile;
import system.Settings;
import com.goodidea.util.DataSaver;
#end

#if android
import system.AdmobController;
import extension.wakeLock.WakeLock;
#end


import display.UIMovieClip;
import display.ui.MainMenuUI;
import flash.display.MovieClip;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import flixel.addons.nape.FlxNapeSprite;
import flixel.util.FlxDestroyUtil;
import haxe.Timer;
import openfl.Lib;
import openfl.display.Sprite;
import system.Images;
import system.Audio;
import system.Navigation;
import system.Signals;
import system.UI;


class Main extends Sprite {
	
	/**
	 * For Correct aspect ratio sizing
	 * of different devices
	 */
	var gameWidth:Int = 1920; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var gameHeight:Int = 1080; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var initialState:Class<FlxState> = MenuState; // The FlxState the game starts with.
	var zoom:Float = -1; // If -1, zoom is automatically calculated to fit the window dimensions.
	var framerate:Int = 60; // How many frames per second the game should run at.
	var skipSplash:Bool = true; // Whether to skip the flixel splash screen that appears in release mode.
	var startFullscreen:Bool = false; // Whether to start the game in fullscreen on desktop targets
	
	
	var splashScreen:MovieClip;
	var mainMenu:MainMenuUI;
	var w:Int = 0;
	var h:Int = 0;

	
	/**
	 * Setup function for android
	 * Init Admob and Keep screen awake
	 * If applicable
	 */
	#if android

	function setupForAndroid() {
		// Initiate Admob when applicable
		AdmobController.init();

		/**
		 * Keep screen on if running mobile
		 * TODO: Doesn't seem to be working anymore
		 */
		WakeLock.setKeepScreenOn();
	}
	#end
	
	
	/**
	 * Base Point
	 */
	public function new() {
		super();

		/**
		 * Create a new Debugger if debugging CPP
		 */
		#if (debug && cpp && USING_VS_DEBUGGER && !telemetry)
		new debugger.HaxeRemote(true, "localhost");
		#end
		
		
		/**
		 * Add a delay to initialization due
		 * to an issue with immersive mode
		 */
		Timer.delay(init, 1000);
	}
	
	
	/**
	 * Initialize Game
	 */
	function init():Void {
		//screen dimensions
		w = Lib.current.stage.stageWidth;
		h = Lib.current.stage.stageHeight;
		
		
		#if android
		setupForAndroid();
		#end
		
		
		//Init UI
		UI.init();
		Images.init();
		

		//TODO: handle differently in a splash class
		// Show the Splash Screen, then the Main Menu
		splashScreen = UI.splash.mc;
		splashScreen.height = h;
		splashScreen.scaleX = splashScreen.scaleY;
		splashScreen.x = (w / 2) - (splashScreen.width / 2);
		UI.splash.currentFrame = 2;
		addChild(splashScreen);
		UI.splash.playFromTo(1, splashScreen.totalFrames, function(m) {
			showMenu();
		});
	}


	/**
	 * TODO: clean up
	 * Show the main menu
	 */
	function showMenu() {
		mainMenu = UI.main_menu;
		mainMenu.mc.height = Lib.current.stage.stageHeight;
		mainMenu.mc.scaleX = mainMenu.mc.scaleY;
		mainMenu.mc.x = (w / 2) - (mainMenu.mc.width / 2);
		mainMenu.currentFrame = 2;
		addChild(mainMenu.mc);
		mainMenu.playLabel("show");
		UI.splash = FlxDestroyUtil.destroy(UI.splash);
		
		UI.main_menu.playButton.OnClick = playButton_click;
		
		//var playButton:MovieClip = cast mainMenu.dynamicMC.buttons.play_btn;
		//playButton.addEventListener(MouseEvent.CLICK, playButton_click);
	}
	
	/**
	 * Play Button Click
	 */
	private function playButton_click():Void {
		trace("play game");
		mainMenu.playLabel("hide", function(mc:UIMovieClip) {
			startGame();
		});
	}
	
	
	/**
	 * Starts the game
	 */
	private function startGame():Void {

		
		/**
		 * Adjust aspect ratio of initial game size to that
		 * of the device
		 * Still keeps the sizing the same, but adjusts to give space
		 */
		if (zoom == -1) {
			var ratioX:Float = w / gameWidth;
			var ratioY:Float = h / gameHeight;
			zoom = Math.min(ratioX, ratioY);
			gameWidth = Math.ceil(w / zoom);
			gameHeight = Math.ceil(h / zoom);
		}
		addChild(new FlxGame(gameWidth, gameHeight, initialState, 1, framerate, framerate, skipSplash, startFullscreen));
		
		//Init Signals
		Signals.init();
		
		//Init Audio
		Audio.init();

		
		//Start Music
		Audio.music.volume = 0;
		Audio.music.fadeIn();
		Audio.music.play();

		
		/**
		 * Init Navigation
		 */
		Navigation.init();

		
		//Add custom scalemode
		FlxG.scaleMode = new GameScaleMode();


		//destroy main menu
		mainMenu = FlxDestroyUtil.destroy(mainMenu);
		
		
		#if (FLX_DEBUG && windows)
		FlxG.console.registerClass(Settings);
		FlxG.console.registerClass(DataSaver);
		FlxG.console.registerClass(Main);
		FlxG.console.registerClass(Images);
		FlxG.console.registerClass(Settings);
		FlxG.console.registerClass(Signals);
		
		FlxG.debugger.addTrackerProfile(new TrackerProfile(BaseScaleMode, ['deviceSize', 'gameSize', 'scale', 'offset', 'horizontalAlign', 'verticalAlign']));
		FlxG.debugger.addTrackerProfile(new TrackerProfile(Material, ['elasticity', 'dynamicFriction', 'staticFriction', 'density', 'rollingFriction']));
		#end
	}


	/**
	 * Remove all physics objects the user has created
	 */
	public static function clearAdded():Void {
		FlxG.state.forEachOfType(FlxNapeSprite, function(s:FlxNapeSprite) s.destroy());
	}
}
