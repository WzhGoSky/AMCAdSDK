# 1.AdMore SDK集成

## 1.1 cocoapods引入

```
pod 'AdMoreSDK'
```



## 1.2 SDK手动导入

将AdMoreSDK.framework文件夹拖入项目后，需做以下设置

### 1.2.1 导入SDK依赖的系统库

- Accelerate.framework
- AdSupport.framework
- AddressBook.framework
- AudioToolbox.framework
- AVFoundation.framework
- AVKit.framework
- CFNetwork.framework
- CoreData.framework
- CoreFoundation.framework
- CoreGraphics.framework
- CoreImage.framework
- CoreLocation.framework
- CoreMedia.framework
- CoreMotion.framework
- CoreTelephony.framework
- CoreText.framework
- DeviceCheck.framework
- Foundation.framework
- ImageIO.framework
- JavaScriptCore.framework
- MapKit.framework
- MediaPlayer.framework
- MobileCoreServices.framework
- MessageUI.framework
- QuartzCore.framework
- QuickLook.framework
- Security.framework
- StoreKit.framework
- SystemConfiguration.framework
- SafariServices.framework
- UIKit.framework
- WebKit.framework
- libbz2.tbd
- libc++.tbd
- libiconv.tbd
- libresolv.9.tbd
- libsqlite3.tbd
- libxml2.tbd
- libz.tbd
- libc++abi.tbd

###1.2 KSAdSDK设置(重要，不设置会闪退)

TARGERS -> General -> Frameworks,Libraries,and Embedded Content -> KSAdSDK.framework 的 Embed 一栏改为 **Embed & Sign**



## 1.3 iOS14支持说明

#### 1.3.1 获取广告表示IDFA

为了申请IDFA权限，需要info.plist里添加NSUserTrackingUsageDescription键，说明为什么要获取IDFA

```
<key>NSUserTrackingUsageDescription</key>
<string>请允许获取并使用您的活动跟踪，以便于向您进行个性化推送服务，从而减少无关服务对您造成的干扰</string>
```

在应用启动后，弹出IDFA权限申请，这个弹框只会出现一次，后续如果要变更IDFA权限，需要在手机的系统设置【隐私】-【跟踪】里调整。

```objective-c
if (@available(iOS 14, *)) {
    [ATTrackingManager  requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
}];
```

注意： 在iOS 15.0中，如果是在启动方法中调用授权，是不会弹出授权提示框的。

```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions
```

**解决方法**

方法一、app 不支持 Application Scene 也可以在 AppDelegate 中的 applicationDidBecomeActive 回调中进行处理

```objective-c
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/AdSupport.h>

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if (@available(iOS 14.5, *))
    {
        if([ATTrackingManager trackingAuthorizationStatus] == ATTrackingManagerAuthorizationStatusNotDetermined)
        {
            [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            }];
        }
    }
}
```

方法二、可以在这两个方法中注册 UIApplicationDidBecomeActiveNotification 通知

```objective-c
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
```

然后在接受到通知后进行授权操作

```objective-c
- (void)didBecomeActive
{
    if (@available(iOS 14, *))
    {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
        }];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}
```

#### 1.3.2 配置SKAdNetwork跟踪转化(重要)

