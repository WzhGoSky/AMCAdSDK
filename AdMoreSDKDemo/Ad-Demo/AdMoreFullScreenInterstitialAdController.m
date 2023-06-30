//
//  AdMoreFullScreenInterstitialAdController.m
//  AdMoreSDKDemo
//
//  Created by Hayder on 2023/5/13.
//  全屏视频+插屏广告

#import "AdMoreFullScreenInterstitialAdController.h"

@interface AdMoreFullScreenInterstitialAdController ()<AdMoreFullScreenInterstitialAdDelegate>

@property (nonatomic, strong) AdMoreFullScreenInterstitialAd *fullScreenInterstitialAd;

@end

@implementation AdMoreFullScreenInterstitialAdController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)loadEvent
{
    [super loadEvent];
    
    [self.view showActivityHUD];
    
    //每次都需要创建一个新的 ad 对象
    self.fullScreenInterstitialAd = [[AdMoreFullScreenInterstitialAd alloc] initWithSlotID:kFullScreenInterstitialID];
    self.fullScreenInterstitialAd.delegate = self;
    [self.fullScreenInterstitialAd loadAdData];
}

- (void)showEvent
{
    [self.fullScreenInterstitialAd showFromRootViewController:kRootViewController];
}

/**插全屏广告加载成功回调*/
- (void)fullScreenInterstitiaAdDidLoad:(AdMoreFullScreenInterstitialAd *)rewardedVideoAd slotId:(NSString *)slotId
{
    [self.view hideActivityHUD];
    [self.view toastMessage:@"加载成功"];
    NSLog(@"fullScreenInterstitiaAd:加载成功");
}

/**插全屏广告加载失败回调*/
- (void)fullScreenInterstitiaAd:(AdMoreFullScreenInterstitialAd *)rewardedVideoAd didFailWithError:(NSError *_Nullable)error
{
    [self.view hideActivityHUD];
    NSLog(@"fullScreenInterstitiaAd:加载失败:%@",error.description);
}

/**插全屏广告开始播放回调*/
- (void)fullScreenInterstitiaAdPlayStart:(AdMoreFullScreenInterstitialAd *)rewardedVideoAd
{
    NSLog(@"fullScreenInterstitiaAd:开始播放回调");
}
/**插全屏广告播放结束回调*/
- (void)fullScreenInterstitiaAdPlayEnd:(AdMoreFullScreenInterstitialAd *)rewardedVideoAd
{
    NSLog(@"fullScreenInterstitiaAd:播放结束回调");
}
/**插全屏广告播放出错*/
- (void)fullScreenInterstitiaAdPlayError:(AdMoreFullScreenInterstitialAd *)rewardedVideoAd error:(NSError *)error
{
    NSLog(@"fullScreenInterstitiaAd:广告播放出错");
}

/**插全屏广告点击回调*/
- (void)fullScreenInterstitiaAdDidClick:(AdMoreFullScreenInterstitialAd *)rewardedVideoAd
{
    NSLog(@"fullScreenInterstitiaAd:点击回调");
}
/**插全屏广告关闭回调*/
- (void)fullScreenInterstitiaAdDidClose:(AdMoreFullScreenInterstitialAd *)rewardedVideoAd
{
    NSLog(@"fullScreenInterstitiaAd:关闭回调");
}

/**插全屏广告奖励验证回调*/
- (void)fullScreenInterstitiaAdServerRewardDidSucceed:(AdMoreFullScreenInterstitialAd *)rewardedVideoAd verify:(BOOL)verify
{
    NSLog(@"fullScreenInterstitiaAd:广告奖励验证回调");
}

@end
