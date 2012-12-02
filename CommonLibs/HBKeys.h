//
//  HBKeys.h
//  HBLib
//
//  Created by Limin on 12-10-6.
//  Copyright (c) 2012年 HappyBluefin. All rights reserved.
//

#ifndef _HBKeys_H_
#define _HBKeys_H_

// 广告
#define kAdsMogoKey "9c4ea160effa4178bcb3122d36a2282b"
#define kAdsMogoKey_iPad "2bed0eadef4a493ea36380d98045b12c"

// 广告平台id
#define HBAdKeyIOS_Adwo "81dd73b04d1c413680ba9483db41b7e2"
#define HBAdKeyIOS_Admob "a14dd7f01ef0894"
#define HBAdKeyIOS_Mobisage "a1ff9b67a24f4d35bfaa405ae0a5172d"
//#define HBAdKeyIOS_Ader "a1ff9b67a24f4d35bfaa405ae0a5172d"

// 友盟
#define UMENG_KEY "506dd2e85270150c9f0000e7"

#if DEBUG
#define UMENG_CHANNEL "Test Mode"
#else
#if HBCHANNEL == 1
#define UMENG_CHANNEL "App Store"
#elif HBCHANNEL == 2
#define UMENG_CHANNEL "91Store"
//#define UMENG_CHANNEL "91BBS"
//#define UMENG_CHANNEL "51ipa"
//#define UMENG_CHANNEL "BeiKe"
//#define UMENG_CHANNEL "TongBu"
//#define UMENG_CHANNEL "WeiPhone"
//#define UMENG_CHANNEL "PP"
#else
#error "not define HBCHANNEL in preprocess"
#endif
#endif

// 新浪微博
#define kWBAppKey           "2527422900"
#define kWBAppSecret        "42472858c47693762b4a3dcfcdeceadf"
#define kWBAppURL           "http://"

// 腾讯微博
#define kQQAppKey           "801237739"
#define kQQAppSecret        "85507f7d11b18aa4b3797749698d4599"
#define kQQRedirectUri      "http://www.happybluefin.com"

// iOS应用ID
#define kAppIDiOS           "439612162"


#endif
