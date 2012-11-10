//
//  HBUtiliOS.h
//  HBLib
//
//  Created by Limin on 12-9-16.
//  Copyright (c) 2012年 HappyBluefin. All rights reserved.
//

@interface HBUtiliOS : NSObject

// 解析字符串
+ (NSString*)getStringFromUrl:(NSString*)url needle:(NSString*)needle;

// 显示对话框
+ (void)showMessageBox:(NSString*)content;

// 生成URL
+ (NSString*)generateURL:(NSString*)baseUrl params:(NSDictionary*)params httpMethod:(NSString*)httpMethod;

@end
