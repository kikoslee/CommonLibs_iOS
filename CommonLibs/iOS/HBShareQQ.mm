//
//  HBShareQQ.m
//  HBLib
//
//  Created by Limin on 12-9-13.
//  Copyright (c) 2012年 HappyBluefin. All rights reserved.
//

#import <QuartzCore/CALayer.h>
#import "HBShareQQ.h"
#import "AppController.h"
#import "HBShare.h"
#import "HBUtiliOS.h"
#import "HBKeys.h"

//腾讯参数
#define kQQOAuth2TokenKey           @"access_token="
#define kQQOAuth2OpenidKey          @"openid="
#define kQQOAuth2OpenkeyKey         @"openkey="
#define kQQOAuth2ExpireInKey        @"expires_in="
#define kQQSendText                 @"http://open.t.qq.com/api/t/add"

#define kQQAuthPrefix               @"authorize"
#define kQQOAuthRequestBaseURL      @"https://open.t.qq.com/cgi-bin/oauth2/"

HBShareQQ* _sharedHBShareQQ = nil;

@interface HBShareQQ()
{
    UIView* _baseView;
    UIWebView* _webView;
    UITextView* _textEdit;
    UILabel* _leftNmu;    
    UIBarButtonItem* _barItemSend;
    
    NSTimeInterval _expireTime;
    
    OpenApi* _openApi;
}

@property (nonatomic, retain) NSString* appKey;
@property (nonatomic, retain) NSString* appSecret;
@property (nonatomic, retain) NSString* redirectUri;
@property (nonatomic, retain) NSString* token;
@property (nonatomic, retain) NSString* tokenSecret;
@property (nonatomic, retain) NSString* openid;
@property (nonatomic, retain) NSString* openkey;

@property (nonatomic, retain) NSString* sendText;

- (BOOL)_isAuthorizeExpired;
- (void)_createView;
- (void)_saveData;
- (void)_doCancel;
- (void)_showView;
- (void)_animationShowStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;

@end

@implementation HBShareQQ

@synthesize appKey = _appKey;
@synthesize appSecret = _appSecret;
@synthesize redirectUri = _redirectUri;
@synthesize token = _token;
@synthesize tokenSecret = _tokenSecret;
@synthesize openid = _openid;
@synthesize openkey = _openkey;
@synthesize sendText = _sendText;

+ (HBShareQQ*)shared
{
    if (!_sharedHBShareQQ)
        _sharedHBShareQQ = [[HBShareQQ alloc] init];
    return _sharedHBShareQQ;
}

- (void)dealloc
{
    [_baseView release];
    [_sendText release];
    [_openApi release];
    [super dealloc];
}

- (id)init
{
    if (self = [super init])
    {
        self.appKey = [NSString stringWithFormat:@"%s", kQQAppKey];
        self.appSecret = [NSString stringWithFormat:@"%s", kQQAppSecret];
        self.redirectUri = [NSString stringWithFormat:@"%s", kQQRedirectUri];
        self.token = @"";
        self.tokenSecret = @"";
        self.openid = @"";
        self.openkey = @"";
        _expireTime = 0;
        _openApi = nil;        
    }
    return self;
}

