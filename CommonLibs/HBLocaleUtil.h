//
//  HBLocaleUtil.h
//  HBLib
//
//  Created by Limin on 12-10-6.
//  Copyright (c) 2012年 HappyBluefin. All rights reserved.
//

#ifndef _HBLocaleUtil_H_
#define _HBLocaleUtil_H_

#include "HBSingleton.h"

class HBLocaleUtil : public HBSingleton<HBLocaleUtil>
{
public:
    static bool isChinese();
    static const char* getCountryCode();
    static const char* getLanguageCode();
};

#endif
