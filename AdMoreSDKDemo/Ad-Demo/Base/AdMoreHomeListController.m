//
//  ViewController.m
//  AdMoreSDKDemo
//
//  Created by Hayder on 2023/5/8.
//

#import "AdMoreHomeListController.h"

@interface AdMoreHomeListController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSArray *controllers;

@end

@implementation AdMoreHomeListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"AdMore广告";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"AdMoreCellId"];
    
    self.dataSource = @[
                        @"横幅广告(AdMoreBannerAd)",
                        @"draw广告(AdMoreDrawAd)",
                        @"插全屏广告(AdMoreFullScreenInterstitialAd)",
                        @"信息流广告(AdMoreNativeAd)",
                        @"激励视频广告(AdMoreRewardVideoAd)",
                        @"开屏广告(AdMoreSplashAd)"
                        ];
    self.controllers = @[
                        @"AdMoreBannerAdController",
                        @"AdMoreDrawAdController",
                        @"AdMoreFullScreenInterstitialAdController",
                        @"AdMoreNativeAdController",
                        @"AdMoreRewardVideoAdController",
                        @"AdMoreSplashAdController"
                        ];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AdMoreCellId" forIndexPath:indexPath];
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class cls = NSClassFromString(self.controllers[indexPath.row]);
    UIViewController *vc = [[cls alloc] init];
    vc.title = self.dataSource[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
