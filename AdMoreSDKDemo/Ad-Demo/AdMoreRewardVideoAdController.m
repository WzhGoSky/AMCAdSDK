//
//  AdMoreRewardVideoController.m
//  AdMoreSDKDemo
//
//  Created by Hayder on 2023/5/9.
//

#import "AdMoreRewardVideoAdController.h"

@interface AdMoreRewardVideoAdController ()<AdMoreRewardVideoAdDelegate>

@property (nonatomic, strong) AdMoreRewardVideoAd *rewardedVideoAd;

@end

@implementation AdMoreRewardVideoAdController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)loadEvent
{
    [super loadEvent];
    
    [self.view showActivityHUD];
    //每次都需要创建一个新的 ad 对象
    self.rewardedVideoAd = [[AdMoreRewardVideoAd alloc] initWithSlotID:kRewardVideoID];
    self.rewardedVideoAd.delegate = self;
    [self.rewardedVideoAd loadAdData];
}

- (void)showEvent
{
    [self.rewardedVideoAd showFromRootViewController:kRootViewController];
}

/**
 激励视频加载成功回调
 */
- (void)rewardedVideoAdDidLoad:(AdMoreRewardVideoAd *)rewardedVideoAd slotId:(NSString *)slotId
{
    [self.view hideActivityHUD];
    [self.view toastMessage:@"加载成功"];
    NSLog(@"rewardVideo:激励视频加载成功回调");
    
    [self showLoadTime];
}
/**
 激励视频加载失败回调
 */
- (void)rewardedVideoAd:(AdMoreRewardVideoAd *)rewardedVideoAd didFailWithError:(NSError *_Nullable)error
{
    [self.view hideActivityHUD];
    NSLog(@"rewardVideo:激励视频加载失败回调 %@",error.description);
}
/**
 激励视频点击回调
 */
- (void)rewardedVideoAdDidClick:(AdMoreRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"rewardVideo:激励视频点击回调");
}

/**
 激励视频关闭回调
 */
- (void)rewardedVideoAdDidClose:(AdMoreRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"rewardVideo:激励视频关闭回调");
}

/**
 激励视频播放出错
 */
- (void)rewardedVideoAdPlayError:(AdMoreRewardVideoAd *)rewardedVideoAd error:(NSError *)error
{
    NSLog(@"rewardVideo:激励视频播放出错 %@",error.description);
}

/**激励视频播放结束回调*/
- (void)rewardedVideoAdPlayEnd:(AdMoreRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"rewardVideo:激励视频播放结束回调");
}

/**激励视频开始播放回调*/
- (void)rewardedVideoAdPlayStart:(AdMoreRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"rewardVideo:激励视频开始播放回调");
}
/**
 奖励验证回调
 */
- (void)rewardedVideoAdServerRewardDidSucceed:(AdMoreRewardVideoAd *)rewardedVideoAd verify:(BOOL)verify
{
    NSLog(@"rewardVideo:奖励验证回调");
}

@end
