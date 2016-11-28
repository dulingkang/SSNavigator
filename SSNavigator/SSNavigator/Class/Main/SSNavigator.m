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
#import "SSLog.h"
#import "SSUrlCoder.h"

@interface SSPageHolder : NSObject
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

@implementation SSPageHolder
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
 *  注意： 页面堆栈中存储的不直接是page实例，而是SSPageHolder对象
 *        存储了关于页面的更多信息
 */
@property (nonatomic, strong) NSMutableArray<SSPageHolder *> *pageStack;
/*!
 *  业务流程堆栈（每个对象代表一个业务流程的起点页面）
 */
@property (nonatomic, strong) NSMutableArray *pageFlowStack;
@property (nonatomic, strong) SSObjectCache *pageCache;

@property (nonatomic) BOOL pageAnimationForward;
@property (nonatomic, strong) SSPage *pageAnimationFrom;
@property (nonatomic, strong) SSPage *pageAnimationTo;
@property (nonatomic, strong) SSUrlInfo *info;
@end

@implementation SSNavigator

SSLogDefine(SSNavigator)

+ (SSNavigator *)sharedInstance {
    static SSNavigator *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SSNavigator alloc] init];
    });
    return sharedInstance;
}

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - public method
/*!
 *  注册本地页面
 *
 *  @param name      本地页面的标识符(例如标识符:Payment, 其他页面通过app://Test来访问)
 *  @param pageClass 页面实现类的class属性(例如Payment如果实现类为Test的话，通过[Test class]来指定)
 */
+ (void)registAppPage:(NSString*)name pageClass:(Class)pageClass {
    [self.pageRegistry setValue:pageClass forKey:[name lowercaseString]];
}

- (void)forward:(NSString *)url {
    [self forward:url callback:nil];
}

- (void)forward:(NSString *)url callback:(void (^)(NSDictionary *dict))callback {
    if (!url || url.length == 0) {
        return ;
    }
    _info = [SSUrlCoder decodeUrl:url];
    if (self.delegate && [self.delegate respondsToSelector:@selector(navigatorShouldForwardTo:)]) {
        if (![self.delegate navigatorShouldForwardTo:url]) {
            SSDebug(@"Navigator should not forward to url according to delegate : %@",url);
            return ;
        }
    }
    
    if ([self isJumpEnable]) {
        [self topPage];
    }
}

#pragma mark - private method
- (BOOL)isJumpEnable {
    if (_info != nil) {
        NSString* value = [_info.frameworkParams objectForKey:@"jump"];
        if (value != nil && [@"true" isEqualToString:value]) {
            return YES;
        }
    }
    return NO;
}

- (void)jump:(NSString *)url callback:(void(^)(NSDictionary *dict))callback{
    SSPage *from = self.topPage;
    SSPage *to = [self resolvePage:url];
}

- (SSPage *)resolvePage:(NSString *)url {
    SSPage *page = nil;
    Class cls = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(navigatorShouldOverridePageClass:)]) {
        cls = [self.delegate navigatorShouldOverridePageClass:url];
        if (cls) {
            SSDebug(@"Navigator will use custom class: '%@',url: '%@'", NSStringFromClass(cls), url);
        }
        if (!cls) {
            if ([@"app" isEqualToString:_info.protocol]) {
                cls = [[SSNavigator pageRegistry] objectForKey:[_info.appPageName lowercaseString]];
                if (!cls) {
                    cls = NSClassFromString(_info.appPageName);
                }
            } else {
                cls = [];
            }
        }
    }
}

#pragma mark - getter
- (SSObjectCache *)pageCache {
    if (!_pageCache) {
        _pageCache = [[SSObjectCache alloc] initWithCap:12];
    }
    return _pageCache;
}

- (NSMutableArray *)pageStack {
    if (!_pageStack) {
        _pageStack = [NSMutableArray new];
    }
    return _pageStack;
}

- (NSMutableArray *)pageFlowStack {
    if (!_pageFlowStack) {
        _pageFlowStack = [NSMutableArray new];
    }
    return _pageFlowStack;
}

- (SSPage *)topPage {
    return [self.pageStack lastObject].pageInstance;
}

#pragma mark class getter
NSMutableDictionary *SSpageRegistry;
NSMutableDictionary *SSpageAnimationRegistry;
+ (NSMutableDictionary *)pageRegistry {
    if(SSpageRegistry == nil) {
        SSpageRegistry = [[NSMutableDictionary alloc] init];
    }
    return SSpageRegistry;
}

+ (NSMutableDictionary *)pageAnimationRegistry {
    if(SSpageAnimationRegistry == nil) {
        SSpageAnimationRegistry = [[NSMutableDictionary alloc] init];
    }
    return SSpageAnimationRegistry;
}

@end
