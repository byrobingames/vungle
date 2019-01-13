/*
 *
 * Created by Robin Schaafsma
 * https://byrobingames.github.io
 * copyright
 */

package com.byrobin.vungle;

import com.vungle.warren.Vungle;
import com.vungle.warren.AdConfig;
import com.vungle.warren.InitCallback;
import com.vungle.warren.LoadAdCallback;
import com.vungle.warren.PlayAdCallback;
import com.vungle.warren.VungleNativeAd;
import com.vungle.warren.Vungle.Consent;
import com.vungle.warren.error.VungleException;

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
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//////////////////////////////////////////////////////////////////////////////////////////////////

    static public void init(HaxeObject cb, final String appId){

    vungleCallback = cb;
    VungleEx.appId=appId;

            Extension.mainActivity.runOnUiThread(new Runnable() {
        public void run()
                    {

                        Log.d("VungleEx","Init Vungle");
                        Vungle.init(appId, mainActivity.getApplicationContext(), new InitCallback() {
                            @Override
                            public void onSuccess() {
                                // Initialization has succeeded and SDK is ready to load an ad or play one if there
                                // is one pre-cached already
                            }

                            @Override
                            public void onError(Throwable throwable) {
                                // Initialization error occurred - throwable.getLocalizedMessage() contains error message
                            }

                            @Override
                            public void onAutoCacheAdAvailable(String placementId) {
                                // Callback to notify when an ad becomes available for the auto-cached placement
                                // NOTE: This callback works only for the auto-cached placement. Otherwise, please use
                                // LoadAdCallback with loadAd API for loading placements.
                                vungleCallback.call("onAdIsAvailable", new Object[] {placementId});
                            }
                        });


                    }
            });
    }

    static public void loadAd(final String placementId)
    {
        Log.d("VungleEx","Load ad Begin");
            if(appId=="") return;
            Extension.mainActivity.runOnUiThread(new Runnable() {
                    public void run()
                    {

                        if (Vungle.isInitialized()) {
                            Vungle.loadAd(placementId, new LoadAdCallback() {
                                @Override
                                public void onAdLoad(String placementReferenceId) {

                                    vungleCallback.call("onAdIsAvailable", new Object[] {placementReferenceId});
                                }

                                @Override
                                public void onError(String placementReferenceId, Throwable throwable) {
                                    // Load ad error occurred - throwable.getLocalizedMessage() contains error message
                                    vungleCallback.call("onAdIsNotAvailable", new Object[] {placementReferenceId});
                                }
                            });
                        }
                    }
            });
    }


    static public void showInterstitial(final String placementId)
    {

        Log.d("VungleEx","Show Insterstitial Begin");
            if(appId=="") return;
            Extension.mainActivity.runOnUiThread(new Runnable() {
                    public void run()
                    {
                        Vungle.playAd(placementId, null, new PlayAdCallback() {
                            @Override
                            public void onAdStart(String placementReferenceId) {

                                vungleCallback.call("onAdWillShow", new Object[] {placementReferenceId});
                            }

                            @Override
                            public void onAdEnd(String placementReferenceId, boolean completed, boolean isCTAClicked) {

                                if(completed){
                                    vungleCallback.call("onAdFullyWatched", new Object[] {placementReferenceId});
                                }else{
                                    vungleCallback.call("onAdNotFullyWatched", new Object[] {placementReferenceId});
                                }
                                if(isCTAClicked){
                                    vungleCallback.call("onAdIsClicked", new Object[] {placementReferenceId});
                                }

                                vungleCallback.call("onAdClosed", new Object[] {placementReferenceId});
                            }

                            @Override
                            public void onError(String placementReferenceId, Throwable throwable) {
                                // Play ad error occurred - throwable.getLocalizedMessage() contains error message
                            }
                        });

                    }
            });
    }

    static public void showRewarded(final String placementId)
    {
        Log.d("VungleEx","Show Rewarded Begin");
        if(appId=="") return;
        Extension.mainActivity.runOnUiThread(new Runnable() {
            public void run()
            {

                final String title = "Careful!";
                final String body = "If the video isn't completed you won't get your reward! Are you sure you want to close early?";
                final String keepWatching = "Keep Watching";
                final String close = "Close";

                Vungle.setIncentivizedFields("",title,body,keepWatching,close);

                Vungle.playAd(placementId, null, new PlayAdCallback() {
                    @Override
                    public void onAdStart(String placementReferenceId) {

                        vungleCallback.call("onAdWillShow", new Object[] {placementReferenceId});
                    }

                    @Override
                    public void onAdEnd(String placementReferenceId, boolean completed, boolean isCTAClicked) {

                        if(completed){
                            vungleCallback.call("onAdFullyWatched", new Object[] {placementReferenceId});
                        }else{
                            vungleCallback.call("onAdNotFullyWatched", new Object[] {placementReferenceId});
                        }
                        if(isCTAClicked){
                            vungleCallback.call("onAdIsClicked", new Object[] {placementReferenceId});
                        }

                        vungleCallback.call("onAdClosed", new Object[] {placementReferenceId});
                    }

                    @Override
                    public void onError(String placementReferenceId, Throwable throwable) {
                        // Play ad error occurred - throwable.getLocalizedMessage() contains error message
                    }
                });

            }
         });
    }

    //GDPR Settings
    static public void setUsersConsent(final boolean isGranted){

        // Usage example of GDPR API
        //                // To set the user's consent status to opted in:
        //                Vungle.updateConsentStatus(Vungle.Consent.OPTED_IN, “1.0.0”);
        //
        //                // To set the user's consent status to opted out:
        //                Vungle.updateConsentStatus(Vungle.Consent.OPTED_OUT, “1.0.0”);

        if(isGranted){
            Vungle.updateConsentStatus(Vungle.Consent.OPTED_IN, "Vungle 6.3.24");
        }else {
            Vungle.updateConsentStatus(Vungle.Consent.OPTED_OUT, "Vungle 6.3.24");
        }


        Log.d("VungleEx","VungleEx Consent is set to: " + isGranted);
    }

    public static boolean getUsersConsent(){

        // To find out what the user's current consent status is:
        //                // This will return null if the GDPR Consent status has not been set
        //                // Otherwise, it will return Vungle.Consent.OPTED_IN or Vungle.Consent.OPTED_OUT
        //                Vungle.Consent currentStatus = Vungle.getConsentStatus();

        Boolean isGranted = false;

        Vungle.Consent currentStatus = Vungle.getConsentStatus();

        if(currentStatus != null){

            switch(currentStatus){

                case OPTED_IN:
                    isGranted = true;
                    break;
                case OPTED_OUT:
                    isGranted = false;
                    break;
                default:
                    isGranted = false;
                    break;
            }

        }else{
            isGranted = false;
        }

        Log.d("VungleEx","VungleEx get userConsent is: " + currentStatus);

        return isGranted;
    }

    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////
    
    public void onCreate ( Bundle savedInstanceState )
    {
        super.onCreate(savedInstanceState);
        VungleEx.instance = this;
    }
    
}
