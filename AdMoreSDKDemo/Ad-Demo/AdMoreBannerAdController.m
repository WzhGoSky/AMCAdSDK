//
//  AdMoreBannerController.m
//  AdMoreSDKDemo
//
//  Created by Hayder on 2023/5/10.
//

#import "AdMoreBannerAdController.h"

@interface AdMoreBannerAdController ()<AdMoreBannerAdDelegate>

@property (nonatomic, strong) AdMoreBannerAd *bannerAd;

@property (nonatomic, strong) UIView *bannerView;

@end

@implementation AdMoreBannerAdController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)loadEvent
{
    [super loadEvent];
    
    [self.view showActivityHUD];
    
    //每次都需要创建一个新的 ad 对象
    self.bannerAd = [[AdMoreBannerAd alloc] initWithSlotID:kBannnerID rootViewController:kRootViewController adSize:CGSizeMake(HH_SCREEN_WIDTH, HH_SCREEN_WIDTH * 0.15625)];
    self.bannerAd.delegate = self;
    [self.bannerAd loadAdData];
}

- (void)showEvent
{
    [self.view addSubview:self.bannerView];
}

/**
 加载成功回调
 */
- (void)bannerAdDidLoad:(AdMoreBannerAd *)bannerAd bannerView:(UIView *)bannerView
{
    [self.view hideActivityHUD];
    [self.view toastMessage:@"加载成功"];
    //设置y
    CGRect rect = bannerView.frame;
    rect.origin.y = 200;
    [bannerView setFrame:rect];
    self.bannerView = bannerView;
}

/**
 加载失败回调
 */
- (void)bannerAd:(AdMoreBannerAd *)bannerAd didLoadFailWithError:(NSError *)error
{
    [self.view hideActivityHUD];
    NSLog(@"banner:加载失败回调:%@",error.description);
}

/**
 展示成功回调
 */
- (void)bannerAdDidBecomeVisible:(AdMoreBannerAd *)bannerAd bannerView:(UIView *)bannerView
{
    NSLog(@"banner:展示成功");
}

/**
 广告点击回调
 */
- (void)bannerAdDidClick:(AdMoreBannerAd *)ABUBannerAd bannerView:(UIView *)bannerView
{
    NSLog(@"banner:广告点击");
}

/**
 广告关闭回调
 */
- (void)bannerAdDidClosed:(AdMoreBannerAd *)ABUBannerAd bannerView:(UIView *)bannerView dislikeWithReason:(NSArray<NSDictionary *> *)filterwords
{
    NSLog(@"banner:广告关闭");
    [self.bannerView removeFromSuperview];
}

- (void)dealloc
{
    NSLog(@"销毁");
}
@end
