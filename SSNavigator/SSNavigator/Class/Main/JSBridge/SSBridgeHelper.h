//
//  SSBridgeHelper.h
//  SSNavigator
//
//  Created by dulingkang on 2016/11/28.
//  Copyright © 2016年 Shawn Du. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSBridgeObject.h"

@interface SSBridgeHelper : NSURLProtocol
/*!
 *  注册桥接对象
 *
 *  @param bridgeObject 桥接对象
 */
-(void)registBridge:(id<SSBridgeProtocol>)bridgeObject;

/*!
 *  绑定webView
 *  需要在绑定webView之前将所有的桥接对象注册到DMBridgeHelper中去
 *
 *  @param webView 待绑定的webView
 */
- (void)bindWebView:(UIWebView *)webView;

+ (SSBridgeHelper *)sharedInstance;
@end
