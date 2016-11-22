//
//  SSPageAnimate.h
//  SSNavigator
//
//  Created by ShawnDu on 2016/11/22.
//  Copyright © 2016年 Shawn Du. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^VoidCallBack)();
@protocol SSPageAnimate <NSObject>
/*!
 *  动画实现函数
 *
 *  @param from     起点页面
 *  @param to       终点页面
 *  @param callback 动画结束时的回调
 */
-(void)animateFrom:(UIViewController *)from to:(UIViewController*)to callback:(void (^)())callback;
@end
