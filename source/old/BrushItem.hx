package old;
import flash.display.MovieClip;
import flash.text.TextField;
import flixel.util.FlxColor;
import openfl.geom.ColorTransform;

/**
 * ...
 * @author Jonathan Snyder
 */
class BrushItem extends UIMovieClip {
	
	public var titleTF:TextField;
	public var descTF:TextField;
	public var icon:MovieClip;

	public function new(?Data:BrushItemData) {
		super("BrushItem");
		
		
		var _mc:Dynamic = cast mc;
		
		/**
		 *  i should probably remove this class
		 */
		titleTF = cast _mc.title_txt.txt;
		descTF = cast _mc.desc_txt.txt;
		icon = cast _mc.icon;
		
		
		/**
		 * Update properties if Data is not null
		 */
		if (Data != null) {
			
			/**
			 * Set text
			 */
			titleTF.text = Data.title;
			descTF.text = Data.desc;
			
			
			/**
			 * Set color of icon
			 */
			var ct:ColorTransform = new ColorTransform();
			ct.color = FlxColor.fromString(Data.color);
			icon.getChildAt(0).transform.colorTransform = ct;
		}
		
	}
	
}


typedef BrushItemData = {
?color:String,
?title:String,
?desc:String,
?properties:BrushProperties
}


typedef BrushProperties = {
?elasticity:Float
}