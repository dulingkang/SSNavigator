//
//  SSBridgeHelper.m
//  SSNavigator
//
//  Created by dulingkang on 2016/11/28.
//  Copyright © 2016年 Shawn Du. All rights reserved.
//

#import "SSBridgeHelper.h"

@interface SSBridgeHolder : NSObject
@property (nonatomic, strong) id<SSBridgeProtocol> bridgeObject;
@property (nonatomic, strong) NSMutableDictionary *methodMap;
-(void)registBridgeScripts:(UIWebView*)webView ;
-(NSString *)invokeFromJavascript:(NSString *)methodName withParam:(NSArray *)param;
-(NSString *)key;
@end

@implementation SSBridgeHolder


@end

@implementation SSBridgeHelper

+ (SSBridgeHelper *)sharedInstance {
    static SSBridgeHelper *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [SSBridgeHelper new];
    });
    return sharedInstance;
}

@end