- (void)_createView
{
    if (_baseView)
    {
        [_baseView removeFromSuperview];
        [_baseView release];
    }
    
    CGRect bounds = [[UIScreen mainScreen] applicationFrame];
    
    _baseView = [[UIView alloc] initWithFrame:bounds];
    
    CGRect rc = bounds;
    rc.size.height = 44;
    UIToolbar* bar = [[UIToolbar alloc] initWithFrame:rc];
    
    UIBarButtonItem* edge = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    edge.width = 3;
    
    UIBarButtonItem* space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    space.title = @"腾讯微博";
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(_doCancel)];
    
    _barItemSend = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"分享", @"") style:UIBarButtonItemStyleDone target:self action:@selector(_doSend)];
    
    [bar setItems:[NSArray arrayWithObjects:edge, cancel, space, _barItemSend, edge, nil]];
    
    [_baseView addSubview:bar];
    [bar release];
    
    rc = bounds;
    rc.size.height -= 44;
    rc.origin.y = 44;
    
    _webView = [[UIWebView alloc] initWithFrame:rc];
    _webView.scalesPageToFit = YES;
    _webView.userInteractionEnabled = YES;
    _webView.delegate = self;
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_baseView addSubview:_webView];
    [_webView release];
    
    _textEdit = [[UITextView alloc] initWithFrame:rc];
    _textEdit.font = [UIFont systemFontOfSize:16];
    _textEdit.text = _sendText;
    _textEdit.delegate = self;
    
    _leftNmu = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, rc.size.width, 30)];
    _leftNmu.textAlignment = UITextAlignmentRight;
    _leftNmu.text = [NSString stringWithFormat:@"%d ", 140 - _sendText.length];
    _textEdit.inputAccessoryView = _leftNmu;
    [_leftNmu release];
    
    [_baseView addSubview:_textEdit];
    [_textEdit release];

    _webView.hidden = YES;
    _textEdit.hidden = YES;

    AppController* app = (AppController*)[UIApplication sharedApplication].delegate;
    UIViewController* vc = (UIViewController*)app.viewController;
    [vc.view addSubview:_baseView];    
    
    if ([_token isEqualToString:@""])
    {
        _webView.hidden = NO;
        _barItemSend.enabled = NO;
        [self _startAuthorize];
    }
    else if([self _isAuthorizeExpired])
    {
        _webView.hidden = NO;
        _barItemSend.enabled = NO;
        [self _startAuthorize];
    }
    else
    {
        _textEdit.hidden = NO;
        _barItemSend.enabled = YES;
        [_textEdit becomeFirstResponder];
    }
}

- (BOOL)_isAuthorizeExpired
{
//    NSLog(@"[QQWeiBo] time since 1970: %lf", [[NSDate date] timeIntervalSince1970]);
    return ([[NSDate date] timeIntervalSince1970] > _expireTime);
}


- (void)sendMessage:(const char *)msg
{
    self.sendText = [NSString stringWithUTF8String:msg];
    [self _showView];
}

- (void)sendMessage:(const char*)msg callBack:(BOOL)callBack
{
    self.sendText = [NSString stringWithUTF8String:msg];    
    [self _showView];
}

- (void)_showView
{
    [self _loadData];
    [self _createView];
        
    CGRect rc = _baseView.frame;
    rc.origin.y = rc.size.height;
    _baseView.frame = rc;
    
    [UIView beginAnimations:@"QQWeiboIn" context:NULL];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDidStopSelector:@selector(_animationShowStop:finished:context:)];
    rc.origin.y = 0;
    _baseView.frame = rc;
    [UIView commitAnimations];
}

- (void)_animationShowStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([animationID isEqualToString:@"QQWeiboIn"])
    {
    }
    else if ([animationID isEqualToString:@"QQWeiboOut"])
    {
        if(_baseView)
        {
            [_baseView removeFromSuperview];
            [_baseView release];
            _baseView = nil;
            _webView = nil;
            _textEdit = nil;
            _leftNmu = nil;
        }
    }
}

- (void)_doCancel
{
    CGRect rc = _baseView.frame;
    [UIView beginAnimations:@"QQWeiboOut" context:NULL];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDidStopSelector:@selector(_animationShowStop:finished:context:)];
    rc.origin.y = _baseView.frame.size.height;
    _baseView.frame = rc;
    [UIView commitAnimations];
}

- (void)_doSend
{
    if (_textEdit.text.length == 0)
    {
        [HBUtiliOS showMessageBox:@"请输入内容"];
        return;
    }
    else if(_textEdit.text.length > 140)
    {
        [HBUtiliOS showMessageBox:@"微博内容不能超过140个字"];
        return;
    }
    
    if (_openApi == nil)
    {
        _openApi = [[OpenApi alloc] initForApi:_appKey appSecret:_appSecret accessToken:_token accessSecret:_tokenSecret openid:_openid oauthType:InWebView];
    }
    
    BOOL result = [_openApi publishWeibo:_textEdit.text jing:@"0" wei:@"0" format:@"json" clientip:@"CLIENTIP" syncflag:@"0"];
    
    if (result == YES)
    {
        [HBUtiliOS showMessageBox:@"发送成功"];
        [_textEdit resignFirstResponder];
        [self _doCancel];
    }
}

- (void)_startAuthorize
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   _appKey, @"client_id",
                                   @"token", @"response_type",
                                   @"2", @"wap",
                                   _redirectUri, @"redirect_uri",
                                   @"ios", @"appfrom",
                                   nil];

    NSString *authorizeURL = [kQQOAuthRequestBaseURL stringByAppendingString:kQQAuthPrefix];
    NSString *loadingURL = [HBUtiliOS generateURL:authorizeURL params:params httpMethod:nil];
	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:loadingURL]];
	
	[_webView loadRequest:request];
}

