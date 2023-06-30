//
//  AppDelegate.m
//  AdMoreSDKDemo
//
//  Created by Hayder on 2023/5/8.
//

#import "AppDelegate.h"
#import "AdMoreHomeListController.h"
#import "AdMoreGlobalDefine.h"

#pragma mark - 申请IDFA权限
#import <AdSupport/AdSupport.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[AdMoreHomeListController alloc] init]];
    
    [AdMoreSDKManager initAdMoreSDKWithAppID:kAppID completion:^(BOOL isSuccess, NSError * _Nonnull error) {
        //等初始化成功后再使用广告，如果需要使用开屏广告，可在初始化成功后再此使用
        NSLog(@"----");
    }];
#if DEBUG
    [AdMoreSDKManager openDebugLog:YES];
#endif

    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if (@available(iOS 14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
                NSString *idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
                    NSLog(@"%@",idfa);
            } else {
                NSLog(@"请在设置-隐私-跟踪中允许App请求跟踪");
            }
        }];
    } else {
        if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
            NSString *idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
            NSLog(@"%@",idfa);
        } else {
            NSLog(@"请在设置-隐私-广告中打开广告跟踪功能");
        }
    }
}



@end
