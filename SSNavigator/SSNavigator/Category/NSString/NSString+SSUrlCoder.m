//
//  NSString+SSUrlCoder.m
//  SSNavigator
//
//  Created by ShawnDu on 2016/11/21.
//  Copyright © 2016年 Shawn Du. All rights reserved.
//

#import "NSString+SSUrlCoder.h"

@implementation NSString (SSUrlCoder)

- (NSString *)ssEncodeUrl {
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (NSString *)ssDecodeUrl {
    return self.stringByRemovingPercentEncoding;
}
@end
