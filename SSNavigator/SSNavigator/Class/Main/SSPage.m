//
//  SSPage.m
//  SSNavigator
//
//  Created by ShawnDu on 2016/11/21.
//  Copyright © 2016年 Shawn Du. All rights reserved.
//

#import "SSPage.h"
#import "SSLog.h"


@interface SSPage ()

@end

@implementation SSPage

SSLogDefine(SSPage)

#pragma mark - life cycle
-(void)pageInit {
    SSDebug(@"%@ --> %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd))
}

-(void)pageDestroy {
    SSDebug(@"%@ --> %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd))
}

/*!
 *  当页面即将向前切换到当前页面时调用
 */
-(void)pageWillForwardToMe {
    SSDebug(@"%@ --> %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd))
}

/*!
 *  当页面已经向前切换到当前页面时调用
 */
-(void)pageDidForwardToMe{
    SSDebug(@"%@ --> %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd))
}

/*!
 *  当页面即将向前离开当前页面时调用
 */
-(void)pageWillForwardFromMe{
    SSDebug(@"%@ --> %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd))
}

/*!
 *  当页面已经向前切换离开当前页面时调用
 */
-(void)pageDidForwardFromMe{
    SSDebug(@"%@ --> %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd))
}

/*!
 *  当页面即将向后回退到当前页面时调用
 */
-(void)pageWillBackwardToMe{
    SSDebug(@"%@ --> %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd))
}

/*!
 *  当页面已经向后回退到当前页面时调用
 */
-(void)pageDidBackwardToMe{
    SSDebug(@"%@ --> %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd))
}

/*!
 *  当页面即将后退离开当前页面时调用
 */
-(void)pageWillBackwardFromMe{
    SSDebug(@"%@ --> %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd))
}

/*!
 *  当页面已经后退离开当前页面时调用
 */
-(void)pageDidBackwardFromMe{
    SSDebug(@"%@ --> %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd))
}

/*!
 *  当页面即将展示时调用(包含页面前进和回退)
 */
-(void)pageWillBeShown{
    SSDebug(@"%@ --> %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd))
}

/*!
 *  当页面已经展示时调用(包含页面前进和后退)
 */
-(void)pageDidShown{
    SSDebug(@"%@ --> %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd))
}

/*!
 *  当页面即将隐藏(包含页面前进和后退)
 */
-(void)pageWillBeHidden{
    SSDebug(@"%@ --> %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd))
}

/*!
 *  当页面已经隐藏(包含前进和后退)
 */
-(void)pageDidHidden{
    SSDebug(@"%@ --> %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd))
}

#pragma mark - public method
-(void)forward:(NSString *)url {
}

-(void)forward:(NSString *)url callback:(void(^)(NSDictionary *dict))callback {
}

-(void)backward {
}

-(void)backward:(NSString *)param {
}

-(void)callback:(NSString *)param {
}

-(void)pushFlow {
}

-(void)popFlow:(NSString *)param {
}

@end