//记录获取到的用户信息
- (void)_saveData
{
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    
    [info setValue:_token forKey:@"QQAccessToken"];
    [info setValue:_openid forKey:@"QQOpenId"];
    [info setValue:_openkey forKey:@"QQOpenKey"];
    [info setValue:[NSString stringWithFormat:@"%lf", _expireTime] forKey:@"QQExpireTime"];

    [info synchronize];
}

- (void)_loadData
{
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    
    self.token = [info stringForKey:@"QQAccessToken"];
    self.openid = [info stringForKey:@"QQOpenId"];
    self.openkey = [info stringForKey:@"QQOpenKey"];
    _expireTime = [[info stringForKey:@"QQExpireTime"] doubleValue];
//    NSLog(@"[QQWeiBo] token(%@), openid(%@), openkey(%@), expireTime(%lf)", _token, _openid, _openkey, _expireTime);
}

#pragma mark - WebView Delegate

/*
 * 当前网页视图被指示载入内容时得到通知，返回yes开始进行加载
 */
- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{    
    NSURL* url = request.URL;
    
	NSRange start = [url.absoluteString rangeOfString:kQQOAuth2TokenKey];    
    
    // 如果找到tokenkey,就获取其他key的value值
	if (start.location != NSNotFound)
	{
//        NSLog(@"[QQWeiBo] ResultURL:%@", url.absoluteString);
        self.token = [HBUtiliOS getStringFromUrl:url.absoluteString needle:kQQOAuth2TokenKey];
        self.openid = [HBUtiliOS getStringFromUrl:url.absoluteString needle:kQQOAuth2OpenidKey];
        self.openkey = [HBUtiliOS getStringFromUrl:url.absoluteString needle:kQQOAuth2OpenkeyKey];
        int seconds = [[HBUtiliOS getStringFromUrl:url.absoluteString needle:kQQOAuth2ExpireInKey] intValue];
//        NSLog(@"[QQWeiBo] expire seconds:%d", seconds);
        _expireTime = [[NSDate date] timeIntervalSince1970] + seconds;
        
//        NSLog(@"[QQWeiBo] token is %@, openid is %@, expireTime is %f", _token, _openid, _expireTime);
        
        if ((_token == (NSString*)[NSNull null]) || (_token.length == 0) ||
            (_openid == (NSString*)[NSNull null]) || (_openid.length == 0) ||
            (_openkey == (NSString*)[NSNull null]) || (_openkey.length == 0))
        {
            [HBUtiliOS showMessageBox:NSLocalizedString(@"授权失败!", @"")];
        }
        else
        {
            [self _saveData];
            _textEdit.hidden = NO;
            _barItemSend.enabled = YES;
            [_textEdit becomeFirstResponder];
            [HBUtiliOS showMessageBox:NSLocalizedString(@"授权成功!", @"")];
        }
        
        _webView.delegate = nil;
        _webView.hidden = YES;
        
		return NO;
	}
	else
	{
        start = [url.absoluteString rangeOfString:@"code="];
        if (start.location != NSNotFound)
            [HBUtiliOS showMessageBox:NSLocalizedString(@"授权失败!", @"")];
	}

    return YES;
}

/*
 * 当网页视图结束加载一个请求后得到通知
 */
- (void) webViewDidFinishLoad:(UIWebView *)webView
{
//    NSString *url = _webView.request.URL.absoluteString;
//    NSLog(@"[QQBeiBo] web view finish load URL %@", url);
}

/*
 * 页面加载失败时得到通知，可根据不同的错误类型反馈给用户不同的信息
 */
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
//    NSLog(@"[QQWeiBo] no network:errcode is %d, domain is %@", error.code, error.domain);
    [HBUtiliOS showMessageBox:NSLocalizedString(@"授权失败!", @"")];
}

#pragma mark - TextView Delegate

- (void)textViewDidChange:(UITextView *)textView
{
    _leftNmu.text = [NSString stringWithFormat:@"%d ", 140 - _textEdit.text.length];
    if (_textEdit.text.length > 140) 
    {
        _leftNmu.textColor = [UIColor redColor];
    }
    else
    {
        _leftNmu.textColor = [UIColor blackColor];
    }
}

@end
