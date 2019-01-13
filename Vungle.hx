package;

#if cpp
import cpp.Lib;
#elseif neko
import neko.Lib;
#else
import openfl.Lib;
#end

#if android
#if openfl_legacy
import openfl.utils.JNI;
#else
import lime.system.JNI;
#end
#end

import scripts.ByRobinAssets;

class Vungle {

	private static var initialized:Bool=false;
	private static var _adIsAvailable:Bool=false;
	private static var _adIsNotAvailable:Bool=false;
	private static var _adWillShow:Bool=false;
	private static var _adClosed:Bool=false;
	private static var _adFullyWatched:Bool=false;
	private static var _adNotFullyWatched:Bool=false;
	private static var _anAdisClicked:Bool=false;
	private static var _hasDownloadedApp:Bool=false;
	private static var _placementID:String="";


	////////////////////////////////////////////////////////////////////////////
	#if ios
	private static var __init:String->Void = function(appId:String){};
	private static var __vungle_set_event_handle = Lib.load("vungle","vungle_set_event_handle", 1);
	#end
	#if android
	private static var __init:Dynamic;
	#end
	private static var __loadAd:String->Void = function(placementId:String){};
	private static var __showInterstitial:String->Void = function(placementId:String){};
	private static var __showRewarded:String->Void = function(placementId:String){};
	private static var __setConsent:Bool->Void = function(isGranted:Bool){};
	private static var __getConsent:Void->Bool = function(){return false;};

	////////////////////////////////////////////////////////////////////////////

	public static function init(){

		#if ios
		var appId:String = ByRobinAssets.VUIosAppID;
		#elseif android
		var appId:String = ByRobinAssets.VUAndroidAppID;
		#end

		#if ios
		if(initialized) return;
		initialized = true;
		try{
			// CPP METHOD LINKING
			__init = cpp.Lib.load("vungle","vungle_init",1);
			__loadAd = cpp.Lib.load("vungle","vungle_load_ad",1);
			__showInterstitial = cpp.Lib.load("vungle","vungle_interstitial_show",1);
			__showRewarded = cpp.Lib.load("vungle","vungle_rewarded_show",1);
			__setConsent = cpp.Lib.load("vungle","vungle_setconsent",1);
			__getConsent = cpp.Lib.load("vungle","vungle_getconsent",0);

			__init(appId);
			__vungle_set_event_handle(notifyListeners);
		}catch(e:Dynamic){
			trace("iOS INIT Exception: "+e);
		}
		#end

		#if android
		if(initialized) return;
		initialized = true;
		try{
			// JNI METHOD LINKING
			__loadAd = JNI.createStaticMethod("com/byrobin/vungle/VungleEx","loadAd", "(Ljava/lang/String;)V");
			__showInterstitial = JNI.createStaticMethod("com/byrobin/vungle/VungleEx", "showInterstitial", "(Ljava/lang/String;)V");
			__showRewarded = JNI.createStaticMethod("com/byrobin/vungle/VungleEx", "showRewarded", "(Ljava/lang/String;)V");
			__setConsent = JNI.createStaticMethod("com/byrobin/vungle/VungleEx", "setUsersConsent", "(Z)V");
			__getConsent = JNI.createStaticMethod("com/byrobin/vungle/VungleEx", "getUsersConsent", "()Z");

			if(__init == null)
			{
				__init = JNI.createStaticMethod("com/byrobin/vungle/VungleEx", "init", "(Lorg/haxe/lime/HaxeObject;Ljava/lang/String;)V", true);
			}
			trace("init init");

			var args = new Array<Dynamic>();
			args.push(new Vungle());
			args.push(appId);
			__init(args);
		}catch(e:Dynamic){
			trace("Android INIT Exception: "+e);
		}
		#end
	}

	public static function loadAd(placementId:String) {
		try {
			__loadAd(placementId);
		} catch(e:Dynamic) {
			trace("loadAd Exception: "+e);
		}
	}

	public static function showInterstitial(placementId:String) {
		try {
			__showInterstitial(placementId);
		} catch(e:Dynamic) {
			trace("showInterstitial Exception: "+e);
		}
	}

	public static function showRewarded(placementId:String) {
		try {
			__showRewarded(placementId);
		} catch(e:Dynamic) {
			trace("ShowRewardedVideo Exception: "+e);
		}
	}

