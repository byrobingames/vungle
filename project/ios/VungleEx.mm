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

extern "C" void sendVungleEvent(char* event);

@interface VungleController : NSObject <VungleSDKDelegate>
{
    BOOL showedVideo;
    BOOL showedRewarded;
    BOOL rewardedClosed;
}

- (id)initWithID:(NSString*)ID;
- (void)showVideoAd;
- (void)showRewardedAd;

@property (nonatomic, assign) BOOL showedVideo;
@property (nonatomic, assign) BOOL showedRewarded;
@property (nonatomic, assign) BOOL rewardedClosed;

@end

@implementation VungleController

@synthesize showedVideo;
@synthesize showedRewarded;
@synthesize rewardedClosed;

- (id)initWithID:(NSString*)ID
{
    self = [super init];
    NSLog(@"Vungle Init");
    if(!self) return nil;
    
    VungleSDK* sdk = [VungleSDK sharedSDK];
    // start vungle publisher library
    [sdk startWithAppId:ID];
    
    //Set VungleSDK Delegate
    [[VungleSDK sharedSDK] setDelegate:self];
    
    return self;
}

- (void)showVideoAd
{
    showedVideo = YES;
    showedRewarded = NO;
    
    VungleSDK* sdk = [VungleSDK sharedSDK];
    
    if ([sdk isAdPlayable]) {

        NSError *error;
        [sdk playAd:[[[UIApplication sharedApplication] keyWindow] rootViewController] error:&error];
        if (error) {
            NSLog(@"Error encountered playing ad: %@", error);
        }
    }
}


- (void)showRewardedAd
{
    showedRewarded = YES;
    showedVideo = NO;
    
    // Grab instance of Vungle SDK
    VungleSDK* sdk = [VungleSDK sharedSDK];
    
    // Dict to set custom ad options
    NSDictionary* options = @{VunglePlayAdOptionKeyIncentivized: @YES,
                              VunglePlayAdOptionKeyIncentivizedAlertBodyText : @"If the video isn't completed you won't get your reward! Are you sure you want to close early?",
                              VunglePlayAdOptionKeyIncentivizedAlertCloseButtonText : @"Close",
                              VunglePlayAdOptionKeyIncentivizedAlertContinueButtonText : @"Keep Watching",
                              VunglePlayAdOptionKeyIncentivizedAlertTitleText : @"Careful!"};
    
    // Pass in dict of options, play ad
    NSError *error;
    [sdk playAd:[[[UIApplication sharedApplication] keyWindow] rootViewController] withOptions:options error:&error];
    if (error) {
        NSLog(@"Error encountered playing ad: %@", error);
    }
}

#pragma mark - VungleSDK Delegate

- (void)vungleSDKAdPlayableChanged:(BOOL)isAdPlayable {
    if (isAdPlayable) {
        NSLog(@"An ad is available for playback");
        sendVungleEvent("adsavailible");
        
    } else {
        NSLog(@"No ads currently available for playback");
        sendVungleEvent("noadsavailible");
    }
}

- (void)vungleSDKwillShowAd {
    NSLog(@"An ad is about to be played!");
    //Use this delegate method to pause animations, sound, etc.
    
    if (showedVideo) {
        sendVungleEvent("videowillshow");
    }else if (showedRewarded){
        sendVungleEvent("rewardedwillshow");
    }
}

- (void) vungleSDKwillCloseAdWithViewInfo:(NSDictionary *)viewInfo willPresentProductSheet:(BOOL)willPresentProductSheet {
    if (willPresentProductSheet) {
        //In this case we don't want to resume animations and sound, the user hasn't returned to the app yet
        NSLog(@"The ad presented was tapped and the user is now being shown the App Product Sheet");
        sendVungleEvent("clicked");
        
        NSLog(@"ViewInfo Dictionary:");
        for(NSString * key in [viewInfo allKeys]) {
            NSLog(@"%@ : %@", key, [[viewInfo objectForKey:key] description]);
            
            if (showedRewarded) {
                if ([key isEqualToString:@"completedView"]) {
                    if ([[[viewInfo objectForKey:key] description] isEqualToString:@"1"]) {
                        NSLog(@"Ad is fully watched");
                        showedRewarded = NO;
                        sendVungleEvent("rewardedwatched");
                        rewardedClosed = YES;
                    }else{
                        NSLog(@"Ad is not fully watched");
                        showedRewarded = NO;
                        sendVungleEvent("rewardednotwatched");
                        rewardedClosed = YES;
                    }
                }
            }else if (showedVideo){
                showedVideo = NO;
                sendVungleEvent("videoclosed");
            }
            
            if (rewardedClosed) {
                NSLog(@"Rewarded closed");
                rewardedClosed = NO;
                sendVungleEvent("rewardedclosed");
            }
        }
    } else {
        //In this case the user has declined to download the advertised application and is now returning fully to the main app
        //Animations / Sound / Gameplay can be resumed now
        NSLog(@"The ad presented was not tapped - the user has returned to the app");
        NSLog(@"ViewInfo Dictionary:");
        for(NSString * key in [viewInfo allKeys]) {
            NSLog(@"%@ : %@", key, [[viewInfo objectForKey:key] description]);
            
            if (showedRewarded) {
                if ([key isEqualToString:@"completedView"]) {
                    if ([[[viewInfo objectForKey:key] description] isEqualToString:@"1"]) {
                        NSLog(@"Ad is fully watched");
                        showedRewarded = NO;
                        sendVungleEvent("rewardedwatched");
                        rewardedClosed = YES;
                    }else{
                        NSLog(@"Ad is not fully watched");
                        showedRewarded = NO;
                        sendVungleEvent("rewardednotwatched");
                        rewardedClosed = YES;
                    }
                }
            }else if (showedVideo){
                showedVideo = NO;
                sendVungleEvent("videoclosed");
            }
            
            if (rewardedClosed) {
                NSLog(@"Rewarded closed");
                rewardedClosed = NO;
                sendVungleEvent("rewardedclosed");
            }
        }
    }
}

- (void)vungleSDKwillCloseProductSheet:(id)productSheet {
    NSLog(@"The user has downloaded an advertised application and is now returning to the main app");
    //This method can be used to resume animations, sound, etc. if a user was presented a product sheet earlier
    sendVungleEvent("hasdownloaded");
    
    if (showedVideo) {
        sendVungleEvent("videoclosed");
    }else if (showedRewarded){
        sendVungleEvent("rewardedclosed");
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

        // VIDEO
        [vungleController initWithID:appID];
    }
    

    void showVideo()
    {
        if(vungleController!=NULL) [vungleController showVideoAd];
    }
    
    void showRewarded()
    {
        if(vungleController!=NULL) [vungleController showRewardedAd];
    }
    
    
}
