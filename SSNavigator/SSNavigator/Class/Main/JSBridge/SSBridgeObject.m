//
//  SSBridgeObject.m
//  SSNavigator
//
//  Created by ShawnDu on 2016/11/28.
//  Copyright © 2016年 Shawn Du. All rights reserved.
//

#import "SSBridgeObject.h"
#import <objc/runtime.h>

@implementation SSBridgeObject

-(NSString*)javascriptObjectName {
    return @"window.bridge";
}
@end
