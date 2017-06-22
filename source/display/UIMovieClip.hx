package display;
import flixel.FlxG;
import motion.Actuate;
import motion.easing.Linear;
import openfl.Assets;
import openfl.display.MovieClip;
import openfl.errors.Error;

import flixel.tweens.FlxTween;
import flixel.tweens.misc.NumTween;

typedef TimelineSegment = {
start:Int,
stop:Int,
name:String
}


/**
 * ...
 * @author Jonathan Snyder
 */
class UIMovieClip {

	public var mc:MovieClip;
	public var dynamicMC:Dynamic;
	public var currentFrame(get, set):Int;

	public var labels:Array<TimelineSegment>;
	private var animationTween:NumTween;

	/**
	 * Constructor
	 * @param	AssetName Name of asset movieclip in library, or a movieclip itself
	 * @param	LibraryName the libaray to grab the asset from
	 */
	public function new(?AssetName:Dynamic, LibraryName:String = "library") {
		
		
		/**
		 * If asset name is a string, pull from library
		 * If is MovieClip, assign mc to AssetName
		 */
		if (AssetName != null) {
			
			
			if (Std.is(AssetName, String)) {
				mc = Assets.getMovieClip('${LibraryName}:${AssetName}');
			} else if (Std.is(AssetName, MovieClip)) {
				mc = cast AssetName;
			}
			

		}

		if (mc == null) {
			throw new Error("You must have a movieclip reference");
		}

		//dynamic mc reference for chaining other references
		dynamicMC = cast mc;
		
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
	}

	/**
	 * Plays the timeline at a given label. Stops automatically before the next label index
	 * @param	label name of the label
	 * @param	onComplete function that is called once animation has finished
	 */
	public function playLabel(label:String, ?onComplete:UIMovieClip -> Void) {
		
		
		var label = getLabelByString(label);
		
		
		if (label != null) {
			trace(label.start + " - " + label.stop);
			
			//If animationTween is non null
			//Cancel it so we aren't overriding another tween
			if (animationTween != null) {
				animationTween.cancel();
			}
			
			//duration from start to end
			var duration:Float = (label.stop - label.start) / FlxG.updateFramerate;
			
			
			currentFrame = label.start;
			trace(label.start + " - " + label.stop);
			Actuate.stop(this);
			Actuate.tween(this, duration, {currentFrame: label.stop}, true)
			.onComplete(onComplete, [this])
			.ease(Linear.easeNone);
		}
	}
	
	
	public function stopAtLabel(label:String) {
		mc.play();
		currentFrame = getLabelByString(label).stop;
		
	}
	
	
	private function getLabelByString(label:String):TimelineSegment {
		var l = labels.filter(function(_fl:TimelineSegment) {
			return _fl.name == label;
		});
		
		
		return l[0];
	}
	
	function get_currentFrame():Int {
		return mc.currentFrame;
	}
	
	function set_currentFrame(value:Int):Int {
		mc.gotoAndStop(value);
		return mc.currentFrame;
	}
	
}