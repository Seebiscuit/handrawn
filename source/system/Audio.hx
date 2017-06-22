package system;
import flixel.FlxG;
import flixel.system.FlxSound;

/**
 * ...
 * @author Jonathan Snyder
 */
class Audio
{
	
	
	public static var blip:FlxSound;
	public static var draw:FlxSound;

	public static function init():Void{
		FlxG.sound.cacheAll();
		
		
		blip = new FlxSound();
		blip.loadEmbedded("assets/sounds/blip.ogg");
		
		draw = new FlxSound();
		draw.loadEmbedded("assets/sounds/draw.ogg");
		
		
		
		FlxG.sound.defaultSoundGroup.add(blip);
		FlxG.sound.defaultSoundGroup.add(draw);
	}
	
}