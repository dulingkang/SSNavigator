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
-(void)pageInit;

/*!
 *  当页面即将向前切换到当前页面时调用
 */
-(void)pageWillForwardToMe;

/*!
 *  当页面已经向前切换到当前页面时调用
 */
-(void)pageDidForwardToMe;

/*!
 *  当页面即将向前离开当前页面时调用
 */
-(void)pageWillForwardFromMe;

/*!
 *  当页面已经向前切换离开当前页面时调用
 */
-(void)pageDidForwardFromMe;

/*!
 *  当页面即将向后回退到当前页面时调用
 */
-(void)pageWillBackwardToMe;

/*!
 *  当页面已经向后回退到当前页面时调用
 */
-(void)pageDidBackwardToMe;

/*!
 *  当页面即将后退离开当前页面时调用
 */
-(void)pageWillBackwardFromMe;

/*!
 *  当页面已经后退离开当前页面时调用
 */
-(void)pageDidBackwardFromMe;

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

-(void)pageDestroy;

/*!
 *  不能解析url时的回调
 */
- (void)canNotForwardUrl:(NSString *)urlStr;
@end

