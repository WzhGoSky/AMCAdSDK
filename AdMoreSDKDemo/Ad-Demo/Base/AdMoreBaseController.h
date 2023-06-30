//
//  AdMoreBaseController.h
//  AdMoreSDKDemo
//
//  Created by Hayder on 2023/5/9.
//

#import <UIKit/UIKit.h>
#import "AdMoreGlobalDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface AdMoreBaseController : UIViewController

@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, assign) NSTimeInterval endTime;

@property (nonatomic, strong) UIButton *loadDataBtn;

@property (nonatomic, strong) UIButton *showDataBtn;

@property (nonatomic, strong) UIButton *closeBtn;

- (void)loadEvent;

- (void)showEvent;

- (void)closeEvent;

- (void)showLoadTime;

@end

NS_ASSUME_NONNULL_END
