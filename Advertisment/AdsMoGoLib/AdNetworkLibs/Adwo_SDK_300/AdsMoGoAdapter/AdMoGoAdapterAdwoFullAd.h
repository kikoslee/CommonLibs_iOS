//
//  AdMoGoAdapterAdwoFullAd.h
//  TestMOGOSDKAPP
//
//  Created by Daxiong on 12-10-29.
//
//

#import "AdMoGoAdNetworkAdapter.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AWAdView.h"
#import "AdMoGoAdapterAdwoController.h"
@interface AdMoGoAdapterAdwoFullAd:AdMoGoAdNetworkAdapter<AWAdViewDelegate>{
    BOOL isStop;
    AWAdView *adView;
    AdMoGoAdapterAdwoController *fullAdController;
}

@end
