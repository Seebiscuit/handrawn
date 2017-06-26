package system;
import openfl.Assets;

/**
 * ...
 * @author Jonathan Snyder
 */
class Images {
	static private var vals:Array<String>;

	public static function init():Void {
		vals = Assets.list(AssetType.IMAGE);

		
	}


	public static function getPath(name:String):String {
		if (vals == null) {
			vals = Assets.list(AssetType.IMAGE);
		}


		var v:String = null;
		
		
		var matched:Array<String> = vals.filter(function(s:String) {
			return s.indexOf(name) != -1;
		});
		

		if (matched.length > 0) {
			v = matched[0];
		}
		
		
		return v;
	}
}