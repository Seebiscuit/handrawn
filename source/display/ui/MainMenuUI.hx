package display.ui;


class MainMenuUI extends UIMovieClip {
	
	public var settingsButton:UIButton;
	public var playButton:UIButton;

	public function new() {
		super("main_menu", "library");
		
		
		settingsButton = new UIButton(dynamicMC.buttons.options_btn, null, function() {
			trace("clicking");
		});
		
		
		playButton = new UIButton(dynamicMC.buttons.play_btn, null, function() {
			trace("play the game");
		});

	}
	
}