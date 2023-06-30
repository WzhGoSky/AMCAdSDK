//
//  AdMoreDrawAdController.m
//  AdMoreSDKDemo
//
//  Created by Hayder on 2023/5/18.
//

#import "AdMoreDrawAdController.h"

@interface AdMoreDrawAdController ()<AdMoreDrawAdDelegate>

@property (nonatomic, strong) AdMoreDrawAd *drawAd;

@property (nonatomic, strong) NSMutableArray *showViewsArray;

@property (nonatomic, strong) UIScrollView *contentView;

@end

@implementation AdMoreDrawAdController

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
    self.drawAd = [[AdMoreDrawAd alloc] initWithSlotID:kDrawID rootController:kRootViewController adSize:CGSizeMake(HH_SCREEN_WIDTH-20, HH_SCREEN_HEIGHT/2)];
    self.drawAd.delegate = self;
    [self.drawAd loadAdDataWithCount:3];
}

- (void)showEvent
{
    [self.contentView removeAllSubviews];
    
    CGFloat contentHeight = 0;
    
    for (int i=0; i<self.showViewsArray.count; i++) {
        UIView *drawAdView = self.showViewsArray[i];
        CGFloat x = (self.contentView.width - drawAdView.width)/2;
        drawAdView.left = x;
        drawAdView.top = contentHeight;
        [self.contentView addSubview:drawAdView];
        contentHeight += drawAdView.height;
    }
    
    self.contentView.contentSize = CGSizeMake(0, contentHeight);
}

- (void)closeEvent
{
    for (UIView *view in self.showViewsArray) {
        [view removeFromSuperview];
    }
    
    [self.showViewsArray removeAllObjects];
}

/**draw广告加载成功*/
- (void)drawAdViewsLoadSuccess:(NSArray *)drawAdViews
{
    NSLog(@"广告加载成功%@",drawAdViews);
}
/**draw广告加载失败**/
- (void)drawAdViewsFailedToLoadWithError:(NSError *)error
{
    [self.view hideActivityHUD];
    NSLog(@"广告加载失败%@",error.description);
}

/**广告渲染成功*/
- (void)drawAdViewRenderSuccess:(UIView *)drawAdView
{
    [self.view hideActivityHUD];
    [self.view toastMessage:@"加载成功"];
    NSLog(@"广告渲染成功%@",drawAdView);
    [self.showViewsArray addObject:drawAdView];
}
/**广告渲染失败*/
- (void)drawAdViewFailedToRender:(UIView *)drawAdView error:(NSError *)error
{
    [self.view hideActivityHUD];
    NSLog(@"广告渲染失败%@",error.description);
}

/**广告点击事件**/
- (void)drawAdViewDidClick:(UIView *)drawAdView
{
    NSLog(@"广告点击");
}
/**广告关闭事件*/
- (void)drawAdViewDidClose:(UIView *)drawAdView
{
    NSLog(@"广告关闭");
}

/**视频完成播放**/
- (void)drawAdViewPlayerDidPlayFinish:(UIView *)drawAdView
{
    NSLog(@"视频完成播放");
}
/**视频播放，可能回调多次，暂停->继续播放也会回调**/
- (void)drawAdViewVideoDidPlaying:(UIView *)drawAdView
{
    NSLog(@"广告正在播放");
}
/**视频暂停播放**/
- (void)drawAdViewVideoDidPause:(UIView *)drawAdView
{
    NSLog(@"视频暂停播放");
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
