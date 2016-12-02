//
//  SSMagicCell.h
//  SSNavigator
//
//  Created by ShawnDu on 2016/12/2.
//  Copyright © 2016年 Shawn Du. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSMagicCell : NSObject
@property (strong,nonatomic) NSString *key;
@property (strong,nonatomic) id fromView;
@property (strong,nonatomic) id toView;
@property (nonatomic) CGRect fromViewBegin;
@property (nonatomic) CGRect fromViewEnd;
@property (nonatomic) CGRect toViewBegin;
@property (nonatomic) CGRect toViewEnd;

- (BOOL)needRotateByX;
- (BOOL)needRotateByY;
- (UIView *)getFromView;
- (UIView *)getToView;
@end
