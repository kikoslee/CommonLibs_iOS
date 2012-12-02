//
//  AdMoGoAdapterAdwo.h
//  TestMOGOSDKAPP
//
//  Created by MOGO on 12-10-26.
//  Copyright (c) 2012年 Mogo. All rights reserved.
//


#import "AdMoGoAdNetworkAdapter.h"
#import "AWAdView.h"

@interface AdMoGoAdapterAdwo :AdMoGoAdNetworkAdapter<AWAdViewDelegate>{
    
    BOOL isStop;
    CGRect frame;
    AWAdView *adView;
    
}

@end
