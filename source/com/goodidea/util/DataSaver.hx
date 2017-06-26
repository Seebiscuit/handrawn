package com.goodidea.util;

import flixel.FlxG;
import haxe.Json;
import sys.io.File;
import tjson.TJSON;

/**
 * ...
 * @author Jonathan Snyder
 */
class DataSaver {

	public static function saveText(url:String, text:String) {
		File.saveContent(url, text);
	}
	
	public static function serializeToFile(obj:Dynamic, url:String, _useTJSON:Bool = true, prettyPrint:Bool = true) {
		if (obj == null) {
			FlxG.log.error("you are trying to serialize a null object");
			
		}
		
		
		var output:String = "";
		
		if (_useTJSON) {
			output = prettyPrint ? TJSON.encode(obj, "fancy") : TJSON.encode(obj);
			
		} else {
			output = prettyPrint ? Json.stringify(obj, null, " ") : Json.stringify(obj);
			
			
		}
		
		saveText(url, output);
		
		
	}
	
}