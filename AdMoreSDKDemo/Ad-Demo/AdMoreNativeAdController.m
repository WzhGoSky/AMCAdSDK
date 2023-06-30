//
//  AdMoreNativeAdController.m
//  AdMoreSDKDemo
//
//  Created by Hayder on 2023/5/16.
//

#import "AdMoreNativeAdController.h"

@interface AdMoreNativeAdController ()<AdMoreNativeAdDelegate>

@property (nonatomic, strong) AdMoreNativeAd *nativeAd;

@property (nonatomic, strong) NSMutableArray *showViewsArray;

@property (nonatomic, strong) UIScrollView *contentView;

@end

@implementation AdMoreNativeAdController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.showViewsArray = [NSMutableArray array];
    [self.view addSubview:self.contentView];
}

- (void)loadEvent
{
    [super loadEvent];
    
    [self.view showActivityHUD];
    //每次都需要创建一个新的 ad 对象
    self.nativeAd = [[AdMoreNativeAd alloc] initWithSlotID:kNativeID rootController:kRootViewController adSize:CGSizeMake(HH_SCREEN_WIDTH-20, 100)];
    self.nativeAd.delegate = self;
    [self.nativeAd loadAdDataWithCount:3];
}

- (void)showEvent
{
    [self.contentView removeAllSubviews];
    
    CGFloat contentHeight = 0;
    
    for (int i=0; i<self.showViewsArray.count; i++) {
        UIView *nativeAdView = self.showViewsArray[i];
        nativeAdView.top = contentHeight;
        CGFloat x = (self.contentView.width - nativeAdView.width)/2;
        nativeAdView.left = x;
        [self.contentView addSubview:nativeAdView];
        contentHeight += nativeAdView.height;
    }
    
    self.contentView.contentSize = CGSizeMake(0, contentHeight);
}

#pragma mark ---------------------AdMoreNativeAdDelegate----------------------------
/**信息流广告加载成功*/
- (void)nativeAdViewsLoadSuccess:(NSArray *)nativeAdViews
{
    NSLog(@"nativeAd:信息流广告加载成功%@",nativeAdViews);
}
/**信息流广告加载失败**/
- (void)nativeAdViewsFailedToLoadWithError:(NSError *)error
{
    [self.view hideActivityHUD];
    NSLog(@"nativeAd:信息流广告加载失败%@",error.description);
}

/**信息流渲染成功---多次回调*/
- (void)nativeAdViewRenderSuccess:(id)nativeAdView
{
    [self.view hideActivityHUD];
    NSLog(@"nativeAd:信息流渲染成功%@",nativeAdView);
    [self.showViewsArray addObject:nativeAdView];
}
/**信息流渲染失败*/
- (void)nativeAdViewFailedToRender:(id)nativeAdView error:(nonnull NSError *)error
{
    NSLog(@"nativeAd:信息流渲染失败%@",error.description);
}

/**信息流点击事件**/
- (void)nativeAdViewDidClick:(id)nativeAdView
{
    NSLog(@"nativeAd:信息流点击");
}
/**信息流关闭事件*/
- (void)nativeAdViewDidClose:(id)nativeAdView
{
    NSLog(@"nativeAd:信息流关闭");
    [nativeAdView removeFromSuperview];
}

/**视频完成播放**/
- (void)nativeAdViewPlayerDidPlayFinish:(id)nativeAdView
{
    NSLog(@"nativeAd:视频完成播放");
}
/**视频播放，可能回调多次，暂停->继续播放也会回调**/
- (void)nativeAdViewVideoDidPlaying:(id)nativeAdView
{
    NSLog(@"nativeAd:视频播放");
}
/**视频暂停播放**/
- (void)nativeAdViewVideoDidPause:(id)nativeAdView
{
    NSLog(@"nativeAd:视频暂停");
}

#pragma mark ---------------------private----------------------------
- (UIScrollView *)contentView
{
    if(!_contentView)
    {
        _contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.loadDataBtn.bottom + 10, HH_SCREEN_WIDTH, HH_SCREEN_HEIGHT - self.loadDataBtn.bottom - 10)];
    }
    
    return _contentView;
}

@end
