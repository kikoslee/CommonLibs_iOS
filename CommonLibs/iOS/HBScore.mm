//
//  HBScore.cpp
//  HBLib
//
//  Created by Limin on 12-9-11.
//  Copyright (c) 2012年 HappyBluefin. All rights reserved.
//

#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS

#import "HBScore.h"
#import "HBGameCenter.h"

void HBScore::initScore()
{
    [HBGameCenter shared];
}

void HBScore::showBoard(const char* boardName)
{
    assert(boardName);
    assert(strlen(boardName) > 0);
    
    [[HBGameCenter shared] showLeaderboard:[NSString stringWithFormat:@"%s", boardName]];
}

void HBScore::reportScore(const char* boardName, int score)
{
    assert(boardName);
    assert(strlen(boardName) > 0);

    [[HBGameCenter shared] reportScoreTo:[NSString stringWithFormat:@"%s", boardName] withScore:score];
}

#endif
