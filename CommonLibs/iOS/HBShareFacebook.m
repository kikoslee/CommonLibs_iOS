//
//  HBShareFacebook.m
//  HBLib
//
//  Created by Limin on 12-9-19.
//  Copyright (c) 2012年 HappyBluefin. All rights reserved.
//

#import "HBShareFacebook.h"
#import <FacebookSDK/FacebookSDK.h>
#import "MBProgressHUD.h"
#import "AppController.h"
#import "HBUtiliOS.h"

HBShareFacebook* _sharedHBShareFacebook = nil;

@interface HBShareFacebook()<UIWebViewDelegate,UITextViewDelegate>
{
    UIView* _baseView;
    UITextView* _textEdit;
    UIBarButtonItem* _barItemSend;
}

@property (nonatomic, retain) NSString* message;

@end

@implementation HBShareFacebook

@synthesize message = _message;

+ (HBShareFacebook*)shared
{
    if (!_sharedHBShareFacebook)
        _sharedHBShareFacebook = [[HBShareFacebook alloc] init];
    return _sharedHBShareFacebook;
}

- (void)dealloc
{
    [_baseView release];
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
    
    if (![FBSession activeSession].accessToken)
    {
        if (![FBSession activeSession].isOpen)
            [FBSession setActiveSession:[[FBSession alloc] init]]; 
        
        /* more permissions :http://developers.facebook.com/docs/authentication/permissions/  */    
        NSArray *permissions = [NSArray arrayWithObjects:@"publish_actions", 
                                @"read_stream", @"publish_stream", 
                                nil];
        
        [FBSession openActiveSessionWithPublishPermissions:permissions defaultAudience:FBSessionDefaultAudienceEveryone allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            [self _createView];
        }];
    }
    else {
        [self _createView];
    }
}

- (void)sendMessage:(const char*)text
{
    [self sendMessage:text callBack:NO];
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
    space.title = @"Facebook";
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(_doCancel)];
    
    _barItemSend = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Share", @"") style:UIBarButtonItemStyleDone target:self action:@selector(_doSend)];
    
    [bar setItems:[NSArray arrayWithObjects:edge, cancel, space, _barItemSend, edge, nil]];
    
    [_baseView addSubview:bar];
    [bar release];
    
    rc = bounds;
    rc.size.height -= 44;
    rc.origin.y = 44;
    
    _textEdit = [[UITextView alloc] initWithFrame:rc];
    _textEdit.font = [UIFont systemFontOfSize:16];
    _textEdit.text = _message;
    _textEdit.delegate = self;
        
    [_baseView addSubview:_textEdit];
    [_textEdit release];
    
    AppController* app = (AppController*)[UIApplication sharedApplication].delegate;
    UIViewController* vc = (UIViewController*)app.viewController;
    [vc.view addSubview:_baseView];    
    
    [_textEdit becomeFirstResponder];

    rc = _baseView.frame;
    rc.origin.y = rc.size.height;
    _baseView.frame = rc;

    [UIView beginAnimations:@"In" context:NULL];
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
    if ([animationID isEqualToString:@"Out"])
    {
        if(_baseView)
        {
            [_baseView removeFromSuperview];
            [_baseView release];
            _baseView = nil;
            _textEdit = nil;
        }
    }
}

- (void)_doCancel
{
    CGRect rc = _baseView.frame;
    [UIView beginAnimations:@"Out" context:NULL];
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
        [HBUtiliOS showMessageBox:@"Please input content!"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:_baseView animated:YES];
    
    if ([FBSession activeSession].state==1)
    {
        [[FBSession activeSession] openWithCompletionHandler:^(FBSession *session, 
                                                               FBSessionState status, 
                                                               NSError *error) {
            
        }];
    }
    
    [FBRequestConnection startForPostStatusUpdate:_message completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        [MBProgressHUD hideHUDForView:_baseView animated:YES];
        if (error == nil)
        {
            [HBUtiliOS showMessageBox:@"Send success"];
            [_textEdit resignFirstResponder];
            [self _doCancel];
        }
        else
        {
            [HBUtiliOS showMessageBox:error.localizedDescription];
        }
    }];
}



@end
