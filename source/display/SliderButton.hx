package display;

import flash.text.TextField;
import openfl.events.MouseEvent;


/**
 * ...
 * @author Jonathan Snyder
 */
class SliderButton extends UIMovieClip {

	public var onClick:SliderButton -> Void;
	
	public var on(default, set):Bool;


	public function new(mc:Dynamic, ?OnClick:SliderButton -> Void, on:String = "on", off:String = "off") {
		super(mc, "library");
		
		onClick = OnClick;
		
		var onTF:TextField = cast dynamicMC.on_txt.txt;
		var offTF:TextField = cast dynamicMC.off_txt.txt;
		
		onTF.text = on;
		
		onTF.text = on.toUpperCase();
		offTF.text = off.toUpperCase();
		
		
		//stopAtLabel("off");
		addListeners();
	}
	
	
	/**
	 * Add event listeners
	 */
	private function addListeners() {
		//mc.addEventListener(MouseEvent.ROLL_OVER, mc_mouseOver, false, 0, true);
		//mc.addEventListener(MouseEvent.MOUSE_DOWN, mc_mouseDown, false, 0, true);
		//mc.addEventListener(MouseEvent.MOUSE_UP, mc_mouseUp, false, 0, true);
		//mc.addEventListener(MouseEvent.ROLL_OUT, mc_mouseOut, false, 0, true);
		
		
		mc.addEventListener(MouseEvent.CLICK, mc_click, false, 0, true);
	}
	
	
	private function mc_click(e:MouseEvent):Void {
		trace("click");
		
		on = !on;

		
		if (onClick != null) {
			onClick(this);
		}
	}
	
	function set_on(value:Bool):Bool {
		if (value) {
			playLabel("on");
		} else {
			playLabel("off");
		}
		
		return on = value;
	}
	
}