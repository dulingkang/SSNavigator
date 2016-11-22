//
//  SSPageAnimatePushPop.h
//  SSNavigator
//
//  Created by ShawnDu on 2016/11/22.
//  Copyright © 2016年 Shawn Du. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface SSPageAnimatePushPop : NSObject
@property (nonatomic) CGFloat leaveRate;
@property (nonatomic) CGFloat alphaRate;
@property (nonatomic) CGFloat duration;
@property (nonatomic, strong) CAMediaTimingFunction *timeFunction;
- (instancetype)init;
@end
