package system;
import display.UIMovieClip;
import display.ui.MainMenuUI;

/**
 * ...
 * @author Jonathan Snyder
 */
class UI {
	
	
	public static var splash:UIMovieClip;
	public static var main_menu:MainMenuUI;
	
	public static var popupContainer:UIMovieClip;
	public static var popupSettings:UIMovieClip;
	public static var popupInfo:UIMovieClip;


	public static function init():Void {
		splash = new UIMovieClip("splash_screen", "library");
		main_menu = new MainMenuUI();
	}
	
}