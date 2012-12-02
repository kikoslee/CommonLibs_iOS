//
//  AdMoGoAdapterMobiSageFullAd.m
//  TestMOGOSDKAPP
//
//  Created by MOGO on 12-8-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AdMoGoAdapterMobiSageFullAd.h"
#import "AdMoGoAdapterMobiSage.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoDeviceInfoHelper.h"
#import "MobisageFullScreenAdViewController.h"
@implementation AdMoGoAdapterMobiSageFullAd

+ (AdMoGoAdNetworkType)networkType {
	return AdMoGoAdNetworkTypeMobiSageFullAd;
}

+ (void)load {
	[[AdMoGoAdNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    
    isStop = NO;
    
    [adMoGoCore adDidStartRequestAd];
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:adMoGoCore.config_key];
    
	[adMoGoCore adapter:self didGetAd:@"mobisage"];
    
    //    AdViewType type = adMoGoView.adType;
    AdViewType type =[configData.ad_type intValue];
    
    CGSize size =CGSizeMake(0, 0);
    NSUInteger adIndex = 0;
    if (type == AdViewTypeFullScreen) {
        adIndex = Poster_320X460;
        size = CGSizeMake(320.0, 460.0);
        
    }
    else {
        [adMoGoCore adapter:self didFailAd:nil];
        return;
    }
    
    timer = [[NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    
    
    MobiSageAdPoster *adView = [[MobiSageAdPoster alloc] initWithAdSize:adIndex PublisherID:[self.ration objectForKey:@"key"]];
//    [adView setInterval:Ad_NO_Refresh];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    [view addSubview:adView];
    self.adNetworkView = view;
    [view release];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(adStartShow:) 
                                                 name:MobiSageAdView_Start_Show_AD 
                                               object:adView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(adPauseShow:) 
                                                 name:MobiSageAdView_Pause_Show_AD
                                               object:adView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(adPop:) 
                                                 name:MobiSageAdView_Pop_AD_Window
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(adHide:) 
                                                 name:MobiSageAdView_Hide_AD_Window
                                               object:nil];
    
    [adView startRequestAD];
    [adView release];
}

- (void)stopBeingDelegate {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)stopAd{
    [self stopBeingDelegate];
    isStop = YES;
    [self stopTimer];
}

- (void)stopTimer {
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
}

- (void)dealloc {
	[super dealloc];
}

- (void)adStartShow:(NSNotification *)notification {
    
    if (isStop) {
        return;
    }
    
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
    [adMoGoCore adapter:self didReceiveAdView:self.adNetworkView];
    UIViewController *mobisageviewController = [[MobisageFullScreenAdViewController alloc] init];
    [mobisageviewController.view addSubview:self.adNetworkView];
    UIViewController *rootviewController = [adMoGoDelegate viewControllerForPresentingModalView];
    [rootviewController presentModalViewController:mobisageviewController  animated:YES];
}

- (void)adPauseShow:(NSNotification *)notification {
    
}

- (void)adPop:(NSNotification *)notification {
    if (isStop) {
        return;
    }
    [adMoGoCore stopTimer];
    [self helperNotifyDelegateOfFullScreenModal];
}

- (void)adHide:(NSNotification *)notification {
    if (isStop) {
        return;
    }
    [adMoGoCore fireTimer];
    [self helperNotifyDelegateOfFullScreenModalDismissal];
}

- (void)loadAdTimeOut:(NSTimer*)theTimer {
    
    if (isStop) {
        return;
    }
    
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
    [adMoGoCore adapter:self didFailAd:nil];
}

@end
