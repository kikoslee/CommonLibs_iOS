//
//  HBUtiliOS.m
//  HBLib
//
//  Created by Limin on 12-9-16.
//  Copyright (c) 2012年 HappyBluefin. All rights reserved.
//

#import "HBUtiliOS.h"
#import "HBUtilies.h"
#import "HBKeys.h"

@implementation HBUtiliOS

+ (NSString*)getStringFromUrl:(NSString*)url needle:(NSString*)needle
{
	NSString* str = nil;
	NSRange start = [url rangeOfString:needle];
	if (start.location != NSNotFound)
    {
		NSRange end = [[url substringFromIndex:start.location + start.length] rangeOfString:@"&"];
		NSUInteger offset = start.location + start.length;
		str = end.location == NSNotFound ? [url substringFromIndex:offset] : [url substringWithRange:NSMakeRange(offset, end.location)];
		str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	}
	
	return str;
}

+ (void)showMessageBox:(NSString*)content
{	
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"系统提示", @"") message:content delegate:self cancelButtonTitle:NSLocalizedString(@"确定", @"") otherButtonTitles:nil];
	[alert show];
	[alert release];
}

+ (NSString*)generateURL:(NSString*)baseUrl params:(NSDictionary*)params httpMethod:(NSString*)httpMethod 
{
	NSURL* parsedUrl = [NSURL URLWithString:baseUrl];
	NSString* queryPrefix = parsedUrl.query ? @"&" : @"?";
	
	NSMutableArray* pairs = [NSMutableArray array];
	for (NSString* key in [params keyEnumerator]) 
    {
		if (([[params valueForKey:key] isKindOfClass:[UIImage class]]) ||
            ([[params valueForKey:key] isKindOfClass:[NSData class]])) 
        {
			if ([httpMethod isEqualToString:@"GET"]) 
            {
				NSLog(@"can not use GET to upload a file");
			}
			continue;
		}
		
		NSString* escaped_value = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)[params objectForKey:key], NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
		
		[pairs addObject:[NSString stringWithFormat:@"%@=%@", key, escaped_value]];
		[escaped_value release];
	}
	NSString* query = [pairs componentsJoinedByString:@"&"];
	
	return [NSString stringWithFormat:@"%@%@%@", baseUrl, queryPrefix, query];
}

@end

void HBSetRatioScale(CCSprite* sprite)
{
    CCRect rc = sprite->getTextureRect();

    CCSize s = CCDirector::sharedDirector()->getWinSize();
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        s = CCSizeMake(s.width / 2 / 320.f, s.height / 2 / 480.f);
    else
        s = CCSizeMake(s.width / 320.f, s.height / 480.f);;

    sprite->setScaleX(s.width);
    sprite->setScaleY(s.height);
}

CCPoint ccpRatio(float x, float y)
{
    CCSize s = CCDirector::sharedDirector()->getWinSize();
    
    return ccp(x * s.width / 320.f, y * s.height / 480.f);
}

CCPoint ccpRatio2(float x, float y)
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return ccp(x*2, y*2);
    else
        return ccp(x, y);
}

CCRect HBRectRatio(float x, float y, float w, float h)
{
    CCSize s = CCDirector::sharedDirector()->getWinSize();
    
    float ratiox = s.width / 320.f;
    float ratioy = s.height / 480.f;

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return CCRectMake(x * ratiox, y * ratioy, w * 2, h * 2);
    else
        return CCRectMake(x * ratiox, y * ratioy, w, h);
}

CCRect ccRectRatio2(float x, float y, float w, float h)
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return CCRectMake(x*2, y*2, w * 2, h * 2);
    else
        return CCRectMake(x, y, w, h);
}

int ccFontRatio(int size)
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return size << 1;
    else
        return size;
}

const char* getLocalizedString(const char* str)
{
	NSString* strName = [NSString stringWithFormat:@"%s", str];
	strName = NSLocalizedString(strName, nil);
	return [strName cStringUsingEncoding:NSUTF8StringEncoding];
}

void HBUtilies::gotoReview()
{
    NSString *str = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%s", kAppIDiOS];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}