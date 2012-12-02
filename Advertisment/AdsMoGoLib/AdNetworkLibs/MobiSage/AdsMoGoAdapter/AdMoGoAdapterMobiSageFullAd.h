//
//  AdMoGoAdapterMobiSageFullAd.h
//  TestMOGOSDKAPP
//
//  Created by MOGO on 12-8-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AdMoGoAdNetworkAdapter.h"
#import "MobiSageSDK.h"
@interface AdMoGoAdapterMobiSageFullAd : AdMoGoAdNetworkAdapter
{
    NSTimer *timer;
    BOOL isStop;
}

+ (AdMoGoAdNetworkType)networkType;

- (void)adStartShow:(id)sender;
- (void)adPauseShow:(id)sender;
- (void)adPop:(id)sender;
- (void)adHide:(id)sender;

- (void)loadAdTimeOut:(NSTimer*)theTimer;

@end
