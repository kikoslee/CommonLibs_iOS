//
//  HBShareQQ.h
//  tapburstfree
//
//  Created by Limin on 12-9-13.
//  Copyright (c) 2012年 HappyBluefin. All rights reserved.
//

#import "OpenApi.h"

@interface HBShareQQ : NSObject<UIWebViewDelegate, UITextViewDelegate>

+ (HBShareQQ*)shared;

- (void)sendMessage:(const char*)msg;
- (void)sendMessage:(const char*)msg callBack:(BOOL)callBack;

@end
