//
//  SSNavigator.m
//  SSNavigator
//
//  Created by ShawnDu on 2016/11/21.
//  Copyright © 2016年 Shawn Du. All rights reserved.
//

#import "SSNavigator.h"
#import "SSPage.h"
#import "SSObjectCache.h"
#import "SSPageAnimate.h"

@interface DMPageHolder : NSObject
@property (nonatomic, strong) SSPage *pageInstance;
/*!
 *  页面参数
 */
@property (strong,nonatomic) NSDictionary *pageParams;

/*!
 *  框架参数
 */
@property (strong,nonatomic) NSDictionary *frameworkParams;

/*!
 *  跳转时传入的url(不包含传递给框架的参数,及@开头的参数)
 */
@property (nonatomic, strong) NSString *pageUrl;

@property (nonatomic, strong) NSString *pageName;
/*!
 *  向上一个页面回传数据的接口
 */
@property (nonatomic, copy) void (^pageCallback)(NSDictionary *dict);
@end

@implementation DMPageHolder
- (void)setPageParams:(NSDictionary *)pageParams {
    _pageParams = pageParams;
    if ([self.pageInstance respondsToSelector:@selector(setPageParams:)]) {
        [((id<SSPageAware>)self.pageInstance) setPageParams:pageParams];
    }
}

- (void)setFrameworkParams:(NSDictionary *)frameworkParams {
    _frameworkParams = frameworkParams;
    if ([self.pageInstance respondsToSelector:@selector(setFrameworkParams:)]) {
        [((id<SSPageAware>)self.pageInstance) setFrameworkParams:frameworkParams];
    }
}

- (void)setPageUrl:(NSString *)pageUrl {
    _pageUrl = pageUrl;
    if ([self.pageInstance respondsToSelector:@selector(setPageUrl:)]) {
        [((id<SSPageAware>)self.pageInstance) setPageUrl:pageUrl];
    }
}

- (void)setPageCallback:(void (^)(NSDictionary *dict))pageCallback {
    _pageCallback = pageCallback;
    if ([self.pageInstance respondsToSelector:@selector(setPageCallback:)]) {
        [((id<SSPageAware>)self.pageInstance) setPageCallback:pageCallback];
    }
}

- (void)setPageName:(NSString *)pageName {
    _pageName = pageName;
    if ([self.pageInstance respondsToSelector:@selector(setPageName:)]) {
        [((id<SSPageAware>)self.pageInstance) setPageName:pageName];
    }
}
@end

@interface SSNavigator ()
/*!
 *  单个页面的堆栈
 *  注意： 页面堆栈中存储的不直接是page实例，而是DMPageHolder对象
 *        存储了关于页面的更多信息
 */
@property (nonatomic, strong) NSMutableArray *pageStack;
/*!
 *  业务流程堆栈（每个对象代表一个业务流程的起点页面）
 */
@property (nonatomic, strong) NSMutableArray *pageFlowStack;
@property (nonatomic, strong) SSObjectCache *pageCache;

@property (nonatomic) BOOL pageAnimationForward;
@property (nonatomic, strong) SSPage *pageAnimationFrom;
@property (nonatomic, strong) SSPage *pageAnimationTo;
@end

@implementation SSNavigator

+ (SSNavigator *)sharedInstance {
    static SSNavigator *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SSNavigator alloc] init];
    });
    return sharedInstance;
}


@end
