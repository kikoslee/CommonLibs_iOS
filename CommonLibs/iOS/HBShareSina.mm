//
//  HBShareSina.m
//  HBLib
//
//  Created by Limin on 12-9-12.
//  Copyright (c) 2012年 HappyBluefin. All rights reserved.
//

#import "HBShareSina.h"
#import "AppController.h"
#import "HBShare.h"
#import "HBUtiliOS.h"

HBShareSina* _sharedHBShareSina = nil;

@interface HBShareSina()

- (void)_trueSend;

@end

@implementation HBShareSina

@synthesize message = _message;

+ (HBShareSina*)shared
{
    if (!_sharedHBShareSina)
        _sharedHBShareSina = [[HBShareSina alloc] init];
    return _sharedHBShareSina;
}

- (void)dealloc
{
    _wbEngine.delegate = nil;
    [_wbEngine release];
    
    [_indicatorView release];
    [_message release];
    
    [super dealloc];
}

- (void)sendMessage:(const char*)msg callBack:(BOOL)callBack
{
    assert(msg);

    NSString* text = [NSString stringWithUTF8String:msg];
    assert(text.length > 0);
    
    self.message = text;
    _needCallback = callBack;
    
    if (!_wbEngine)
    {
        _wbEngine = [[WBEngine alloc] initWithAppKey:[NSString stringWithFormat:@"%s", kWBAppKey] appSecret:[NSString stringWithFormat:@"%s", kWBAppSecret]];
        AppController* app = (AppController*)[UIApplication sharedApplication].delegate;
        _wbEngine.rootViewController = (UIViewController*)app.viewController;
        _wbEngine.delegate = self;
        _wbEngine.redirectURI = [NSString stringWithFormat:@"%s", kWBAppURL];
        _wbEngine.isUserExclusive = NO;
        
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicatorView.center = CGPointMake(160, 240);
        [_wbEngine.rootViewController.view addSubview:_indicatorView];
    }
    
    if (_wbEngine.isLoggedIn && !_wbEngine.isAuthorizeExpired)
    {
        [self _trueSend];
    }
    else
    {
        [_wbEngine logIn];
        [_indicatorView startAnimating];
    }
}

- (void)sendMessage:(const char*)text
{
    [self sendMessage:text callBack:NO];
}

- (void)_trueSend
{
    WBSendView* view = [[WBSendView alloc] initWithAppKey:[NSString stringWithFormat:@"%s", kWBAppKey] appSecret:[NSString stringWithFormat:@"%s", kWBAppSecret] text:_message image:nil];
    view.delegate = self;
    [view show:YES];
    [view release];
}

#pragma mark - WBEngine Delegate
- (void)engineAlreadyLoggedIn:(WBEngine *)engine
{
    [_indicatorView stopAnimating];
    [self _trueSend];
}

- (void)engineDidLogIn:(WBEngine *)engine
{
    [_indicatorView stopAnimating];
    [self _trueSend];
}

- (void)engine:(WBEngine *)engine didFailToLogInWithError:(NSError *)error
{
    [_indicatorView stopAnimating];
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:@"登录失败！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

#pragma mark - WBSendView Delegate

- (void)sendViewDidFinishSending:(WBSendView *)view
{
    [view hide:YES];
    [HBUtiliOS showMessageBox:@"发送成功"];
    if (_needCallback)
        HBShare::shared()->doCallback();
}

- (void)sendView:(WBSendView *)view didFailWithError:(NSError *)error
{
    [view hide:YES];
    [HBUtiliOS showMessageBox:@"发送失败"];
}

- (void)sendViewNotAuthorized:(WBSendView *)view
{
    [view hide:YES];
    [HBUtiliOS showMessageBox:@"发送失败,没有授权"];
}

- (void)sendViewAuthorizeExpired:(WBSendView *)view
{
    [view hide:YES];
    [HBUtiliOS showMessageBox:@"发送失败,授权过期"];
}


@end
