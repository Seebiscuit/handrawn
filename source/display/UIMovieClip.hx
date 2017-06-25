package display;
import flixel.util.FlxDestroyUtil.IFlxDestroyable;
import flixel.util.FlxDestroyUtil;
import motion.Actuate;
import motion.easing.Linear;
import openfl.Assets;
import openfl.Lib;
import openfl.display.MovieClip;
import openfl.errors.Error;

typedef TimelineSegment = {
start:Int,
stop:Int,
name:String,
?audio:String
}


/**
 * ...
 * @author Jonathan Snyder
 */
class UIMovieClip implements IFlxDestroyable {

	public var mc:MovieClip;
	public var dynamicMC:Dynamic;
	public var currentFrame(get, set):Int;

	public var labels:Array<TimelineSegment>;

	/**
	 * Constructor
	 * @param	AssetName Name of asset movieclip in library, or a movieclip itself
	 * @param	LibraryName the libaray to grab the asset from
	 */
	public function new(?AssetName:Dynamic, LibraryName:String = "library", ?AnimationXML:Xml) {
		
		
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
	public function playLabel(Label:String, ?onComplete:UIMovieClip -> Void) {
		
		
		var label = getLabelByString(Label);
		
		trace(Label + " - " + label);
		
		
		if (label != null) {
			
			//duration from start to end
			var duration:Float = Math.abs(label.stop - label.start) / Lib.current.stage.frameRate;

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
	
	
	/**
	 * Play movieclip from start to finish.
	 * Autostop, with onComplete options
	 * @param	start Frame number or label string to start
	 * @param	end  Frame number or label string to stop
	 */
	public function playFromTo(start:Dynamic, end:Dynamic, ?OnComplete:UIMovieClip -> Void):Void {
		var index1:Int = Std.is(start, Int) ? cast start : mc.currentLabels.filter(function(f) {
			return f.name == Std.string(start);
		})[0].frame;
		
		var index2:Int = Std.is(end, Int) ? cast end : mc.currentLabels.filter(function(f) {
			return f.name == Std.string(end);
		})[0].frame;
		
		//duration from start to end
		var duration:Float = Math.abs(index2 - index1) / Lib.current.stage.frameRate;

		
		//Actuate.stop(this);
		currentFrame = index1;
		Actuate.tween(this, duration, {currentFrame: index2}, true)
		.onComplete(OnComplete, [this])
		.ease(Linear.easeNone);
		
	}
	
	
	/**
	 * Destroy UIMovieClip
	 */
	public function destroy():Void {
		trace("destroying");
		Actuate.stop(this);
		//labels = labels;
		//FlxArrayUtil.clearArray(labels);
		labels = null;
		dynamicMC = null;
		mc.removeChildren();
		if (mc.parent != null) {
			mc.parent.removeChild(mc);
			mc = null;
		}
	}
	
	
	function get_currentFrame():Int {
		return mc.currentFrame;
	}
	
	function set_currentFrame(value:Int):Int {
		mc.gotoAndStop(value);
		return mc.currentFrame;
	}
	
}