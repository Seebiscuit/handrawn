package display;
import haxe.Constraints.Function;
import openfl.events.MouseEvent;


/**
 * ...
 * @author Jonathan Snyder
 */
class UIButton extends UIMovieClip {
	
	
	public var OnClick:Function;
	public var OnClickParams:Array<Dynamic>;
	
	
	public function new(AssetName:Dynamic, ?LibraryName:String, ?onClick:Function, ?onClickParams:Array<Dynamic>) {
		super(AssetName, LibraryName);
		
		OnClick = onClick;
		OnClickParams = onClickParams;
		
		
		addListeners();
	}
	
	
	/**
	 * Add event listeners
	 */
	private function addListeners() {
		mc.addEventListener(MouseEvent.ROLL_OVER, mc_mouseOver, false, 0, true);
		mc.addEventListener(MouseEvent.MOUSE_DOWN, mc_mouseDown, false, 0, true);
		mc.addEventListener(MouseEvent.MOUSE_UP, mc_mouseUp, false, 0, true);
		mc.addEventListener(MouseEvent.ROLL_OUT, mc_mouseOut, false, 0, true);
		
		
		mc.addEventListener(MouseEvent.CLICK, mc_click, false, 0, true);
	}
	
	private function mc_mouseOver(e:MouseEvent):Void {
		trace("over");
		playLabel("hover");
	}
	
	
	private function mc_mouseDown(e:MouseEvent):Void {
		trace("down");
		playLabel("down");
	}
	
	private function mc_mouseUp(e:MouseEvent):Void {
		trace("up");
		playLabel("up");
		
		#if !desktop
		
		mc_mouseOut(e);
		
		#end
	}
	
	
	private function mc_mouseOut(e:MouseEvent):Void {
		trace("out");
		playLabel("out");
	}
	
	
	private function mc_click(e:MouseEvent):Void {
		trace("click");

		
		if (OnClick != null) {
			Reflect.callMethod(this, OnClick, OnClickParams);
		}
	}
	
	
}