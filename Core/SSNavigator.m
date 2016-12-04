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
#import "SSWebPage.h"

#ifndef dispatch_main_async_safe
#define dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}
#endif

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
@property (nonatomic, copy) SSDictCallBack pageCallback;
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

- (void)setPageCallback:(SSDictCallBack)pageCallback {
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

typedef NS_ENUM(NSInteger, SSForwardType){
    SSForward,
    SSJump,
    SSBackward
};

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

//- (instancetype)init {
//    if(self = [super init]) {
//        self = [SSNavigator sharedInstance];
//    }
//    return self;
//}
//
//- (instancetype)initWithCoder:(NSCoder *)aDecoder {
//    if (self = [super initWithCoder:aDecoder]) {
//        self = [SSNavigator sharedInstance];
//    }
//    return self;
//}

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

+ (void)registRedirectFromUrl:(NSString *)fromUrl toUrl:(NSString *)toUrl {
    [self.pageRedirectRegistry setObject:toUrl forKey:fromUrl];
}

- (void)forward:(NSString *)url {
    [self forward:url callback:nil];
}

- (void)forward:(NSString *)url callback:(SSDictCallBack)callback {
//    dispatch_main_async_safe(^{
        if (!url || url.length == 0) {
            return ;
        }
        _info = [SSUrlCoder decodeUrl:url];
//        NSString* redirectUrlPath = [[SSNavigator pageRedirectRegistry] objectForKey:_info.urlPath];
//        if (redirectUrlPath != nil) {
//            NSString *redirectUrl = [NSString stringWithFormat:@"%@%@",redirectUrlPath,[url substringFromIndex:_info.urlPath.length]];
//            _info = [SSUrlCoder decodeUrl:redirectUrl];
//        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(navigatorShouldForwardTo:)]) {
            if (![self.delegate navigatorShouldForwardTo:url]) {
                SSDebug(@"Navigator should not forward to url according to delegate : %@",url);
                return ;
            }
        }
        if ([self isJumpEnable]) {
            [self jump:url callback:callback];
            return ;
        }
        [self forwardMainLogic:url forwardType:SSForward callback:callback];
//    });
}

- (void)backward {
    [self backward:nil];
}

- (void)backward:(NSString *)param {
    dispatch_main_async_safe(^{
        SSPageHolder *fromHolder = [self.pageStack lastObject];
        SSPageHolder *toHolder = [self topPageHolder:1];
        if (!toHolder) {
            SSDebug(@"Navigator can not backward due to empty page stack");
            return ;
        }
        if (fromHolder.pageInstance.needPopflow) {
            SSDebug(@"popFlow from %@ to %@",NSStringFromClass(fromHolder.pageInstance.class),NSStringFromClass(toHolder.pageInstance.class));
            [self.pageFlowStack removeLastObject];
        } else {
            SSDebug(@"Navigator will backward with return param : %@",param);
        }
        [self backwardFrom:fromHolder to:toHolder param:param];
    });
}

- (void)callback:(NSString *)param {
    SSPageHolder* topPage = [self.pageStack lastObject];
    if(topPage.pageCallback != nil) {
        SSUrlInfo* info = [SSUrlCoder decodeParams:param];
        topPage.pageCallback(info.params);
    }
}

- (void)pushFlow {
    SSPageHolder* topPage = [self.pageStack lastObject];
    if (topPage) {
        SSError(@"push flow failed due to top page nil");
        return;
    }
    SSError(@"push flow => page : %@, count:%ld",NSStringFromClass(topPage.pageInstance.class), self.pageFlowStack.count + 1);
    [self.pageFlowStack addObject:topPage];
}

