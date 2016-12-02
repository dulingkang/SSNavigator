//
//  SSPageLifeCircle.h
//  SSNavigator
//
//  Created by ShawnDu on 2016/11/21.
//  Copyright © 2016年 Shawn Du. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SSPageLifeCircle <NSObject>
@optional
/*!
 *  当页面即将展示时调用(包含页面前进和回退)
 */
-(void)pageWillBeShown;

/*!
 *  当页面已经展示时调用(包含页面前进和后退)
 */
-(void)pageDidShown;

/*!
 *  当页面即将隐藏(包含页面前进和后退)
 */
-(void)pageWillBeHidden;

/*!
 *  当页面已经隐藏(包含前进和后退)
 */
-(void)pageDidHidden;

/*!
 *  不能解析url时的回调
 */
- (void)canNotForwardUrl:(NSString *)urlStr;
@end

