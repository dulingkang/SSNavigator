//
//  SSPageAnimate.m
//  SSNavigator
//
//  Created by ShawnDu on 2016/11/22.
//  Copyright © 2016年 Shawn Du. All rights reserved.
//

#import "SSPageAnimate.h"
#import "SSWeakify.h"
#import "SSMagicCell.h"
#import "SSMagicMoveSet.h"

@interface SSPageAnimate()<CAAnimationDelegate>
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
    if (type == SSPageAnimateMagicMove) {
        [self magicMoveFrom:fromPage to:toPage completion:completion];
        return ;
    }
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
        from.userInteractionEnabled = true;
        from.userInteractionEnabled = true;
        if (self.originCallback) {
            self.originCallback();
        }
        [strong_from.layer removeAnimationForKey:animationKey];
        [strong_to.layer removeAnimationForKey:animationKey];
        strong_to.frame = toViewEndFrame;
        strong_from.frame = fromViewEndFrame;
    };
    
    [UIView animateWithDuration:self.duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        mask.alpha = self.alphaRate;
    } completion:^(BOOL finished) {
        [mask removeFromSuperview];
    }];

}

- (void)animateFrom:(UIViewController *)fromPage to:(UIViewController *)toPage completion:(VoidCallBack)completion {
    [self animateWidthType:SSPageAnimatePushLeft from:fromPage to:toPage completion:completion];
}

#pragma mark - delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (self.callback) {
        self.callback();
    }
    self.callback = nil;
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

- (void)magicMoveFrom:(UIViewController *)from to:(UIViewController *)to completion:(VoidCallBack)completion {
    from.view.layer.opacity = 1;
    to.view.layer.opacity = 0;
    
    NSMutableDictionary* magicCells = [[NSMutableDictionary alloc] init];
    
    NSDictionary* fromMagicSet = nil;
    NSDictionary* toMagicSet = nil;
    if ([from respondsToSelector:@selector(magicMoveSet)]) {
        fromMagicSet = [((id<SSMagicMoveSet>)from) magicMoveSet];
    }
    if ([to respondsToSelector:@selector(magicMoveSet)]) {
        toMagicSet = [((id<SSMagicMoveSet>)to) magicMoveSet];
    }
    for (NSString* key in fromMagicSet) {
        id fromView = [fromMagicSet objectForKey:key];
        id toView = [toMagicSet objectForKey:key];
        if (fromView != nil && toView != nil) {
            SSMagicCell* cell = [[SSMagicCell alloc] init];
            cell.fromView = fromView;
            cell.toView = toView;
            cell.fromViewBegin = [cell getFromView].frame;
            cell.fromViewEnd = [[cell getFromView].superview convertRect:[cell getToView].frame fromView:[cell getToView].superview];
            cell.toViewBegin = [[cell getToView].superview convertRect:[cell getFromView].frame fromView:[cell getFromView].superview];
            cell.toViewEnd = [cell getToView].frame;
            [magicCells setObject:cell forKey:key];
        }
    }
    
    // 设置开始
    for(NSString* key in magicCells) {
        SSMagicCell* cell = [magicCells objectForKey:key];
        if (cell != nil) {
            [cell getToView].frame = cell.toViewBegin;
            if ([cell needRotateByX]) {
                [cell getToView].layer.transform = CATransform3DRotate(CATransform3DIdentity, -1*M_PI, 1, 0, 0) ;
                [cell getFromView].layer.transform = CATransform3DRotate(CATransform3DIdentity, 0, 1, 0, 0) ;
            }
            if ([cell needRotateByY]) {
                [cell getToView].layer.transform = CATransform3DRotate(CATransform3DIdentity, -1*M_PI, 0, 1, 0) ;
                [cell getFromView].layer.transform = CATransform3DRotate(CATransform3DIdentity, 0, 0, 1, 0) ;
            }
        }
    }
    
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        //  @strongify(magicCells)
        from.view.layer.opacity = 0;
        to.view.layer.opacity = 1;
        
        // 设置结束
        for(NSString* key in magicCells) {
            SSMagicCell* cell = [magicCells objectForKey:key];
            if (cell != nil) {
                [cell getFromView].frame = cell.fromViewEnd;
                [cell getToView].frame = cell.toViewEnd;
                
                if ([cell needRotateByX]) {
                    [cell getToView].layer.transform = CATransform3DRotate(CATransform3DIdentity, 0, 1, 0, 0) ;
                    [cell getFromView].layer.transform = CATransform3DRotate(CATransform3DIdentity, M_PI, 1, 0, 0) ;
                }
                if ([cell needRotateByY]) {
                    [cell getToView].layer.transform = CATransform3DRotate(CATransform3DIdentity, 0, 0, 1, 0) ;
                    [cell getFromView].layer.transform = CATransform3DRotate(CATransform3DIdentity, M_PI, 0, 1, 0) ;
                }
            }
        }
        
    } completion:^(BOOL finished) {
        from.view.layer.opacity = 1;
        to.view.layer.opacity = 1;
        from.view.userInteractionEnabled = true;
        from.view.userInteractionEnabled = true;
        // 设置from
        for(NSString* key in magicCells) {
            SSMagicCell* cell = [magicCells objectForKey:key];
            if (cell != nil) {
                [cell getFromView].frame = cell.fromViewBegin;
                [cell getToView].frame = cell.toViewEnd;
                
                [cell getFromView].layer.transform = CATransform3DIdentity;
                [cell getToView].layer.transform = CATransform3DIdentity;
            }
        }
        if (completion) {
            completion();
        }
    }];
}
@end
