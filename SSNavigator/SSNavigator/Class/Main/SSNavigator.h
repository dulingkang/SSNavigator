//
//  SSNavigator.h
//  SSNavigator
//
//  Created by ShawnDu on 2016/11/21.
//  Copyright © 2016年 Shawn Du. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SSPage;
@protocol SSNavigatorDelegate <NSObject>
@optional
- (void)navigatorWillChangePageTo:(NSString *)url;
- (void)navigatorDidChangedPageTo:(NSString *)url;
- (BOOL)navigatorShouldCachePage:(NSString *)url;
- (BOOL)navigatorShouldForwardTo:(NSString *)url;
- (Class)navigatorShouldOverridePageClass:(NSString*)url;
@end

@interface SSNavigator : UIViewController
@property (nonatomic, weak) id<SSNavigatorDelegate> delegate;
- (instancetype)init;
- (instancetype)initWithUrl:(NSString*)url;

+ (SSNavigator *)sharedInstance;

/*!
 *  返回栈顶页面对象
 *
 *  @return 栈顶页面对象
 */
- (SSPage*)topPage;

/*!
 *  返回栈顶页面对象
 *
 *  @return 栈顶页面对象
 */
- (SSPage*)topPage:(int)deep;

/*!
 * 将当期页面滚动到顶部
 */
- (void)rollup;


@end


/*!
 *  Navigator是框架页面导航的核心类型，该类型提供三个平台的版本(android,iOS,javascript)，只是语言上的差异，功能完全一致。Navigator实现了基于url控制页面跳转及页面参数传递的功能，跳转可以在Native页面和H5页面任意跳转，并维护统一的页面堆栈。
 */
@interface SSNavigator(Navigate)
/*!
 *  跳转到指定的页面
 *
 *  @param url 页面资源路径
 *     可能为app，h5或者RN页面
 */
- (void)forward:(NSString*)url;

/*!
 *  跳转到指定的页面
 *
 *  @param url      页面资源路径
 *  @param callback 页面回调接口
 */
- (void)forward:(NSString* )url
       callback:(void(^)(NSDictionary *dict))callback;

/**
 * 触发页面回退
 * @param param 可选返回参数，允许携带框架参数(参数名以@开头)。（例如"param=value&param2=value2&@animate=popright"）
 *     如果不传此参数，框架将在页面回退的同时不向上一个页面的回传数据。
 *     这样做的目的，是允许开发者在当前页面其他时机去主动调用callback回传数据，
 *     避免页面传参和页面回退动作绑死。
 */
- (void)backward:(NSString *)param;


- (void)backward;

/**
 * 单独向上一个页面回传参数的接口
 * @param param 参数 （例如"param=value&param2=value2"）
 */
- (void)callback:(NSString *)param;

/*!
 *  开启一个子业务流程
 */
- (void)pushFlow;
/*!
 *  结束当前子业务流程，同时页面跳转回之前pushFlow的地方
 */
- (void)popFlow:(NSString*)param;
@end



@interface SSNavigator(Registry)
/*!
 *  注册本地页面(不推荐使用此函数注册页面)
 *  默认情况下按照约定页面类型的名字可以作为跳转url中的页面名称，无需特别的注册。
 *  除非在极其特殊的情况下需要覆盖这个约定，才使用此函数注册页面, 赋予页面不同于类型名字的标志。
 *  因为在实际App中页面数量会越来越大，如果一定要在一个统一的地方注册的话，这个注册会变得很难维护。
 *  所以推荐使用约定来确定页面名称。不要过分的依赖这种页面注册功能。
 *
 *  @param name      本地页面的标识符,页面名称不区分大小写(例如标识符:Payment, 其他页面通过app://Payment来访问)
 *  @param pageClass
 *             页面实现类的class属性(例如Payment如果实现类为DMPayment的话，通过[DMPayment class]来指定)
 *             页面类型需要是UIViewController或者其子类
 */
+ (void)registAppPage:(NSString *)name
            pageClass:(Class)pageClass;

/*!
 *  注册重定向url
 *  注意：url不包含参数部分
 *
 *  @param toUrl 目标url
 *  @param fromUrl 源url
 */
+ (void)registRedirectFromUrl:(NSString *)fromUrl toUrl:(NSString *)toUrl;
@end
