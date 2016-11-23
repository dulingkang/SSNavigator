//
//  SSPageAnimate.m
//  SSNavigator
//
//  Created by ShawnDu on 2016/11/22.
//  Copyright © 2016年 Shawn Du. All rights reserved.
//

#import "SSPageAnimate.h"
#import "SSWeakify.h"

@interface SSPageAnimate()
@property (nonatomic, copy) VoidCallBack callback;
@property (nonatomic, copy) VoidCallBack originCallback;
@end

@implementation SSPageAnimate
- (instancetype)init {
    if(self = [super init]) {
        self.alphaRate = 0.4;
        self.leaveRate = 0.3;
        self.duration = 0.6;
        self.timeFunction = [CAMediaTimingFunction functionWithControlPoints:0 :0.6 :0.3 :1];
    }
    return self;
}

#pragma mark - public method
- (void)animateWidthType:(SSPageAnimateType)type from:(UIViewController *)fromPage to:(UIViewController *)toPage completion:(VoidCallBack)completion {
    NSString *animationKey = @"pushAnimation";
    self.originCallback = completion;
    
    UIView *from = fromPage.view;
    UIView *to = toPage.view;
    CGRect fromViewStartFrame = from.frame;
    CGRect fromViewEndFrame = CGRectMake(to.frame.origin.x - to.frame.size.width * self.leaveRate, to.frame.origin.y, to.frame.size.width, to.frame.size.height);
    CGRect toViewStartFrame = CGRectMake(to.frame.origin.x + to.frame.size.width, to.frame.origin.y, to.frame.size.width, to.frame.size.height);
    CGRect toViewEndFrame = to.frame;

    UIView* mask = [[UIView alloc] initWithFrame:from.bounds];
    mask.backgroundColor = [UIColor blackColor];
    mask.alpha = 0;

    switch (type) {
        case SSPageAnimatePushLeft:
            [from addSubview:mask];
            [self addBasicAnimation:from targetValue:fromViewEndFrame.origin.x - from.frame.origin.x animationKey:animationKey];
            [self addBasicAnimation:to targetValue:toViewEndFrame.origin.x - toViewStartFrame.origin.x animationKey:animationKey];
            break;
        case SSPageAnimatePopRight:
            animationKey = @"popAnimation";
            [to addSubview:mask];
            fromViewEndFrame = from.frame;
            fromViewStartFrame = CGRectMake(to.frame.origin.x - to.frame.size.width * self.leaveRate, to.frame.origin.y, to.frame.size.width, to.frame.size.height);
            toViewEndFrame = CGRectMake(to.frame.origin.x + to.frame.size.width, to.frame.origin.y, to.frame.size.width, to.frame.size.height);
            toViewStartFrame = to.frame;
            break;
        case SSPageAnimatePushTop:
            [from addSubview:mask];
            toViewEndFrame = to.frame;
            toViewStartFrame = CGRectMake(to.frame.origin.x, to.frame.origin.y + to.frame.size.height, to.frame.size.width, to.frame.size.height);
            [self addBasicAnimation:to targetValue:toViewEndFrame.origin.y - toViewStartFrame.origin.y animationKey:animationKey];
            break;
        case SSPageAnimatePopBottom:
            animationKey = @"popAnimation";
            [to addSubview:mask];
            toViewStartFrame = to.frame;
            toViewEndFrame = CGRectMake(to.frame.origin.x, to.frame.origin.y + to.frame.size.height, to.frame.size.width, to.frame.size.height);
            [self addBasicAnimation:to targetValue:toViewEndFrame.origin.y - toViewStartFrame.origin.y animationKey:animationKey];
            break;
        default:
            break;
    }
    
    @weakify_self
    @weakify(from)
    @weakify(to)
    self.callback = ^{
        @strongify_self
        @strongify(from)
        @strongify(to)
        if (self.originCallback) {
            self.originCallback();
        }
        [strong_from.layer removeAnimationForKey:animationKey];
        [strong_to.layer removeAnimationForKey:animationKey];
        strong_to.frame = toViewEndFrame;
        strong_from.frame = fromViewEndFrame;
    };
    
    @weakify(mask)
    [UIView animateWithDuration:self.duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        @strongify(mask)
        strong_mask.alpha = self.alphaRate;
    } completion:^(BOOL finished) {
        @strongify(mask)
        [strong_mask removeFromSuperview];
    }];

}

- (void)animateFrom:(UIViewController *)fromPage to:(UIViewController *)toPage completion:(VoidCallBack)completion {
    [self animateWidthType:SSPageAnimatePushLeft from:fromPage to:toPage completion:completion];
}

#pragma mark - private method
- (void)addBasicAnimation:(UIView *)view targetValue:(CGFloat)targetValue animationKey:(NSString *)animationKey {
    CABasicAnimation*    fromAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    fromAnimation.duration = self.duration;
    fromAnimation.beginTime = 0; //CACurrentMediaTime() + 1;
    fromAnimation.valueFunction = [CAValueFunction functionWithName:kCAValueFunctionTranslateX];
    fromAnimation.timingFunction = self.timeFunction;
    fromAnimation.fromValue = @(0);
    fromAnimation.toValue = [NSNumber numberWithFloat:targetValue];
    fromAnimation.fillMode = kCAFillModeForwards;
    fromAnimation.removedOnCompletion = NO;
    [view.layer addAnimation:fromAnimation forKey:animationKey];
}
@end