	public static function setConsent(isGranted:Bool) {
		try {
			__setConsent(isGranted);
		} catch(e:Dynamic) {
			trace("SetConsent Exception: "+e);
		}
	}

	public static function getConsent():Bool {

		return __getConsent();
	}

	//Callbacks
	public static function adIsAvailable(placementId:String):Bool{

		if(placementId == _placementID){
			if(_adIsAvailable){
				_adIsAvailable = false;
				return true;
			}
		}
		return false;
	}

	public static function adIsNotAvailable(placementId:String):Bool{

		if(placementId == _placementID){
				if(_adIsNotAvailable){
					_adIsNotAvailable = false;
					return true;
				}
		}
		return false;
	}

	public static function adWillShow(placementId:String):Bool{

		if(placementId == _placementID){
				if(_adWillShow){
					_adWillShow = false;
					return true;
				}
		}
		return false;
	}

	public static function adClosed(placementId:String):Bool{

		if(placementId == _placementID){
				if(_adClosed){
					_adClosed = false;
					return true;
				}
		}
		return false;
	}

	public static function adFullyWatched(placementId:String):Bool{

		if(placementId == _placementID){
				if(_adFullyWatched){
					_adFullyWatched = false;
					return true;
				}
		}
		return false;
	}

	public static function adNotFullyWatched(placementId:String):Bool{

		if(placementId == _placementID){
				if(_adNotFullyWatched){
					_adNotFullyWatched = false;
					return true;
				}
		}
		return false;
	}

	public static function anAdisClicked(placementId:String):Bool{

		if(placementId == _placementID){
				if(_anAdisClicked){
					_anAdisClicked = false;
					return true;
				}
		}
		return false;
	}

	public static function hasDownloadedApp(placementId:String):Bool{

		if(placementId == _placementID){
				if(_hasDownloadedApp){
					_hasDownloadedApp = false;
					return true;
				}
		}
		return false;
	}



	///////Events Callbacks/////////////

	#if ios
	//Ads Events only happen on iOS.
	private static function notifyListeners(inEvent:Dynamic)
	{
		var event:String = Std.string(Reflect.field(inEvent, "event"));
		var data:String = Std.string(Reflect.field(inEvent, "data"));

		if(event == "adsavailible")
		{
			trace("ADS AVAILIBLE");
			_placementID = data;
			_adIsAvailable = true;
		}
		if(event == "noadsavailible")
		{
			trace("NO ADS AVAILABLE");
			_placementID = data;
			_adIsNotAvailable = true;
		}
		if(event == "adwillshow")
		{
			trace("AD WILL SHOW");
			_placementID = data;
			_adWillShow = true;
		}
		if(event == "adclosed")
		{
			trace("AD CLOSED");
			_placementID = data;
			_adClosed = true;
		}
		if(event == "adfullywatched")
		{
			trace("AD FULLY WATCHED");
			_placementID = data;
			_adFullyWatched = true;
		}
		if(event == "adnotfullywatched")
		{
			trace("AD NOT FULLY WATCHED");
			_placementID = data;
			_adNotFullyWatched = true;
		}
		if(event == "adclicked")
		{
			trace("AD IS CLICKED");
			_placementID = data;
			_anAdisClicked = true;
		}
		if(event == "hasdownloaded")
		{
			trace("HAS DOWNLOADED ADVERTISED APP");
			_placementID = data;
			_hasDownloadedApp = true;
		}
	}
	#end

	#if android
	private function new() {}

	public function onAdIsAvailable(placementId:String)
	{
		_placementID = placementId;
		_adIsAvailable = true;
	}
	public function onAdIsNotAvailable(placementId:String)
	{
		_placementID = placementId;
		_adIsNotAvailable = true;
	}
	public function onAdWillShow(placementId:String)
	{
		_placementID = placementId;
		_adWillShow = true;
	}
	public function onAdClosed(placementId:String)
	{
		_placementID = placementId;
		_adClosed = true;
	}
	public function onAdFullyWatched(placementId:String)
	{
		_placementID = placementId;
		_adFullyWatched = true;
	}
	public function onAdNotFullyWatched(placementId:String)
	{
		_placementID = placementId;
		_adNotFullyWatched = true;
	}
	public function onAdIsClicked(placementId:String)
	{
		_placementID = placementId;
		_anAdisClicked = true;
	}
	#end
}
