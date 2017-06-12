package display;
import openfl.Assets;
import openfl.display.MovieClip;

/**
 * ...
 * @author Jonathan Snyder
 */
class UIMovieClip {

	public var mc:MovieClip;
	
	public function new(?AssetName:Dynamic) {
		
		
		/**
		 * If asset name is a string, pull from library
		 * If is MovieClip, assign mc to AssetName
		 */
		if (AssetName != null) {
			
			
			if (Std.is(AssetName, String)) {
				mc = Assets.getMovieClip('library:${AssetName}');
			} else if (Std.is(AssetName, MovieClip)) {
				mc = cast AssetName;
			}
			

		}
		
		
		//mc.stop();
	}
	
}