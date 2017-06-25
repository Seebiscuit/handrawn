#if android
package system;


import extension.admob.AdMob;
import extension.admob.GravityMode;
import haxe.Json;
import openfl.Assets;

using StringTools;

/**
 * ...
 * @author Jonathan Snyder
 */
class AdmobController {

	static var data:AdmobData;

	public static function init() {
		
		#if !NO_ADS
		
		data = Json.parse(Assets.getText("resources/marketing/secure/admob.json"));
		
		// first of all, decide if you want to display testing ads by calling enableTestingAds() method.
		// Note that if you decide to call enableTestingAds(), you must do that before calling INIT methods.
		
		#if debug
		AdMob.enableTestingAds();
		#end
		

		// if your app is for children and you want to enable the COPPA policy,
		// you need to call tagForChildDirectedTreatment(), before calling INIT.
		AdMob.tagForChildDirectedTreatment();

		// If you want to get instertitial events (LOADING, LOADED, CLOSED, DISPLAYING, ETC), provide
		// some callback function for this.
		AdMob.onInterstitialEvent = onInterstitialEvent;
		
		// then call init with Android and iOS banner IDs in the main method.
		// parameters are (bannerId:String, interstitialId:String, gravityMode:GravityMode).
		// if you don't have the bannerId and interstitialId, go to www.google.com/ads/admob to create them.

		AdMob.initAndroid(data.appID, data.adUnit, GravityMode.TOP); // may also be GravityMode.TOP
		//AdMob.initIOS("ca-app-pub-XXXXX123458","ca-app-pub-XXXXX123459", GravityMode.BOTTOM); // may also be GravityMode.TOP

		// NOTE: If your game allows screen rotation, you should call AdMob.onResize(); when rotation happens.
		
		#else
		
		trace("no ads please");
		
		#end

	}
	
	static public function showInterstitial():Void {
		AdMob.showInterstitial();
	}
	
	static public function showBanner():Void {
		AdMob.showBanner();
	}
	
	static private function onInterstitialEvent(e:String) {
		trace(e);
	}
	
}


typedef AdmobData = {
appID:String,
adUnit:String
}
#end