#import "HBGameCenter.h"
#import "AppController.h"
#import "GKAchievementHandler.h"

static HBGameCenter* _sharedHBGameCenter = nil;

@interface HBGameCenter()

- (void)_checkSupport;

@end

@implementation HBGameCenter

@synthesize isSupport = _isSupport;
@synthesize isLogin = _isLogin;

+ (HBGameCenter*)shared
{
	if(!_sharedHBGameCenter)
		_sharedHBGameCenter = [[HBGameCenter alloc] init];
	return _sharedHBGameCenter;
}

-(id)init
{
	if((self = [super init]))
    {
		_isLogin = false;
		[self _checkSupport];
        [self authenticateLocalPlayer];
	}
	return self;
}

// 对Game Center支持判断
- (void)_checkSupport
{
	Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
	NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
	bool osVersionSupported = ([currSysVer compare:@"4.1" options:NSNumericSearch] != NSOrderedAscending);

	_isSupport = gcClass && osVersionSupported;
}

// 用户登录
-(void)authenticateLocalPlayer
{
	if(_isSupport)
	{
		GKLocalPlayer* localPlayer = [GKLocalPlayer localPlayer];
		[localPlayer authenticateWithCompletionHandler:^(NSError *error) {
            if (error == nil)
            {
                NSLog(@"[HBGameCenter]: Authenticate Success");
                _isLogin = true;
            }
            else
            {
                NSLog(@"[HBGameCenter]: Authenticate Error [%@]", error.description);
            }
        }];
	}
}

// 显示排行榜
-(void)showLeaderboard:(NSString*)name
{
	if(_isLogin)
	{
		GKLeaderboardViewController* lbCtrl = [[GKLeaderboardViewController alloc] init];
		lbCtrl.category = name;
		lbCtrl.leaderboardDelegate = self;
        AppController* app = (AppController*)[UIApplication sharedApplication].delegate;
		[app.viewController presentModalViewController:lbCtrl animated:YES];
		[lbCtrl release];
	}
    else
    {
        [self authenticateLocalPlayer];
    }
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController*)viewController
{
    AppController* app = (AppController*)[UIApplication sharedApplication].delegate;
	[app.viewController dismissModalViewControllerAnimated:YES];
}

// 上传一个分数
- (void)reportScoreTo:(NSString *)name withScore:(int)score
{
	if(_isLogin)
    {
		GKScore* sr = [[GKScore alloc] initWithCategory:name];
		sr.value = score;
		[sr reportScoreWithCompletionHandler:^(NSError *error) {
            if (error != nil)
                NSLog(@"[HBGameCenter]: Report score error [%@]", error.description);
            else
                NSLog(@"[HBGameCenter]: Report score Success");
        }];
	}
}

@end
