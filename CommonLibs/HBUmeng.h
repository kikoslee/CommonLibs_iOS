//
//  HBUmeng.h
//  HBLib
//
//  Created by Limin on 12-10-6.
//  Copyright (c) 2012年 HappyBluefin. All rights reserved.
//

#ifndef _HBUmeng_H_
#define _HBUmeng_H_

#include "HBSingleton.h"
#include "HBKeys.h"

class HBUmeng : public HBSingleton<HBUmeng>
{
public:
    static void startup();
    static void updateConfig();
    static int getParamValue(const char* name);
    static void event(const char* name, const char* value = NULL);
};


#endif
