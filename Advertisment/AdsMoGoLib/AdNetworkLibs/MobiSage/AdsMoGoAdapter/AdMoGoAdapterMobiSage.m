//  File: AdMoGoAdapterMobiSage.m
//  Project: AdsMOGO iOS SDK
//  Version: 1.1.9
//  Copyright 2011 AdsMogo.com. All rights reserved.


#import "AdMoGoAdapterMobiSage.h"
//#import "AdMoGoView.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoDeviceInfoHelper.h"

@implementation AdMoGoAdapterMobiSage
+ (AdMoGoAdNetworkType)networkType {
	return AdMoGoAdNetworkTypeMobiSage;
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
    switch (type) {
        case AdViewTypeNormalBanner:
        case AdViewTypeiPadNormalBanner:
            adIndex = Ad_320X40;
            size = CGSizeMake(320, 40);
            break;
        case AdViewTypeRectangle:
            adIndex = Ad_320X270;
            size = CGSizeMake(320, 270);
            break;
        case AdViewTypeMediumBanner:
            adIndex = Ad_480X40;
            size = CGSizeMake(480, 40);
            break;
        case AdViewTypeLargeBanner:
            adIndex = Ad_748X110;
            size = CGSizeMake(748, 110);
            break;
        default:
            break;
    }
    
    timer = [[NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    
    
    MobiSageAdBanner *adView = [[MobiSageAdBanner alloc] initWithAdSize:adIndex PublisherID:[self.ration objectForKey:@"key"]];
    [adView setInterval:Ad_NO_Refresh];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    [view addSubview:adView];
    self.adNetworkView = view;
    [view release];
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self];

    
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
