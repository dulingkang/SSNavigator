//
//  SSMagicCell.m
//  SSNavigator
//
//  Created by ShawnDu on 2016/12/2.
//  Copyright © 2016年 Shawn Du. All rights reserved.
//

#import "SSMagicCell.h"
#import "SSMagicMoveCell.h"

@implementation SSMagicCell

- (BOOL)needRotateByX {
    if ([self.fromView isKindOfClass:[SSMagicMoveCell class]]) {
        return [((SSMagicMoveCell*)self.fromView) rotate3DByX];
    }
    if ([self.toView isKindOfClass:[SSMagicMoveCell class]]) {
        return [((SSMagicMoveCell*)self.toView) rotate3DByX];
    }
    return NO;
}

- (BOOL)needRotateByY {
    if ([self.fromView isKindOfClass:[SSMagicMoveCell class]]) {
        return [((SSMagicMoveCell*)self.fromView) rotate3DByY];
    }
    if ([self.toView isKindOfClass:[SSMagicMoveCell class]]) {
        return [((SSMagicMoveCell*)self.toView) rotate3DByY];
    }
    return NO;
}

- (UIView *)getFromView {
    if ([self.fromView isKindOfClass:[UIView class]]) {
        return self.fromView;
    }
    if ([self.fromView isKindOfClass:[SSMagicMoveCell class]]) {
        return [((SSMagicMoveCell*)self.fromView) view];
    }
    return nil;
}

- (UIView *)getToView {
    if ([self.toView isKindOfClass:[UIView class]]) {
        return self.toView;
    }
    if ([self.toView isKindOfClass:[SSMagicMoveCell class]]) {
        return [((SSMagicMoveCell*)self.toView) view];
    }
    return nil;
}

@end
