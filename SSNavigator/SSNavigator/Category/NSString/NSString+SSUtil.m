//
//  NSString+SSUtil.m
//  SSNavigator
//
//  Created by ShawnDu on 2016/11/21.
//  Copyright © 2016年 Shawn Du. All rights reserved.
//

#import "NSString+SSUtil.h"

@implementation NSString (SSUtil)

- (NSString *)ssTrim {
    if (self.length <= 0) {
        return self;
    }
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL)ssIsEmpty {
    NSString *trim = [self ssTrim];
    if (trim.length <= 0) {
        return true;
    }
    return false;
}

- (NSString *)ssFirstToUpper {
    if (self.length <= 0) {
        return self;
    } else if (self.length == 1) {
        return self.uppercaseString;
    } else {
        return [NSString stringWithFormat:@"%@%@",[self substringToIndex:1].uppercaseString, [self substringFromIndex:1]];
    }
}

@end
