//
//  HBScore.h
//  HBLib
//
//  Created by Zhaoyi on 12-10-15.
//  Copyright (c) 2012年 HappyBluefin. All rights reserved.
//

#ifndef _HBOffer_H_
#define _HBOffer_H_

typedef enum
{
    HBOffer_AdsMogo,
} HBOfferToPlatform;

class HBOffer
{
public:
    static void openOffer(HBOfferToPlatform platform);
};

#endif // _HBOffer_H_
