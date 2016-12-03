//
//  SSMagicMoveCell.m
//  SSNavigator
//
//  Created by ShawnDu on 2016/12/2.
//  Copyright © 2016年 Shawn Du. All rights reserved.
//

#import "SSMagicMoveCell.h"

@implementation SSMagicMoveCell

- (instancetype)init {
    if(self = [super init]) {
        self.rotate3DByX = NO;
        self.rotate3DByY = NO;
    }
    return self;
}

- (instancetype)initWithView:(UIView*)view rotate3DByX:(BOOL)enableX rotate3DByY:(BOOL)enableY {
    if(self = [super init]) {
        self.view = view;
        self.rotate3DByX = enableX;
        self.rotate3DByY = enableY;
    }
    return self;
}

@end
