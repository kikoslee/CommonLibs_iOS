//
//  HBScore.h
//  HBLib
//
//  Created by Limin on 12-9-11.
//  Copyright (c) 2012年 HappyBluefin. All rights reserved.
//

#ifndef _HBScore_H_
#define _HBScore_H_

class HBScore
{
public:
    static void initScore();

    static void showBoard(const char* boardName);
    static void reportScore(const char* boardName, int score);
};

#endif
