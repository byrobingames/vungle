package;

#if cpp
import cpp.Lib;
#elseif neko
import neko.Lib;
#else
import openfl.Lib;
#end

#if android
import openfl.utils.JNI;
#end

import scripts.ByRobinAssets;

class Vungle {
	
	private static var initialized:Bool=false;
	private static var _adIsAvailable:Bool=false;
	private static var _adIsNotAvailable:Bool=false;
	private static var _videoAdWillShow:Bool=false;
	private static var _rewardedAdWillShow:Bool=false;
	private static var _videoAdClosed:Bool=false;
	private static var _rewardedAdClosed:Bool=false;
	private static var _rewardedAdFullyWatched:Bool=false;
	private static var _rewardedAdNotFullyWatched:Bool=false;
	private static var _anAdisClicked:Bool=false;
	private static var _hasDownloadedApp:Bool=false;
	

	////////////////////////////////////////////////////////////////////////////
	#if ios
	private static var __init:String->Void = function(appId:String){};
	private static var __vungle_set_event_handle = Lib.load("vungle","vungle_set_event_handle", 1);
	#end
	#if android
	private static var __init:Dynamic;
	#end
	private static var __showVideo:Void->Void = function(){};
	private static var __showRewarded:Void->Void = function(){};

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
			__showVideo = cpp.Lib.load("vungle","vungle_video_show",0);
			__showRewarded = cpp.Lib.load("vungle","vungle_rewarded_show",0);

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
			__showVideo = openfl.utils.JNI.createStaticMethod("com/byrobin/vungle/VungleEx", "showVideo", "()V");
			__showRewarded = openfl.utils.JNI.createStaticMethod("com/byrobin/vungle/VungleEx", "showRewarded", "()V");
			
			if(__init == null)
			{
				__init = JNI.createStaticMethod("com/byrobin/vungle/VungleEx", "init", "(Lorg/haxe/lime/HaxeObject;Ljava/lang/String;)V", true);
			}
	
			var args = new Array<Dynamic>();
			args.push(new Vungle());
			args.push(appId);
			__init(args);
		}catch(e:Dynamic){
			trace("Android INIT Exception: "+e);
		}
		#end
	}
	
	public static function showVideo() {
		try {
			__showVideo();
		} catch(e:Dynamic) {
			trace("ShowVideo Exception: "+e);
		}
	}
	
	public static function showRewarded() {
		try {
			__showRewarded();
		} catch(e:Dynamic) {
			trace("ShowRewardedVideo Exception: "+e);
		}
	}
	
	public static function adIsAvailable():Bool{
		
		if(_adIsAvailable){
			_adIsAvailable = false;
			return true;
		}
		
		return false;
	}
	
	public static function adIsNotAvailable():Bool{
		
		if(_adIsNotAvailable){
			_adIsNotAvailable = false;
			return true;
		}
		
		return false;
	}
	
	public static function videoAdWillShow():Bool{
		
		if(_videoAdWillShow){
			_videoAdWillShow = false;
			return true;
		}
		
		return false;
	}
	
	public static function rewardedAdWillShow():Bool{
		
		if(_rewardedAdWillShow){
			_rewardedAdWillShow = false;
			return true;
		}
		
		return false;
	}
	
	public static function videoAdClosed():Bool{
		
		if(_videoAdClosed){
			_videoAdClosed = false;
			return true;
		}
		
		return false;
	}
	
	public static function rewardedAdClosed():Bool{
		
		if(_rewardedAdClosed){
			_rewardedAdClosed = false;
			return true;
		}
		
		return false;
	}
	
	public static function rewardedAdFullyWatched():Bool{
		
		if(_rewardedAdFullyWatched){
			_rewardedAdFullyWatched = false;
			return true;
		}
		
		return false;
	}
	
	public static function rewardedAdNotFullyWatched():Bool{
		
		if(_rewardedAdNotFullyWatched){
			_rewardedAdNotFullyWatched = false;
			return true;
		}
		
		return false;
	}
	
	public static function anAdisClicked():Bool{
		
		if(_anAdisClicked){
			_anAdisClicked = false;
			return true;
		}
		
		return false;
	}
	
	public static function hasDownloadedApp():Bool{
		
		if(_hasDownloadedApp){
			_hasDownloadedApp = false;
			return true;
		}
		
		return false;
	}
	
	
	
	///////Events Callbacks/////////////
	
	#if ios
	//Ads Events only happen on iOS.
	private static function notifyListeners(inEvent:Dynamic)
	{
		var event:String = Std.string(Reflect.field(inEvent, "type"));
		
		if(event == "adsavailible")
		{
			trace("ADS AVAILIBLE");
			_adIsAvailable = true;
		}
		if(event == "noadsavailible")
		{
			trace("NO ADS AVAILABLE");
			_adIsNotAvailable = true;
		}
		if(event == "videowillshow")
		{
			trace("VIDEO WILL SHOW");
			_videoAdWillShow = true;
		}
		if(event == "rewardedwillshow")
		{
			trace("REWARDED WILL SHOW");
			_rewardedAdWillShow = true;
		}
		if(event == "videoclosed")
		{
			trace("VIDEO CLOSED");
			_videoAdClosed = true;
		}
		if(event == "rewardedclosed")
		{
			trace("REWARDED CLOSED");
			_rewardedAdClosed = true;
		}
		if(event == "rewardedwatched")
		{
			trace("REWARDED FULLY WATCHED");
			_rewardedAdFullyWatched = true;
		}
		if(event == "rewardednotwatched")
		{
			trace("REWARDED NOT FULLY WATCHED");
			_rewardedAdNotFullyWatched = true;
		}
		if(event == "clicked")
		{
			trace("AD IS CLICKED");
			_anAdisClicked = true;
		}
		if(event == "hasdownloaded")
		{
			trace("HAS DOWNLOADED ADVERTISED APP");
			_hasDownloadedApp = true;
		}
	}
	#end
	
	#if android
	private function new() {}
	
	public function onAdIsAvailable() 
	{
		_adIsAvailable = true;
	}
	public function onAdIsNotAvailable() 
	{
		_adIsNotAvailable = true;
	}
	public function onVideoWillShow() 
	{
		_videoAdWillShow = true;
	}
	public function onRewardedWillShow() 
	{
		_rewardedAdWillShow = true;
	}
	public function onVideoClosed() 
	{
		_videoAdClosed = true;
	}
	public function onRewardedClosed() 
	{
		_rewardedAdClosed = true;
	}
	public function onRewardedFullyWatched() 
	{
		_rewardedAdFullyWatched = true;
	}
	public function onRewardedNotFullyWatched() 
	{
		_rewardedAdNotFullyWatched = true;
	}
	public function onAdIsClicked() 
	{
		_anAdisClicked = true;
	}
	#end
}
