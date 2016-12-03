//
//  SSPageAnimate.h
//  SSNavigator
//
//  Created by ShawnDu on 2016/11/22.
//  Copyright © 2016年 Shawn Du. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef NS_ENUM(NSInteger, SSPageAnimateType) {
    SSPageAnimatePushLeft,
    SSPageAnimatePopRight,
    SSPageAnimatePushTop,
    SSPageAnimatePopBottom,
    SSPageAnimateMagicMove,
    SSPageAnimateNone,
    SSPageAnimateUnknown
};

typedef void (^VoidCallBack)();

@interface SSPageAnimate : NSObject
@property (nonatomic) CGFloat leaveRate;
@property (nonatomic) CGFloat alphaRate;
@property (nonatomic) NSTimeInterval duration;
@property (nonatomic) CAMediaTimingFunction *timeFunction;
- (instancetype)init;

- (void)animateWidthType:(SSPageAnimateType)type from:(UIViewController *)fromPage to:(UIViewController *)toPage completion:(VoidCallBack)completion;
- (void)animateFrom:(UIViewController *)fromPage to:(UIViewController *)toPage completion:(VoidCallBack)completion;
@end
