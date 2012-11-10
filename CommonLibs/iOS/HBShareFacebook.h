//
//  HBShareFacebook.h
//  HBLib
//
//  Created by Limin on 12-9-19.
//  Copyright (c) 2012年 HappyBluefin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBShareFacebook : NSObject
{
    UIActivityIndicatorView* _indicatorView;
    BOOL _needCallback;
}

+ (HBShareFacebook*) shared;

- (void)sendMessage:(const char*)msg;
- (void)sendMessage:(const char*)msg callBack:(BOOL)callBack;

@end
