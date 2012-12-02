//
//  AdMoGoAdapterAdwoFullAd.m
//  TestMOGOSDKAPP
//
//  Created by Daxiong on 12-10-29.
//
//

#import "AdMoGoAdapterAdwoFullAd.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoConfigDataCenter.h"

@implementation AdMoGoAdapterAdwoFullAd

+ (AdMoGoAdNetworkType)networkType {
	return AdMoGoAdNetworkTypeAdwoFullAd;
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
    
    //this class only have full screen type.
    if(type == AdViewTypeFullScreen){
        adwo_ad_type = ADWO_ADSDK_AD_TYPE_FULL_SCREEN;
    }else{
        [adMoGoCore adapter:self didFailAd:nil];
        return;
    }
    
    // init AWAdView
    NSString *pid = [self.ration objectForKey:@"key"];
    BOOL testMode = [[self.ration objectForKey:@"testmodel"] intValue];
    adView = [[AWAdView alloc] initWithAdwoPid:pid adTestMode:testMode];
    if(adView == nil)
    {
        [adMoGoCore adapter:self didFailAd:nil];
        return;
    }
    adView.delegate = self;

    [adView loadAd:ADWO_ADSDK_AD_TYPE_FULL_SCREEN];
    
}

#pragma mark - AWAdView delegates

- (void)adwoAdViewDidFailToLoadAd:(AWAdView*)ad
{
    [adMoGoCore adapter:self didFailAd:nil];
    if (adView) {
        adView.delegate = nil;
        [adView release],adView = nil;
    }

}

- (void)adwoAdViewDidLoadAd:(AWAdView*)ad
{
    NSLog(@"Ad did load!");
    
    if(![self.adMoGoDelegate viewControllerForPresentingModalView]){
        
        [adMoGoCore adapter:self didFailAd:nil];
        if (adView) {
            adView.delegate = nil;
            [adView release],adView = nil;
        }
        NSLog(@"please add viewControllerForPresentingModalView delegate");
    }
    
    if(fullAdController){
        [fullAdController release],fullAdController = nil;
    }
    fullAdController = [[AdMoGoAdapterAdwoController alloc]init];
    // 广告加载成功，可以把全屏广告展示上去
    [adView showFullScreenAd:fullAdController.view orientation:fullAdController.interfaceOrientation];
    
    [[self.adMoGoDelegate viewControllerForPresentingModalView] presentModalViewController:fullAdController animated:NO];
    [self helperNotifyDelegateOfFullScreenAdModal];
}

- (void)adwoFullScreenAdDismissed:(AWAdView*)ad
{
//    NSLog(@"Full-screen ad closed by user!");
    
    [[self.adMoGoDelegate viewControllerForPresentingModalView] dismissModalViewControllerAnimated:NO];
    [self helperNotifyDelegateOfFullScreenAdModalDismissal];

}

- (void)adwoDidPresentModalViewForAd:(AWAdView*)ad
{
    NSLog(@"Browser presented!");
}

- (void)adwoDidDismissModalViewForAd:(AWAdView*)ad
{
    NSLog(@"Browser dismissed!");
}



-(void)stopAd{
    [self stopBeingDelegate];
}

-(void)stopBeingDelegate{
    isStop = YES;
}

-(void)dealloc{
    [super dealloc];
}
@end
