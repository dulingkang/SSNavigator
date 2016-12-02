//
//  SSJSPageBridge.h
//  SSNavigator
//
//  Created by ShawnDu on 2016/12/2.
//  Copyright © 2016年 Shawn Du. All rights reserved.
//

#import "SSBridgeObject.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "SSNavigator.h"

@protocol DMJSPageBridgeJSExport <JSExport>
- (void)forward:(NSString *)url;
- (void)backward:(NSString *)param;
- (void)pushFlow;
- (void)popFlow:(NSString *)param;
- (void)callback:(NSString *)param;
- (void)registRedirect:(NSString *)fromUrl :(NSString *)toUrl;
- (NSString *)topPage:(int)deep;
- (void)rollup;
- (void)httpPost:(NSString *)requestId :(NSString *)url :(id)headers :(NSString *)body;
- (void)httpGet:(NSString *)requestId :(NSString*)url :(id)headers;
- (void)httpCallback:(NSString *)requestId :(NSString *)statusCode :(NSString *)data;
- (void)httpCancel:(NSString *)requestId;
@end

@interface SSJSPageBridge : SSBridgeObject<SSBridgeProtocol>
@property (nonatomic, weak) UIWebView* jsPage;
@property (nonatomic, weak) SSNavigator* navigator;
@end
