#ifndef _HBGameCenter_H_
#define _HBGameCenter_H_

#import <GameKit/GameKit.h>

@interface HBGameCenter : NSObject <GKLeaderboardViewControllerDelegate>

@property (nonatomic, readonly) BOOL isSupport;     // 设备是否支持
@property (nonatomic, readonly) bool isLogin;       // 是否登录成功

+ (HBGameCenter*) shared;

- (void)authenticateLocalPlayer;
- (void)showLeaderboard:(NSString*)name;
- (void)reportScoreTo:(NSString*)name withScore:(int)score;

@end

#endif