//
//  HBShare.h
//  HBLib
//
//  Created by Limin on 12-9-12.
//  Copyright (c) 2012年 HappyBluefin. All rights reserved.
//

#ifndef _HBShare_H_
#define _HBShare_H_

#include "cocos2d.h"
using namespace cocos2d;

#include "HBSingleton.h"

typedef enum
{
    HBShare_Sina,
    HBShare_QQ,
    HBShare_Facebook,
    HBShare_Twitter,
} HBShareToPlatform;

class HBShare : public HBSingleton<HBShare>
{
    CCObject* _target;
    SEL_CallFunc _selector;
    
    void _shareToTwitter(const char* msg, bool isCallback);
    
public:
    void shareTo(HBShareToPlatform platform, const char* msg, CCObject* target = 0, SEL_CallFunc selector = 0);

    void doCallback();
    
};

#endif