Apple官方的 [**SKAdNetwork**](https://developer.apple.com/documentation/storekit/skadnetwork)框架的三方渠道，会在获取不到IDFA的时候，正常获取转化。为了实现这个功能，需要在info.plist添加对应的SKAdNetworkItems。

```
<key>SKAdNetworkItems</key>
<array>
    <dict>
        <key>SKAdNetworkIdentifier</key>
        <string>58922nb4gd.skadnetwork</string>
    </dict>
    <dict>
        <key>SKAdNetworkIdentifier</key>
        <string>f7s53z58qe.skadnetwork</string>
    </dict>
     <dict>
        <key>SKAdNetworkIdentifier</key>
        <string>27a282f54n.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>238da6jt44.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>x2jnk7ly8j.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>22mmun2rn5.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key> 
      <string>r3y5dwb26t.skadnetwork</string>
    </dict>
</array>
```

## 1.4 隐私权限设置(建议配置，提高收益)

SDK 不强制获取任何权限和信息，但是建议在info.plist中配置以下权限，可以有效提升ECPM：

```
   Privacy - Location When In Use Usage Description
   Privacy - Location Always and When In Use Usage Description
```



## 1.5 其他设置

####1.5.1 Other Linker Flags 设置

在Target->Build Settings -> Other Linker Flags中添加-ObjC, 字母o和c大写

- -ObjC 

#### 1.5.2 Enable Bitcode 为 NO

#### 1.5.3 Info.plist -> App Transport Security Settings - >Allow Arbitrary Loads 设置为 YES



# 2.广告

## 2.1 初始化类 (AdMoreManager)

建议SDK初始化时机越早越好，确保SDK初始化完成后再进行广告的请求处理。

```objective-c
/**SDK初始化*/
+ (void)initAdMoreSDKWithAppID:(NSString *)appID;

/**打开debug日志*/
+ (void)openDebugLog:(BOOL)isOpen;

/**获取SDK版本号*/
+ (NSString *)version;
```



## 2.2 Banner广告（AdMoreBannerAd）

#### 介绍

横幅广告，又名Banner广告，固定于app顶部、中部、底部、或其他位置，横向贯穿整个app页面；当用户与app互动时，Banner广告会停留在屏幕上，并可在一段时间后自动刷新。

#### 广告接口说明

```objective-c
@interface AdMoreBannerAd : NSObject

@property (nonatomic, weak) id<AdMoreBannerAdDelegate> delegate;

@property (nonatomic, strong,readonly) NSString *slotID;
@property (nonatomic, strong,readonly) UIViewController *rootViewController;
@property (nonatomic, assign,readonly) CGSize adSize;

/**
 初始化方法
 slotID:广告位ID
 rootViewController:根控制器，用于广告的跳转
 adSize:广告的大小 
 */
- (instancetype)initWithSlotID:(NSString *)slotID rootViewController:(UIViewController *)rootViewController adSize:(CGSize)adSize;

/**加载广告数据*/
- (void)loadAdData;

@end
```



####广告代理回调
```c
@class AdMoreBannerAd;
@protocol AdMoreBannerAdDelegate <NSObject>

@optional
/**加载成功回调*/
- (void)bannerAdDidLoad:(AdMoreBannerAd *)bannerAd bannerView:(UIView *)bannerView;

/**加载失败回调*/
- (void)bannerAd:(AdMoreBannerAd *)bannerAd didLoadFailWithError:(NSError *)error;

/**展示成功回调*/
- (void)bannerAdDidBecomeVisible:(AdMoreBannerAd *)bannerAd bannerView:(UIView *)bannerView;

/**广告点击回调*/
- (void)bannerAdDidClick:(AdMoreBannerAd *)ABUBannerAd bannerView:(UIView *)bannerView;

/**广告关闭回调*/
- (void)bannerAdDidClosed:(AdMoreBannerAd *)ABUBannerAd bannerView:(UIView *)bannerView dislikeWithReason:(NSArray<NSDictionary *> *)filterwords;

@end
```
####使用示例

见AdMoreSDKDemo示例工程中的 **AdMoreBannerAdController**



## 2.3 沉浸式视频信息流广告 (AdMoreDrawAd)

#### 介绍

与抖音竖版视频流一样的全屏视频信息流广告。

#### 广告接口说明

```objective-c
@interface AdMoreDrawAd : NSObject

@property (nonatomic, strong,readonly) NSString *slotID;
@property (nonatomic, strong,readonly) UIViewController *rootViewController;
@property (nonatomic, assign,readonly) CGSize adSize;

@property (nonatomic, weak) id<AdMoreDrawAdDelegate> delegate;

/**
 全屏
 slotID: 广告位ID
 rootViewController: 广告链接跳转的根控制器
 */
- (instancetype)initWithSlotID:(NSString *)slotID rootController:(UIViewController *)rootViewController;

/**
 slotID: 广告位ID
 rootViewController: 广告链接跳转的根控制器
 adSize: 广告大小
 */
- (instancetype)initWithSlotID:(NSString *)slotID rootController:(UIViewController *)rootViewController adSize:(CGSize)adSize;

/**
 加载广告的数量，最大为3
 */
- (void)loadAdDataWithCount:(NSInteger)count;

@end
```



#### 广告代理回调

```c
@class AdMoreDrawAd;
@protocol AdMoreDrawAdDelegate <NSObject>

@optional
/**draw广告加载成功*/
- (void)drawAdViewsLoadSuccess:(NSArray *)drawAdViews;
/**draw广告加载失败**/
- (void)drawAdViewsFailedToLoadWithError:(NSError *)error;

/**广告渲染成功*/
- (void)drawAdViewRenderSuccess:(UIView *)drawAdView;
/**广告渲染失败*/
- (void)drawAdViewFailedToRender:(UIView *)drawAdView error:(NSError *)error;

/**广告点击事件**/
- (void)drawAdViewDidClick:(UIView *)drawAdView;
/**广告关闭事件*/
- (void)drawAdViewDidClose:(UIView *)drawAdView;

/**视频完成播放**/
- (void)drawAdViewPlayerDidPlayFinish:(UIView *)drawAdView;
/**视频播放，可能回调多次，暂停->继续播放也会回调**/
- (void)drawAdViewVideoDidPlaying:(UIView *)drawAdView;
/**视频暂停播放**/
- (void)drawAdViewVideoDidPause:(UIView *)drawAdView;

@end
```

#### 使用示例

AdMoreSDKDemo示例工程中的 **AdMoreDrawAdController**



## 2.4 插全屏广告(AdMoreFullScreenInterstitialAd)

#### 介绍

插全屏广告是将原有的插屏广告(AdMoreInterstitialAd)和全屏视频广告(AdMoreFullscreenVideoAd)结合，在同一个广告类型下支持混出的广告类型

#### 广告接口说明

```objective-c
@interface AdMoreFullScreenInterstitialAd : NSObject

@property (nonatomic, strong, readonly) NSString *slotID;

@property (nonatomic, weak) id<AdMoreFullScreenInterstitialAdDelegate> delegate;

/**
 slotID: 广告位ID
 */
- (instancetype)initWithSlotID:(NSString *)slotID;

/**加载广告*/
- (void)loadAdData;

- (void)showFromRootViewController:(UIViewController *)showController;

@end
```



#### 广告代理回调

```objective-c
@class AdMoreFullScreenInterstitialAd;
@protocol AdMoreFullScreenInterstitialAdDelegate <NSObject>

@optional
/**插全屏广告加载成功回调*/
- (void)fullScreenInterstitiaAdDidLoad:(AdMoreFullScreenInterstitialAd *)rewardedVideoAd slotId:(NSString *)slotId;
/**插全屏广告加载失败回调*/
- (void)fullScreenInterstitiaAd:(AdMoreFullScreenInterstitialAd *)rewardedVideoAd didFailWithError:(NSError *_Nullable)error;

/**插全屏广告开始播放回调*/
- (void)fullScreenInterstitiaAdPlayStart:(AdMoreFullScreenInterstitialAd *)rewardedVideoAd;
/**插全屏广告播放结束回调*/
- (void)fullScreenInterstitiaAdPlayEnd:(AdMoreFullScreenInterstitialAd *)rewardedVideoAd;
/**插全屏广告播放出错*/
- (void)fullScreenInterstitiaAdPlayError:(AdMoreFullScreenInterstitialAd *)rewardedVideoAd error:(NSError *)error;


/**插全屏广告点击回调*/
- (void)fullScreenInterstitiaAdDidClick:(AdMoreFullScreenInterstitialAd *)rewardedVideoAd;
/**插全屏广告关闭回调*/
- (void)fullScreenInterstitiaAdDidClose:(AdMoreFullScreenInterstitialAd *)rewardedVideoAd;


@end
```



#### 使用示例

AdMoreSDKDemo示例工程中的 **AdMoreFullScreenInterstitialAdController**



## 2.5 原生信息流广告(AdMoreNativeAd)

#### 介绍

原生信息流广告是由SDK提供渲染完成的view组件，可适用于多个场景。

#### 广告接口说明

```objective-c
@interface AdMoreNativeAd : NSObject

@property (nonatomic, strong,readonly) NSString *slotID;
@property (nonatomic, strong,readonly) UIViewController *rootViewController;
@property (nonatomic, assign,readonly) CGSize adSize;

@property (nonatomic, weak) id<AdMoreNativeAdDelegate> delegate;

/**
 slotID: 广告位ID
 rootViewController: 广告链接跳转的根控制器
 */
- (instancetype)initWithSlotID:(NSString *)slotID rootController:(UIViewController *)rootViewController;

/**
 slotID: 广告位ID
 rootViewController: 广告链接跳转的根控制器
 adSize: 广告大小 由于各个公司广告宽高比不同，在nativeAdViewRenderSuccess中可以获得广告的真实高度。
 */
- (instancetype)initWithSlotID:(NSString *)slotID rootController:(UIViewController *)rootViewController adSize:(CGSize)adSize;

/**加载广告*/
- (void)loadAdDataWithCount:(NSInteger)count;

@end
```



#### 广告代理回调

```c
@class AdMoreNativeAd;
@protocol AdMoreNativeAdDelegate <NSObject>

@optional
/**信息流广告加载成功*/
- (void)nativeAdViewsLoadSuccess:(NSArray *)nativeAdViews;
/**信息流广告加载失败**/
- (void)nativeAdViewsFailedToLoadWithError:(NSError *)error;

/**信息流渲染成功*/
- (void)nativeAdViewRenderSuccess:(UIView *)nativeAdView;
/**信息流渲染失败*/
- (void)nativeAdViewFailedToRender:(UIView *)nativeAdView error:(NSError *)error;

/**信息流点击事件**/
- (void)nativeAdViewDidClick:(UIView *)nativeAdView;
/**信息流关闭事件*/
- (void)nativeAdViewDidClose:(UIView *)nativeAdView;

/**视频完成播放**/
- (void)nativeAdViewPlayerDidPlayFinish:(UIView *)nativeAdView;
/**视频播放，可能回调多次，暂停->继续播放也会回调**/
- (void)nativeAdViewVideoDidPlaying:(UIView *)nativeAdView;
/**视频暂停播放**/
- (void)nativeAdViewVideoDidPause:(UIView *)nativeAdView;

@end
```

#### 使用示例

AdMoreSDKDemo示例工程中的 **AdMoreNativeAdController**



## 2.6 视频激励广告(AdMoreRewardVideoAd)

#### 介绍

激励视频广告是一种全新的广告形式，用户可选择观看视频广告以换取有价物，例如虚拟货币、应用内物品和独家内容等等；这类广告一般有一定长度。一般是需要观看一段时间后才能跳过(各个广告商可跳过的时间不相同)。

#### 广告接口说明

```objective-c
@interface AdMoreRewardVideoAd : NSObject

@property (nonatomic, strong, readonly) NSString *slotID;

@property (nonatomic, weak) id<AdMoreRewardVideoAdDelegate> delegate;

/**
 slotID: 广告位ID
 */
- (instancetype)initWithSlotID:(NSString *)slotID;

- (void)loadAdData;

- (void)showFromRootViewController:(UIViewController *)showController;

@end
```



#### 广告代理回调

```objective-c
@class AdMoreRewardVideoAd;
@protocol AdMoreRewardVideoAdDelegate <NSObject>

@optional
/**激励视频加载成功回调*/
- (void)rewardedVideoAdDidLoad:(AdMoreRewardVideoAd *)rewardedVideoAd slotId:(NSString *)slotId;
/**激励视频加载失败回调*/
- (void)rewardedVideoAd:(AdMoreRewardVideoAd *)rewardedVideoAd didFailWithError:(NSError *_Nullable)error;

/**激励视频开始播放回调*/
- (void)rewardedVideoAdPlayStart:(AdMoreRewardVideoAd *)rewardedVideoAd;
/**激励视频播放结束回调*/
- (void)rewardedVideoAdPlayEnd:(AdMoreRewardVideoAd *)rewardedVideoAd;
/**激励视频播放出错*/
- (void)rewardedVideoAdPlayError:(AdMoreRewardVideoAd *)rewardedVideoAd error:(NSError *)error;

/**激励视频点击回调*/
- (void)rewardedVideoAdDidClick:(AdMoreRewardVideoAd *)rewardedVideoAd;
/**激励视频关闭回调*/
- (void)rewardedVideoAdDidClose:(AdMoreRewardVideoAd *)rewardedVideoAd;
/**奖励验证回调*/
- (void)rewardedVideoAdServerRewardDidSucceed:(AdMoreRewardVideoAd *)rewardedVideoAd verify:(BOOL)verify;

@end

```



#### 使用示例

AdMoreSDKDemo示例工程中的 **AdMoreRewardVideoAdController**



## 2.7 开屏广告(AdMoreSplashAd)

#### 介绍

开屏广告主要是 APP 启动时展示的全屏广告视图,展示完毕后自动关闭并进入应用的主界面。

#### 广告接口说明

```objective-c
@interface AdMoreSplashAd : NSObject

@property (nonatomic, strong, readonly) NSString *slotID;

@property (nonatomic, weak) id<AdMoreSplashAdDelegate> delegate;

/**slotID: 广告位ID
 对象不可重复使用，重新展示需要重新创建对象
 */
- (instancetype)initWithSlotID:(NSString *)slotID;

/**开始加载广告**/
- (void)loadADData;

/**广告加载完成后展示*/
- (void)showSplashAd;

@end
```



#### 广告代理回调

```objective-c
@class AdMoreSplashAd;
@protocol AdMoreSplashAdDelegate <NSObject>

@optional
/// 加载成功回调
- (void)splashAdDidLoad:(AdMoreSplashAd *)splashAd;
/// 加载失败回调
- (void)splashAd:(AdMoreSplashAd *)splashAd didFailWithError:(NSError *)error;
/// 展示成功回调
- (void)splashAdWillVisible:(AdMoreSplashAd *)splashAd;
//展示失败
- (void)splashAdDidShowFailed:(AdMoreSplashAd *)splashAd error:(NSError *)error;
/// 广告点击回调
- (void)splashAdDidClick:(AdMoreSplashAd *)splashAd;
/// 广告关闭回调
- (void)splashAdDidClose:(AdMoreSplashAd *)splashAd;
@end
```

#### 使用示例

AdMoreSDKDemo示例工程中的 **AdMoreSplashAdController**