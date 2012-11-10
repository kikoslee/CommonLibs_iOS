//
//  HBWebBrowser_ios.cpp
//  HBLib
//
//  Created by Zhaoyi on 12-9-18.
//  Copyright (c) 2012N HappyBluefin. All rights reserved.
//

#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS

#include "HBWebBrowser.h"

void HBWebBrowser::gotoUrl(const char* url)
{
    NSString* u = [NSString stringWithFormat:@"%s", url];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:u]];
}

#endif // CC_PLATFORM_ANDROID
