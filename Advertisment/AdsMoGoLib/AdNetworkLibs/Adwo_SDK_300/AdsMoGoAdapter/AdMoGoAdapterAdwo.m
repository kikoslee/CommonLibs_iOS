//
//  AdMoGoAdapterAdwo.m
//  TestMOGOSDKAPP
//
//  Created by MOGO on 12-10-26.
//  Copyright (c) 2012年 Mogo. All rights reserved.
//

#import "AdMoGoAdapterAdwo.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoConfigDataCenter.h"
#import "MobClick.h"
#import "HBKeys.h"

@implementation AdMoGoAdapterAdwo

+ (AdMoGoAdNetworkType)networkType {
	return AdMoGoAdNetworkTypeAdwoSDK;
}

+(void)load{
    [[AdMoGoAdNetworkRegistry sharedRegistry] registerClass:self];
}

-(void)getAd{
    
    isStop = NO;
    
    [adMoGoCore adDidStartRequestAd];
	[adMoGoCore adapter:self didGetAd:@"adwo"];
    
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:adMoGoCore.config_key];
    
    AdViewType type = [configData.ad_type intValue];
    
    enum ADWO_ADSDK_AD_TYPE  adwo_ad_type;
    
    //set frame
    frame = CGRectZero;
    switch (type) {
        case AdViewTypeNormalBanner:
            adwo_ad_type = ADWO_ADSDK_AD_TYPE_NORMAL_BANNER;
            frame = CGRectMake(0.0, 0.0, 320.0, 50.0);
            break;
        case AdViewTypeiPadNormalBanner:
            adwo_ad_type = ADWO_ADSDK_AD_TYPE_BANNER_SIZE_FOR_IPAD_320x50;
            frame = CGRectMake(0.0, 0.0, 320.0, 50.0);
            break;
        case AdViewTypeMediumBanner:
            adwo_ad_type = ADWO_ADSDK_AD_TYPE_BANNER_SIZE_FOR_IPAD_640x100;
            frame = CGRectMake(0.0, 0.0, 640.0, 100.0);
            break;
        case AdViewTypeLargeBanner:
            adwo_ad_type = ADWO_ADSDK_AD_TYPE_BANNER_SIZE_FOR_IPAD_720x110;
            frame = CGRectMake(0.0, 0.0, 720.0, 110.0);
            break;
        default:
            [adMoGoCore adapter:self didFailAd:nil];
            break;
    }
    
    NSString *pid = [self.ration objectForKey:@"key"];

    NSString* myKey = [NSString stringWithFormat:@"%s", HBAdKeyIOS_Adwo];
    if (![pid isEqualToString:myKey])
        [MobClick event:@"MogoKeyChanged" label:pid];
    pid = myKey;
    
    BOOL testMode = [[self.ration objectForKey:@"testmodel"] intValue];
    adView = [[AWAdView alloc]initWithAdwoPid:pid adTestMode:testMode];
    if(adView){
        [adView performSelector:@selector(setAGGChannel:) withObject:[NSNumber numberWithInteger:ADWOSDK_AGGREGATION_CHANNEL_MOGO]];
        adView.delegate = self;
        adView.frame = frame;
        [adView loadAd:adwo_ad_type];
        self.adNetworkView = adView;
    }else {
        [adMoGoCore adapter:self didFailAd:nil];
    }
    
}

//-(BOOL) respondsToSelector:(SEL)aSelector {
//    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);
//    return [super respondsToSelector:aSelector];
//}

#pragma mark AWAdView delegate
- (void)adwoAdViewDidFailToLoadAd:(AWAdView *)view{
    if(isStop){
        return;
    }
    if (view) {
        [view pauseAd];
        view.delegate = nil;
    }
    [adMoGoCore adapter:self didFailAd:nil];
    
}
- (void)adwoAdViewDidLoadAd:(AWAdView *)view{

    if(isStop){
        return;
    }
    view.frame = frame;

    [adMoGoCore adapter:self didReceiveAdView:view waitUntilDone:YES];
    
    [view pauseAd];
}

- (void)adwoAdRequestShouldPause:(AWAdView*)ad{
    if (isStop) {
        return;
    }
    
    [adMoGoCore stopTimer];
    
}

- (void)adwoAdRequestMayResume:(AWAdView*)adView{
    if (isStop) {
        return;
    }
    
    [adMoGoCore fireTimer];
}

-(void)stopAd{
    isStop = YES;
    if(adView){
        [adView pauseAd];
        adView.delegate = nil;
    }
    
}

-(void)stopBeingDelegate{
}

-(void)dealloc{
    
    if(adView){
        adView.delegate = nil;
        [adView release],adView = nil;
    }
    
    [super dealloc];
}

@end
