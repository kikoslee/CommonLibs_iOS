//
//  AWAdView.h
//  AdwoSDK3.0
//
//  Created by zenny_chen on 12-8-17.
//  Copyright (c) 2012年 zenny_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AWAdViewAttributes;
@class AWAdView;


enum ADWO_ADSDK_AD_TYPE
{
    /** Banner types */
    // For normal banner(320x50)
    ADWO_ADSDK_AD_TYPE_NORMAL_BANNER = 1,
    
    // For banner on iPad
    ADWO_ADSDK_AD_TYPE_BANNER_SIZE_FOR_IPAD_320x50 = 10,
    ADWO_ADSDK_AD_TYPE_BANNER_SIZE_FOR_IPAD_640x100,
    ADWO_ADSDK_AD_TYPE_BANNER_SIZE_FOR_IPAD_720x110,
    
    /** Full-screen types */
    ADWO_ADSDK_AD_TYPE_FULL_SCREEN = 100
};

enum ADWOSDK_SPREAD_CHANNEL
{
    ADWOSDK_SPREAD_CHANNEL_APP_STORE,
    ADWOSDK_SPREAD_CHANNEL_91_STORE
};

enum ADWOSDK_AGGREGATION_CHANNEL
{
    ADWOSDK_AGGREGATION_CHANNEL_NONE,
    ADWOSDK_AGGREGATION_CHANNEL_GUOHEAD,
    ADWOSDK_AGGREGATION_CHANNEL_ADVIEW,
    ADWOSDK_AGGREGATION_CHANNEL_MOGO,
    ADWOSDK_AGGREGATION_CHANNEL_ADWHIRL,
    ADWOSDK_AGGREGATION_CHANNEL_ADSAGE
};


@protocol AWAdViewDelegate <NSObject>

@optional

- (void)adwoAdViewDidFailToLoadAd:(AWAdView*)adView;
- (void)adwoAdViewDidLoadAd:(AWAdView*)adView;
- (void)adwoFullScreenAdDismissed:(AWAdView*)adView;
- (void)adwoDidPresentModalViewForAd:(AWAdView*)adView;
- (void)adwoDidDismissModalViewForAd:(AWAdView*)adView;

@end


@interface AWAdView : UIView
{
@private
    
    NSInteger adRequestTimeIntervel;
    NSInteger adSlotID;
    NSObject<AWAdViewDelegate> *delegate;
    enum ADWOSDK_SPREAD_CHANNEL spreadChannel;
    
@public
    
    AWAdViewAttributes *attrs;
}

// 广告请求时间间隔
@property(assign, nonatomic) NSInteger adRequestTimeIntervel;

// 广告位ID
@property(assign, nonatomic) NSInteger adSlotID;

// 主要推广渠道
@property(assign, nonatomic) enum ADWOSDK_SPREAD_CHANNEL spreadChannel;

// AWAdView代理
@property(assign, nonatomic) NSObject<AWAdViewDelegate> *delegate;


- (id)initWithAdwoPid:(NSString *)pid adTestMode:(BOOL)isReleaseMode;

- (BOOL)loadAd:(enum ADWO_ADSDK_AD_TYPE)adType;

- (BOOL)showFullScreenAd:(UIView*)baseView orientation:(UIInterfaceOrientation)currOrientation;
- (void)orientationChanged:(UIInterfaceOrientation)orientation;

- (void)pauseAd;

- (void)resumeAd;

@end


