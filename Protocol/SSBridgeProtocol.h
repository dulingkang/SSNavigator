//
//  SSBridgeProtocol.h
//  SSNavigator
//
//  Created by ShawnDu on 2016/11/28.
//  Copyright © 2016年 Shawn Du. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *  该协议定义了暴露给javascript调用的接口
 */
@protocol SSBridgeProtocol <NSObject>
@required
/**
 * 子类需要重写此函数已提供当前Bridge在javascript中的对象名称
 */
-(NSString *)javascriptObjectName;
@end