- (void)popFlow:(NSString*)param {
    //nil
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

- (void)forwardMainLogic:(NSString *)url forwardType:(SSForwardType)forwardType callback:(SSDictCallBack)callback {
    [self forwardMainLogic:url from:self.topPage to:[self resolvePage:url] forwardType:forwardType callback:callback];
}

- (void)forwardMainLogic:(NSString *)url from:(SSPage *)from to:(SSPage *)to forwardType:(SSForwardType)forwardType callback:(SSDictCallBack)callback {
    SSPageAnimateType animateType = [self resolveAnimation:forwardType];
    NSString *logString = @"forward";
    SSPageHolder *page = nil;
    if (forwardType == SSJump) {
        logString = @"jump";
    }
    if (forwardType == SSBackward) {
        logString = @"backward";
    } else {
        if ([self judgeCannotForward:url from:from to:to animateType:animateType logString:logString]) {
            return ;
        }
        page = [self prepareNewPage:to andCallback:callback];
        [self.pageStack addObject:page];
    }
    SSDebug(@"Navigator will %@ to url : %@", logString, url);
    [self makePageWillLifeCycleFrom:from to:to isForward:true];
    [self removeAllFromTree];
    if (from && animateType != SSPageAnimateUnknown) {
        [self performPageAnimationWithType:animateType from:from to:to isForward:forwardType != SSBackward];
    } else {
        [self addPageToTree:to];
        if (forwardType == SSJump) {
            [self jumpStackTo:page];
        }
        [self makePageDidLifeCycleFrom:from to:to isForward:true];
    }
}

- (void)jump:(NSString *)url callback:(SSDictCallBack)callback{
    [self forwardMainLogic:url forwardType:SSJump callback:callback];
}

- (void)backwardFrom:(SSPageHolder *)fromHolder to:(SSPageHolder *)toHolder param:(NSString *)param {
    SSDebug(@"backwardFrom %@ to %@",NSStringFromClass(fromHolder.pageInstance.class),NSStringFromClass(toHolder.pageInstance.class));
    [self popPageFromStackTo:toHolder.pageInstance];
    SSUrlInfo* info = [SSUrlCoder decodeParams:param];
    /**
     * 确保在页面的事件通知之前将参数传递出去
     */
    if (fromHolder.pageInstance && fromHolder.pageCallback && info.params.count > 0) {
        fromHolder.pageCallback(info.params);
    }
    [self forwardMainLogic:nil from:fromHolder.pageInstance to:toHolder.pageInstance forwardType:SSBackward callback:nil];
}

- (BOOL)judgeCannotForward:(NSString *)url from:(SSPage *)from to:(SSPage *)to animateType:(SSPageAnimateType)animateType logString:(NSString *)logString {
    if (!to || animateType == SSPageAnimateUnknown) {
        SSDebug(@"can not %@ due to unresolved element for url: %@", logString, url);
        if ([from respondsToSelector:@selector(canNotForwardUrl:)]) {
            [from canNotForwardUrl:url];
        }
        return true;
    }
    return false;
}

#pragma mark  resolve page and animation
- (SSPage *)resolvePage:(NSString *)url {
    SSPage *page = nil;
    Class cls = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(navigatorShouldOverridePageClass:)]) {
        cls = [self.delegate navigatorShouldOverridePageClass:url];
        if (cls) {
            SSDebug(@"Navigator will use custom class: '%@',url: '%@'", NSStringFromClass(cls), url);
        }
    }
    if (!cls) {
        if ([@"app" isEqualToString:_info.protocol]) {
            cls = [[SSNavigator pageRegistry] objectForKey:[_info.appPageName lowercaseString]];
            if (!cls) {
                cls = NSClassFromString(_info.appPageName);
            }
        } else if([@"http" isEqualToString:_info.protocol]
                  || [@"https" isEqualToString:_info.protocol]
                  || [@"file" isEqualToString:_info.protocol]
                  ) {
            cls = [SSWebPage class];
        }
    }
    if (cls) {
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(navigatorShouldCachePage:)] && [self.delegate navigatorShouldCachePage:url]) {
            page = [self.pageCache objectForKey:NSStringFromClass(cls)];
        }
        if (!page) {
            page = [[cls alloc] init];
        } else {
            [self.pageCache remove:NSStringFromClass(cls)];
        }
        if ([page respondsToSelector:@selector(setNavigator:)]) {
            [((id<SSPageAware>)page) setNavigator:self];
        }
    }
    return page;
}

- (SSPageAnimateType)resolveAnimation:(SSForwardType)forwardType {
    NSString *inputAnimationString = [_info.frameworkParams objectForKey:@"animate"];
    SSPageAnimateType returnType = SSPageAnimateNone;
    if (inputAnimationString.length < 1) {
        if (forwardType == SSBackward) {
            returnType = SSPageAnimatePopRight;
        }
        if (forwardType == SSForward) {
            returnType = SSPageAnimatePushLeft;
        }
    } else {
        if ([inputAnimationString isEqualToString:@"pushleft"]) {
            returnType = SSPageAnimatePushLeft;
        } else if ([inputAnimationString isEqualToString:@"popright"]) {
            returnType = SSPageAnimatePopRight;
        } else if ([inputAnimationString isEqualToString:@"pushtop"]) {
            returnType = SSPageAnimatePushTop;
        } else if ([inputAnimationString isEqualToString:@"popbottom"]) {
            returnType = SSPageAnimatePopBottom;
        } else if ([inputAnimationString isEqualToString:@"magicmove"]) {
            returnType = SSPageAnimateMagicMove;
        } else if ([inputAnimationString isEqualToString:@"null"]) {
            returnType = SSPageAnimateNone;
        } else {
            returnType = SSPageAnimateUnknown;
        }
    }
    return returnType;
}

- (void)performPageAnimationWithType:(SSPageAnimateType)animateType from:(SSPage *)from to:(SSPage *)to isForward:(BOOL)isForward{
    if (isForward) {
        [self addPageToTree:from];
        [self addPageToTree:to];
    } else {
        [self addPageToTree:to];
        [self addPageToTree:from];
    }
    from.view.userInteractionEnabled = false;
    to.view.userInteractionEnabled = false;
    SSPageAnimate *animate = [SSPageAnimate new];
    [animate animateWidthType:animateType from:from to:to completion:^{
        [self removePageFromTree:from];
        [self addPageToTree:to];
        [self makePageDidLifeCycleFrom:from to:to isForward:isForward];
    }];
}

