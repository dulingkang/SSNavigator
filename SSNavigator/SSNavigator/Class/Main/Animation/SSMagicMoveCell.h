//
//  SSMagicMoveCell.h
//  SSNavigator
//
//  Created by ShawnDu on 2016/12/2.
//  Copyright © 2016年 Shawn Du. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSMagicMoveCell : NSObject
@property (strong,nonatomic) UIView *view;
@property (nonatomic) BOOL rotate3DByX;
@property (nonatomic) BOOL rotate3DByY;
- (instancetype)init;
- (instancetype)initWithView:(UIView *)view rotate3DByX:(BOOL)enableX rotate3DByY:(BOOL)enableY;
@end
