//
//  AdMoreBaseController.m
//  AdMoreSDKDemo
//
//  Created by Hayder on 2023/5/9.
//

#import "AdMoreBaseController.h"

@interface AdMoreBaseController ()

@property (nonatomic, assign) CGFloat btnW;
@property (nonatomic, assign) CGFloat btnH;
@property (nonatomic, assign) CGFloat margin;
@property (nonatomic, assign) CGFloat y;

@end

@implementation AdMoreBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.y = 100;
    self.btnW = 100;
    self.btnH = 50;
    self.margin = (HH_SCREEN_WIDTH - 300)/4;
    
    [self.view addSubview:self.loadDataBtn];
    [self.view addSubview:self.showDataBtn];
    [self.view addSubview:self.closeBtn];
    
}

- (void)loadEvent
{
    self.startTime = [[NSDate date] timeIntervalSince1970];
}

- (void)showEvent
{
    
}

- (void)closeEvent
{
    NSLog(@"此广告自带关闭按钮，请点击广告上的关闭按钮");
}

- (void)showLoadTime
{
    self.endTime = [[NSDate date] timeIntervalSince1970];
    NSLog(@"Ad:加载成功");
    NSLog(@"Ad:加载时间: %f",self.endTime - self.startTime);
}

- (UIButton *)loadDataBtn
{
    if(!_loadDataBtn)
    {
        _loadDataBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loadDataBtn setBackgroundColor:UIColor.redColor];
        _loadDataBtn.frame = CGRectMake(self.margin, self.y, self.btnW, self.btnH);
        [_loadDataBtn setTitle:@"加载" forState:UIControlStateNormal];
        [_loadDataBtn addTarget:self action:@selector(loadEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _loadDataBtn;
}

- (UIButton *)showDataBtn
{
    if(!_showDataBtn)
    {
        _showDataBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showDataBtn setBackgroundColor:UIColor.redColor];
        _showDataBtn.frame = CGRectMake(2*self.margin + self.btnW, self.y, self.btnW, self.btnH);
        [_showDataBtn setTitle:@"展示" forState:UIControlStateNormal];
        [_showDataBtn addTarget:self action:@selector(showEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _showDataBtn;
}

- (UIButton *)closeBtn
{
    if(!_closeBtn)
    {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setBackgroundColor:UIColor.redColor];
        _closeBtn.frame = CGRectMake(3*self.margin + 2*self.btnW, self.y, self.btnW, self.btnH);
        [_closeBtn setTitle:@"关闭广告" forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _closeBtn;
}

- (void)dealloc
{
    NSLog(@"dealloc-----");
}

@end
