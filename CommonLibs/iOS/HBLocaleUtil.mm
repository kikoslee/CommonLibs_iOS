//
//  HBLocaleUtil.mm
//  HBLib
//
//  Created by Limin on 12-10-6.
//  Copyright (c) 2012年 HappyBluefin. All rights reserved.
//

#include "HBLocaleUtil.h"
#include "HBUtilies.h"

const char* HBLocaleUtil::getCountryCode()
{
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSString* code = [currentLocale objectForKey:NSLocaleCountryCode];
//    NSLog(@"Country Code is %@", code);

    return [code cStringUsingEncoding:NSUTF8StringEncoding];
}

const char* HBLocaleUtil::getLanguageCode()
{
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSString* code = [currentLocale objectForKey:NSLocaleLanguageCode];
//    NSLog(@"Language Code is %@", code);
    
    return [code cStringUsingEncoding:NSUTF8StringEncoding];
}

bool HBLocaleUtil::isChinese()
{
    if (strcmp("cn", getLocalizedString("language")) == 0)
        return true;
    else
        return false;
}