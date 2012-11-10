//
//  HBUmeng.cpp
//  HBLib
//
//  Created by Limin on 12-10-6.
//  Copyright (c) 2012年 HappyBluefin. All rights reserved.
//

#include "HBUmeng.h"

#import "MobClick.h"

void HBUmeng::startup()
{
    NSString* key = [NSString stringWithFormat:@"%s", UMENG_KEY];
    NSString* channel = [NSString stringWithFormat:@"%s", UMENG_CHANNEL];
    [MobClick startWithAppkey:key reportPolicy:REALTIME channelId:channel];
    [MobClick checkUpdate];
}

void HBUmeng::event(const char* name, const char* value)
{
#if DEBUG
#else
    NSString* key = [NSString stringWithFormat:@"%s", name];
    
    if (value)
    {
        NSString* v = [NSString stringWithFormat:@"%s", value];
        [MobClick event:key label:v];
    }
    else
        [MobClick event:key];
#endif
}

void HBUmeng::updateConfig()
{
    [MobClick updateOnlineConfig];
}

int HBUmeng::getParamValue(const char* name)
{
    NSString* key = [NSString stringWithFormat:@"%s", name];
    NSString* value = [MobClick getConfigParams:key];
    
    if (value)
        return [value intValue];
    else
        return -1;
}