#pragma mark make page do life cycle
- (void)makePageWillLifeCycleFrom:(SSPage *)from to:(SSPage *)to isForward:(BOOL)isForward {
    if ([from respondsToSelector:@selector(pageWillBeHidden)]) {
        [from pageWillBeHidden];
    }
    if ([to respondsToSelector:@selector(pageWillBeShown)]) {
        [to pageWillBeShown];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(navigatorWillChangePageTo:)]) {
        [self.delegate navigatorWillChangePageTo:to.pageUrl];
    }
}

- (void)makePageDidLifeCycleFrom:(SSPage *)from to:(SSPage *)to isForward:(BOOL)isForward {
    if ([from respondsToSelector:@selector(pageDidHidden)]) {
        [from pageDidHidden];
    }
    if ([to respondsToSelector:@selector(pageDidShown)]) {
        [to pageDidShown];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(navigatorDidChangedPageTo:)]) {
        [self.delegate navigatorDidChangedPageTo:to.pageUrl];
    }
}

-(SSPageHolder *)prepareNewPage:(SSPage *)page andCallback:(SSDictCallBack)callback{
    SSPageHolder* holder = [[SSPageHolder alloc] init];
    holder.pageInstance = page;
    holder.pageUrl = _info.url;
    holder.pageName = _info.appPageName;
    holder.pageParams = _info.params;
    holder.frameworkParams = _info.params;
    holder.pageCallback = callback;
    [self autoWareParams:_info.params forPage:page];
    return holder;
}

-(void)autoWareParams:(NSDictionary*)params forPage:(UIViewController*)page {
    SSDebug(@"try autoware params to page : %@ ", NSStringFromClass([page class]));
    for (NSString *key in params) {
        NSString* value = params[key];
        SSDebug(@"try autoware param key:%@ value:%@",key,value);
        if ([page isKindOfClass:[SSPage class]]) {
            [((SSPage *)page) warePageParam:value byKey:key];
        }
    }
}

#pragma mark tree process
-(void)removeAllFromTree {
    for (UIViewController *sub in self.childViewControllers) {
        [sub.view removeFromSuperview];
        [sub removeFromParentViewController];
    }
}

-(void)addPageToTree:(UIViewController *) page {
    if(!page) {
        return;
    }
    [self addChildViewController:page];
    [self.view addSubview:page.view];
}

- (void)removePageFromTree:(UIViewController *)page {
    if (!page) {
        return;
    }
    [page.view removeFromSuperview];
    [page removeFromParentViewController];
}

#pragma mark stack process
- (void)jumpStackTo:(SSPageHolder *)page {
    for (SSPageHolder *pageHolder in self.pageStack) {
        [self putToCache:pageHolder.pageInstance];
    }
    [self.pageFlowStack removeAllObjects];
    [self.pageStack removeAllObjects];
    [self.pageStack addObject:page];
}

- (void)putToCache:(SSPage *)page {
    // 如果无delegate不缓存任何页面
    if (self.delegate == nil) {
        return;
    }
    // 如果delegate明确返回不缓存此页面
    if (self.delegate != nil
        && [self.delegate respondsToSelector:@selector(navigatorShouldCachePage:)]
        && ![self.delegate navigatorShouldCachePage:page.pageUrl]) {
        return;
    }
    [self.pageCache setObject:page forKey:NSStringFromClass(page.class)];
}

- (void)popPageFromStackTo: (UIViewController *)targetPage {
    while (self.topPage != targetPage && self.pageStack.count > 0) {
        SSPageHolder* pageHolder = self.pageStack.lastObject;
        [self putToCache:pageHolder.pageInstance];
        [self.pageStack removeLastObject];
    }
}

- (SSPageHolder *)topPageHolder:(int)deep {
    if (self.pageStack.count < deep + 1) {
        return nil;
    }
    SSPageHolder *holder = self.pageStack[self.pageStack.count - deep - 1];
    return holder;
}

#pragma mark - protocol method
- (SSPage *)topPage {
    return [self.pageStack lastObject].pageInstance;
}

-(SSPage *)topPage:(int)deep {
    return [self topPageHolder:deep].pageInstance;
}

-(void) rollup {
    if (self.topPage) {
        [self.topPage pageRollup];
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

#pragma mark class getter
NSMutableDictionary *SSpageRegistry;
NSMutableDictionary *SSPageRedirectRegistry;
+ (NSMutableDictionary *)pageRegistry {
    if(SSpageRegistry == nil) {
        SSpageRegistry = [[NSMutableDictionary alloc] init];
    }
    return SSpageRegistry;
}

+ (NSMutableDictionary *)pageRedirectRegistry {
    if(SSPageRedirectRegistry == nil) {
        SSPageRedirectRegistry = [[NSMutableDictionary alloc] init];
    }
    return SSPageRedirectRegistry;
}

@end
