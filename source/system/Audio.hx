package system;
import flixel.FlxG;
import flixel.system.FlxSound;

/**
 * ...
 * @author Jonathan Snyder
 */
class Audio {
	
	
	public static var blip:FlxSound;
	public static var draw:FlxSound;
	
	public static var music:FlxSound;

	public static function init():Void {
		FlxG.sound.cacheAll();
		
		
		blip = new FlxSound();
		blip.loadEmbedded("assets/sounds/bloop_9.ogg");
		
		draw = new FlxSound();
		draw.loadEmbedded("assets/sounds/draw.ogg");
		
		music = new FlxSound();
		music.loadEmbedded("assets/music/track1.ogg", true, false);
		
		
		FlxG.sound.defaultSoundGroup.add(blip);
		FlxG.sound.defaultSoundGroup.add(draw);
		
		FlxG.sound.defaultMusicGroup.add(music);
	}
	
}