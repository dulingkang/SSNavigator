//
//  SSPage.m
//  SSNavigator
//
//  Created by ShawnDu on 2016/11/21.
//  Copyright © 2016年 Shawn Du. All rights reserved.
//

#import "SSPage.h"
#import "SSLog.h"
#import "NSString+SSUtil.h"


@interface SSPage ()

@end

@implementation SSPage

@synthesize navigator;
@synthesize pageCallback;
@synthesize pageParams;
@synthesize frameworkParams;
@synthesize pageUrl;
@synthesize pageName;
@synthesize needPopflow;

SSLogDefine(SSPage)

#pragma mark - life cycle
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
    if ([self judgeSelfIsNotTopPage]) return ;
    [self.navigator forward:url];
}

-(void)forward:(NSString *)url callback:(SSDictCallBack)callback {
    if ([self judgeSelfIsNotTopPage]) return ;
    [self.navigator forward:url callback:callback];
}

-(void)backward {
    if ([self judgeSelfIsNotTopPage]) return ;
    [self.navigator backward];
}

-(void)backward:(NSString *)param {
    if ([self judgeSelfIsNotTopPage]) return ;
    [self.navigator backward:param];
}

-(void)callback:(NSString *)param {
    if ([self judgeSelfIsNotTopPage]) return ;
    [self.navigator callback:param];
}

-(void)pushFlow {
    if ([self judgeSelfIsNotTopPage]) return ;
    [self.navigator pushFlow];
}

-(NSDictionary *) magicMoveSet {return nil;}

- (void)warePageParam:(NSString*)value byKey:(NSString*)key {
    NSString* setterName = [NSString stringWithFormat:@"set%@:", [key ssFirstToUpper]];
    SEL setterMethod = NSSelectorFromString(setterName);
    if([self respondsToSelector:setterMethod]) {
        NSMethodSignature* methodSign = [[self class] instanceMethodSignatureForSelector:setterMethod];
        const char * argType = [methodSign getArgumentTypeAtIndex:2];
        SSDebug(@"autoware param key:%@ value:%@ type:%s",key,value,argType);
        NSNumber *number = [value numberFromStringSignature:argType];
        if (number) {
            [self setValue:number forKey:key];
        } else {
            [self setValue:value forKey:key];
        }
    } else {
        SSDebug(@"skip param key:%@ value:%@",key,value);
    }
}

-(void)pageRollup {
    SSDebug(@"%@ --> %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd))
}

#pragma mark - private method
- (BOOL)judgeSelfIsNotTopPage {
    if (self != self.navigator.topPage) {
        SSDebug(@"self class is:%@, not equal topPage class:%@", NSStringFromClass(self.class),NSStringFromClass(self.navigator.topPage.class));
        return true;
    }
    return false;
}
@end
