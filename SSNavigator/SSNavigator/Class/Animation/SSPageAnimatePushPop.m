//
//  SSPageAnimatePushPop.m
//  SSNavigator
//
//  Created by ShawnDu on 2016/11/22.
//  Copyright © 2016年 Shawn Du. All rights reserved.
//

#import "SSPageAnimatePushPop.h"

@implementation SSPageAnimatePushPop

- (instancetype)init {
    if(self=[super init]) {
        self.alphaRate = 0.4;
        self.leaveRate = 0.3;
        self.duration = 0.6;
        self.timeFunction = [CAMediaTimingFunction functionWithControlPoints:0 :0.6 :0.3 :1];
    }
    return self;
}
@end
