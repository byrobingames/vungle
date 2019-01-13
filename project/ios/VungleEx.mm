/*
 *
 * Created by Robin Schaafsma
 * www.byrobingames.com
 *
 */

#include <VungleEx.h>
#import <UIKit/UIKit.h>
#import <VungleSDK/VungleSDK.h>

using namespace vungle;

extern "C" void sendVungleEvent(char* event, const char* data);

@interface VungleController : NSObject <VungleSDKDelegate>
{
    VungleSDK* vunlgeSDK;

}

- (id)initWithID:(NSString*)ID;
- (void)loadAd:(NSString*)placementID;
- (void)showInterstitialAd:(NSString*)placementID;
- (void)showRewardedAd:(NSString*)placementID;

@end

@implementation VungleController

- (id)initWithID:(NSString*)ID
{
    self = [super init];
    NSLog(@"VungleEX Init");
    if(!self) return nil;
    
    vunlgeSDK = [VungleSDK sharedSDK];
    // start vungle publisher library
    NSError *error;
    if(![vunlgeSDK startWithAppId:ID error:&error]) {
        NSLog(@" VungleEX Error while starting VungleSDK %@", [error localizedDescription]);
    }
    
    //Set VungleSDK Delegate
    [[VungleSDK sharedSDK] setDelegate:self];
    
    return self;
}

- (void)loadAd:(NSString*)placementID
{
    if(vunlgeSDK == nil) vunlgeSDK = [VungleSDK sharedSDK];
    
    NSError *error;
    [vunlgeSDK loadPlacementWithID:placementID error:&error];
    
}

- (void)showInterstitialAd:(NSString*)placementID
{
    if(vunlgeSDK == nil) vunlgeSDK = [VungleSDK sharedSDK];
    

    NSError *error;
    [vunlgeSDK playAd:[[[UIApplication sharedApplication] keyWindow] rootViewController] options:nil placementID:placementID error:&error];
    if (error) {
        NSLog(@"VungleEX Error encountered playing ad: %@", error);
    }
}


- (void)showRewardedAd:(NSString*)placementID
{
    // Grab instance of Vungle SDK
    if(vunlgeSDK == nil) vunlgeSDK = [VungleSDK sharedSDK];
    
    // Dict to set custom ad options
    NSDictionary* options = @{VunglePlayAdOptionKeyIncentivizedAlertBodyText : @"If the video isn't completed you won't get your reward! Are you sure you want to close early?",
                              VunglePlayAdOptionKeyIncentivizedAlertCloseButtonText : @"Close",
                              VunglePlayAdOptionKeyIncentivizedAlertContinueButtonText : @"Keep Watching",
                              VunglePlayAdOptionKeyIncentivizedAlertTitleText : @"Careful!"};
    
    // Pass in dict of options, play ad
    NSError *error;
    [vunlgeSDK playAd:[[[UIApplication sharedApplication] keyWindow] rootViewController] options:options placementID:placementID error:&error];
    if (error) {
        NSLog(@"VungleEX Error encountered playing ad: %@", error);
    }
}

#pragma mark - VungleSDK Delegate

- (void)vungleSDKDidInitialize
{
    NSLog(@"VungleEX SDK did Initialized");
}

- (void)vungleSDKFailedToInitializeWithError:(NSError *)error
{
    NSLog(@"VungleEX SDK failed to Initialize with error %@", error);
}

- (void)vungleAdPlayabilityUpdate:(BOOL)isAdPlayable placementID:(NSString *)placementID error:(nullable NSError *)error {
    
    const char *_placementID = [placementID UTF8String];
    
    if (isAdPlayable) {
        NSLog(@"An ad is available for playback");
        sendVungleEvent("adsavailible",_placementID);
        
    } else {
        NSLog(@"VungleEX No ads currently available for playback error: %@", error);
        sendVungleEvent("noadsavailible",_placementID);
    }
}

- (void)vungleWillShowAdForPlacementID:(NSString *)placementID {
    NSLog(@"VungleEX An ad is about to be played!");
    //Use this delegate method to pause animations, sound, etc.
    const char *_placementID = [placementID UTF8String];
    sendVungleEvent("adwillshow",_placementID);
}

- (void)vungleWillCloseAdWithViewInfo:(VungleViewInfo *)info placementID:(NSString *)placementID {
    
    const char *_placementID = [placementID UTF8String];
    
    if([info completedView]){
        NSLog(@"VungleEX Ad is fully watched");
        sendVungleEvent("adfullywatched",_placementID);
        
    }else{
        NSLog(@"VungleEX Ad is not fully watched");
        sendVungleEvent("adnotfullywatched",_placementID);
    }
    
    if (info) {
        NSLog(@"VungleEX 1 Info about ad viewed: %@", info);
    }
}

- (void)vungleDidCloseAdWithViewInfo:(VungleViewInfo *)info placementID:(NSString *)placementID{
    
    const char *_placementID = [placementID UTF8String];
    
    if([info didDownload]){
        NSLog(@"VungleEX The user has downloaded an advertised application and is now returning to the main app");
        //This method can be used to resume animations, sound, etc. if a user was presented a product sheet earlier
        sendVungleEvent("hasdownloaded",_placementID);
        sendVungleEvent("adclicked",_placementID);
    }
    
    sendVungleEvent("adclosed",_placementID);
    
    
    if (info) {
        NSLog(@"VungleEX 2 Info about ad viewed: %@", info);
    }
    
}


@end

namespace vungle {
	
	static VungleController *vungleController;
    
	void init(const char *__appID){
        
        if(vungleController == NULL)
        {
            vungleController = [[VungleController alloc] init];
        }
        
        NSString *appID = [NSString stringWithUTF8String:__appID];

        [vungleController initWithID:appID];
    }
    
    void loadVungleAd(const char *__placementID)
    {
        NSString *placementID = [NSString stringWithUTF8String:__placementID];
        
        if(vungleController!=NULL) [vungleController loadAd:placementID];
    }
    
    void showInterstitial(const char *__placementID)
    {
        NSString *placementID = [NSString stringWithUTF8String:__placementID];
        
        if(vungleController!=NULL) [vungleController showInterstitialAd:placementID];
    }
    
    void showRewarded(const char *__placementID)
    {
        NSString *placementID = [NSString stringWithUTF8String:__placementID];
        
        if(vungleController!=NULL) [vungleController showRewardedAd:placementID];
    }
    
    void setVungleConsent(bool isGranted)
    {
        if(isGranted){
            [[VungleSDK sharedSDK] updateConsentStatus:VungleConsentAccepted consentMessageVersion:@"Vungle 6.3.2"];
        }else {
            [[VungleSDK sharedSDK] updateConsentStatus:VungleConsentDenied consentMessageVersion:@"Vungle 6.3.2"];
        }
    
        NSLog(@"VungleEX SetConsent:  %@", @(isGranted));
    }
    
    bool getVungleConsent()
    {
        switch ([[VungleSDK sharedSDK] getCurrentConsentStatus])
        {
            case VungleConsentAccepted:
                return true;
                break;
            case VungleConsentDenied:
                return false;
                break;
            default:
                return false;
                break;
                
        }
        
        //return [[VungleSDK sharedSDK] getCurrentConsentStatus];
    }
    
    
}
