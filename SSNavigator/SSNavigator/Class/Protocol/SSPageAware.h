//
//  SSPageAware.h
//  SSNavigator
//
//  Created by ShawnDu on 2016/11/21.
//  Copyright © 2016年 Shawn Du. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SSNavigator;

@protocol SSPageAware <NSObject>

@property (nonatomic, weak) SSNavigator *navitator;

/*!
 *  页面参数
 */
@property (nonatomic, strong) NSDictionary *pageParams;

/*!
 *  框架参数
 */
@property (nonatomic, strong) NSDictionary *frameworkParams;

/*!
 *  跳转时传入的url(不包含传递给框架的参数,及@开头的参数)
 */
@property (nonatomic, copy) NSString *pageUrl;

@property (nonatomic, copy) NSString *pageName;

/*!
 *  向上一个页面回传数据的接口
 */
@property (nonatomic, copy) void (^pageCallback)(NSDictionary *dict);
@end


