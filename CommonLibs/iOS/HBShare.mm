//
//  HBShare_ios.mm
//  HBLib
//
//  Created by Limin on 12-9-12.
//  Copyright (c) 2012年 HappyBluefin. All rights reserved.
//

#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS

#include "HBShare.h"
#import "HBShareSina.h"
#import "HBShareQQ.h"
#import "HBShareFacebook.h"
#import "HBUtiliOS.h"

#import "AppController.h"

#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
#import "Twitter/TWTweetComposeViewController.h"
#endif

void HBShare::shareTo(HBShareToPlatform platform, const char* msg, CCObject* target, SEL_CallFunc selector)
{
    assert(msg);

    if(target && selector)
    {
        _target = target;
        _selector = selector;
    }
    
    BOOL isCallback = target ? YES : NO;
    
    switch (platform)
    {
        case HBShare_Sina:
            [[HBShareSina shared] sendMessage:msg callBack:isCallback];
            break;
        case HBShare_QQ:
            [[HBShareQQ shared] sendMessage:msg callBack:isCallback];
            break;
        case HBShare_Facebook:
            [[HBShareFacebook shared] sendMessage:msg callBack:isCallback];
            break;
        case HBShare_Twitter:
            _shareToTwitter(msg, isCallback);
            break;
        default:
            assert(false);
            break;
    }
}

void HBShare::doCallback()
{
    assert(_target);
    assert(_selector);

    (_target->*_selector)();
}

void HBShare::_shareToTwitter(const char* msg, bool isCallback)
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 5.0)
    {
        [HBUtiliOS showMessageBox:@"Not support iOS version under 5.0"];
    }
    else
    {
        TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];

        [twitter setInitialText:[NSString stringWithUTF8String:msg]];

        AppController* app = (AppController*)[UIApplication sharedApplication].delegate;
        UIViewController* vc = (UIViewController*)app.viewController;        
        [vc presentViewController:twitter animated:YES completion:nil];
        [twitter release];

        twitter.completionHandler = ^(TWTweetComposeViewControllerResult res)
        {
            if(res == TWTweetComposeViewControllerResultDone)
            {
                [HBUtiliOS showMessageBox:@"Tweet Success"];
                if (isCallback)
                    doCallback();
            }
            [vc dismissModalViewControllerAnimated:YES];
        };    
    }
}

#endif