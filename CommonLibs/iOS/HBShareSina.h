//
//  HBShareSina.h
//  HBLib
//
//  Created by Limin on 12-9-12.
//  Copyright (c) 2012年 HappyBluefin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBEngine.h"
#import "WBSendView.h"
#import "HBKeys.h"

@interface HBShareSina : NSObject <WBEngineDelegate, WBSendViewDelegate>
{
    UIActivityIndicatorView* _indicatorView;
    WBEngine* _wbEngine;
    BOOL _needCallback;
}

@property (nonatomic, retain) NSString* message;

+ (HBShareSina*) shared;

- (void)sendMessage:(const char*)msg;
- (void)sendMessage:(const char*)msg callBack:(BOOL)callBack;

@end
