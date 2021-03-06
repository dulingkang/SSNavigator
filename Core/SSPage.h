//
//  SSPage.h
//  SSNavigator
//
//  Created by ShawnDu on 2016/11/21.
//  Copyright © 2016年 Shawn Du. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSPageLifeCycle.h"
#import "SSPageAware.h"
#import "SSMagicMoveSet.h"
#import "SSNavigator.h"

@interface SSPage : UIViewController<SSPageAware, SSPageLifeCycle, SSMagicMoveSet>
-(void)forward:(NSString *)url;
-(void)forward:(NSString *)url callback:(SSDictCallBack)callback;
-(void)backward;

/**
 * 触发页面回退
 * @param param 可选返回参数，允许携带框架参数(参数名以@开头)。（例如"param=value&param2=value2&@animate=popright"）
 *     如果不传此参数，框架将在页面回退的同时不向上一个页面的回传数据。
 *     这样做的目的，是允许开发者在当前页面其他时机去主动调用callback回传数据，
 *     避免页面传参和页面回退动作绑死。
 */
-(void)backward:(NSString *)param;
-(void)callback:(NSString *)param;
-(void)pushFlow;

-(void)warePageParam:(NSString*)value byKey:(NSString*)key;
-(void)pageRollup;
@end
