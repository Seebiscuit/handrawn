package display;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.tweens.misc.NumTween;
import haxe.Constraints.Function;
import openfl.events.MouseEvent;


typedef TimelineSegment = {
start:Int,
stop:Int,
name:String
}


/**
 * ...
 * @author Jonathan Snyder
 */
class UIButton extends UIMovieClip {
	
	public var labels:Array<TimelineSegment>;
	
	public var OnClick:Function;
	public var OnClickParams:Array<Dynamic>;
	
	
	var animationTween:NumTween;

	public function new(AssetName:Dynamic, ?LibraryName:String, ?onClick:Function, ?onClickParams:Array<Dynamic>) {
		super(AssetName, LibraryName);
		
		OnClick = onClick;
		OnClickParams = onClickParams;
		
		//stop mc from playing it's entire timeline
		mc.stop();
		
		//get label information so we can play sections of the timeline
		labels = [];
		for (l in mc.currentLabels) {
			var seg:TimelineSegment = {
				start: l.frame,
				stop: mc.totalFrames,
				name: l.name
			}
			
			
			//if labels length > 0
			//we assign the previous
			//label's end to be this labels
			//start minus 1
			if (labels.length > 0) {
				labels[labels.length - 1].stop = seg.start - 1;
			}
			
			//add new segment to array
			labels.push(seg);
		}
		
		addListeners();
	}
	
	
	/**
	 * Add event listeners
	 */
	function addListeners() {
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
	
	
	/**
	 * Plays the timeline at a given label. Stops automatically before the next label index
	 * @param	label name of the label
	 * @param	onComplete function that is called once animation has finished
	 */
	public function playLabel(label:String, ?onComplete:UIButton -> Void) {
		
		
		var label = getLabelByString(label);
		
		
		if (label != null) {
			trace(label.start + " - " + label.stop);
			
			
			var options:TweenOptions = {};
			
			if (onComplete != null) {
				options.onComplete = function(f:FlxTween) {
					onComplete(this);
				}
			}
			
			
			//If animationTween is non null
			//Cancel it so we aren't overriding another tween
			if (animationTween != null) {
				animationTween.cancel();
			}
			
			
			animationTween = FlxTween.num(label.start, label.stop, (label.stop - label.start) / FlxG.updateFramerate, options, function(v:Float) {
				var f:Int = Std.int(v);
				mc.gotoAndStop(f);
			});
			
		}
	}
	
	
	private function getLabelByString(label:String):TimelineSegment {
		var l = labels.filter(function(_fl:TimelineSegment) {
			return _fl.name == label;
		});
		
		
		return l[0];
	}
	
}