package display;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import system.Images;

/**
 * ...
 * @author Jonathan Snyder
 */
class FlxUIButton extends FlxSpriteGroup {
	
	var icon:FlxSprite;
	var bg:FlxSprite;

	public function new(?X:Float = 0, ?Y:Float = 0, Icon:FlxGraphicAsset, color:String = "#07efb3") {
		super();
		
		add(bg = new FlxSprite(0, 0, Images.getPath("btn-skin-idle")));
		bg.color = FlxColor.fromString(color);
		
		
		add(icon = new FlxSprite(0, 0, Icon));
		icon.setPosition((bg.width / 2) - (icon.width / 2), (bg.height / 2) - (icon.height / 2));
		
		
		setPosition(X, Y);
		
	}
	
}