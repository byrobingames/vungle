/*
 *
 * Created by Robin Schaafsma
 * www.byrobingames.com
 * copyright
 */

package com.byrobin.vungle;

import com.vungle.publisher.Orientation;
import com.vungle.publisher.VunglePub;
import com.vungle.publisher.EventListener;
import com.vungle.publisher.AdConfig;

import android.app.Activity;
import android.content.Context;
import android.os.*;
import android.util.Log;

import org.haxe.extension.Extension;
import org.haxe.lime.HaxeObject;


public class VungleEx extends Extension {


	//////////////////////////////////////////////////////////////////////////////////////////////////
	//////////////////////////////////////////////////////////////////////////////////////////////////
    private static VungleEx instance = null;
    private static HaxeObject vungleCallback;
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////
    private static String appId=null;
    private static boolean showedVideo=false;
    private static boolean showedRewarded=false;
    private static boolean rewardedClosed=false;
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//////////////////////////////////////////////////////////////////////////////////////////////////

	static public void init(HaxeObject cb, final String appId){
        
        vungleCallback = cb;
        VungleEx.appId=appId;
		
		Extension.mainActivity.runOnUiThread(new Runnable() {
            public void run() 
			{
                
				Log.d("VungleEx","Init Vungle");
                
                VunglePub.getInstance().init(Extension.mainActivity, appId);
                
                VunglePub.getInstance().setEventListeners(instance.vungleDefaultListener);
			}
		});	
	}

	static public void showVideo()
    {
        showedVideo = true;
        showedRewarded = false;
        
        Log.d("VungleEx","Show Video Begin");
		if(appId=="") return;
		Extension.mainActivity.runOnUiThread(new Runnable() {
			public void run()
            {
                if(VunglePub.getInstance().isAdPlayable()){
                    
                    final AdConfig overrideConfig = new AdConfig();
                    
                    overrideConfig.setBackButtonImmediatelyEnabled(true);
                    
                    VunglePub.getInstance().playAd(overrideConfig);
                }
            }
		});
		Log.d("VungleEx","Show Video End ");
	}
    
    static public void showRewarded()
    {
        showedVideo = false;
        showedRewarded = true;
        
        Log.d("VungleEx","Show Rewarded Begin");
        if(appId=="") return;
        Extension.mainActivity.runOnUiThread(new Runnable() {
            public void run()
            {
                if(VunglePub.getInstance().isAdPlayable()){
                    
                    
                    final AdConfig overrideConfig = new AdConfig();
                    
                    // set incentivized option on
                    overrideConfig.setBackButtonImmediatelyEnabled(true);
                    //overrideConfig.setImmersiveMode(true);
                    overrideConfig.setIncentivized(true);
                    overrideConfig.setIncentivizedCancelDialogTitle("Careful!");
                    overrideConfig.setIncentivizedCancelDialogBodyText("If the video isn't completed you won't get your reward! Are you sure you want to close early?");
                    overrideConfig.setIncentivizedCancelDialogCloseButtonText("Close");
                    overrideConfig.setIncentivizedCancelDialogKeepWatchingButtonText("Keep Watching");
                    
                   
                    VunglePub.getInstance().playAd(overrideConfig);
                }
            }
        });
        Log.d("VungleEx","Show Rewarded End ");
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////
    
    private final EventListener vungleDefaultListener = new EventListener() {
    
    @Deprecated
    @Override
    public void onVideoView(boolean isCompletedView, int watchedMillis, int videoDurationMillis) {
    // Called each time a video completes.  isCompletedView is true if >= 80% of the video was watched.

    }
    
    @Override
    public void onAdStart() {
    // Called before playing an ad.
        if(showedVideo){
            vungleCallback.call("onVideoWillShow", new Object[] {});
        }else if(showedRewarded){
            vungleCallback.call("onRewardedWillShow", new Object[] {});
        }
    }

    @Override
    public void onAdUnavailable(String reason) {
    // Called when VunglePub.playAd() was called but no ad is available to show to the user.
        vungleCallback.call("onAdIsNotAvailable", new Object[] {});
    }
    
    @Override
    public void onAdEnd(boolean wasSuccessfulView, boolean wasCallToActionClicked) {
    // Called when the user leaves the ad and control is returned to your application.
        if(showedVideo){
            showedVideo = false;
            vungleCallback.call("onVideoClosed", new Object[] {});
        }else if(showedRewarded){
            if(wasSuccessfulView){
                showedRewarded = false;
                vungleCallback.call("onRewardedFullyWatched", new Object[] {});
                rewardedClosed = true;
                }else{
                    showedRewarded = false;
                    vungleCallback.call("onRewardedNotFullyWatched", new Object[] {});
                    rewardedClosed = true;
                }
                if(rewardedClosed){
                rewardedClosed = false;
                vungleCallback.call("onRewardedClosed", new Object[] {});
                }
        }

        if(wasCallToActionClicked){
            vungleCallback.call("onAdIsClicked", new Object[] {});
        }
    }

    @Override
    public void onAdPlayableChanged(boolean isAdPlayable) {
    // Called when ad playability changes.
        if (isAdPlayable) {
            Log.d("VungleEx","An ad is available for playback ");
    
            vungleCallback.call("onAdIsAvailable", new Object[] {});
        }else {
            Log.d("VungleEx","An ad is not available for playback ");

            vungleCallback.call("onAdIsNotAvailable", new Object[] {});
            }
    }
};

	//////////////////////////////////////////////////////////////////////////////////////////////////
	//////////////////////////////////////////////////////////////////////////////////////////////////
    public void onCreate ( Bundle savedInstanceState )
    {
        VungleEx.instance = this;
    }
    public void onPause() {
        VunglePub.getInstance().onPause();
    }

    public void onResume() {
        VunglePub.getInstance().onResume();
    }

    public void onDestroy() {
        // onDestroy(), remove eventlisteners.
        VunglePub.getInstance().removeEventListeners(vungleDefaultListener);
    }
    
}
