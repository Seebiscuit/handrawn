package system;
import flixel.FlxG;
import openfl.Assets;

/**
 * ...
 * @author Jonathan Snyder
 */
class Images {

	public static function init():Void {
		trace(Assets.list());
		
		#if FLX_DEBUG
		FlxG.console.registerClass(Assets);
		FlxG.console.registerClass(Images);
		#end
	}
	
	
	public static function getPath(name:String):String {
		
		var v:String = null;
		
		var vals:Array<String> = Assets.list(AssetType.IMAGE).filter(function(s:String) {
			return s.indexOf(name) != -1;
		});
		
		if (vals.length > 0) {
			v = vals[0];
		}
		
		
		return v;
	}
}