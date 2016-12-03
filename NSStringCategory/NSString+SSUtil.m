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

- (NSNumber *)numberFromStringSignature:(const char *)type {
    if (strcmp(type, "c") == 0) {
        char v = 0;
        if ([self hasPrefix:@"'"] && [self hasSuffix:@"'"] && self.length == 3) {
            v = [self characterAtIndex:1];
        } else {
            v = [self intValue];
        }
        if ([@"true" isEqualToString:self] || [@"YES" isEqualToString:self]) {
            v = 1;
        }
        if ([@"false" isEqualToString:self] || [@"NO" isEqualToString:self]) {
            v = 0;
        }
        return [NSNumber numberWithChar:v];
    }
    if (strcmp(type, "i") == 0) {
        return @([self intValue]);
    }
    if (strcmp(type, "I") == 0) {
        return @((unsigned int)[self intValue]);
    }
    if (strcmp(type, "s") == 0) {
        return @([self intValue]);
    }
    if (strcmp(type, "S") == 0) {
        return @([self intValue]);
    }
    if (strcmp(type, "l") == 0) {
        return @([self longLongValue]);
    }
    if (strcmp(type, "L") == 0) {
        return @([self longLongValue]);
    }
    if (strcmp(type, "f") == 0) {
        return @([self floatValue]);
    }
    if (strcmp(type, "d") == 0) {
        return @([self doubleValue]);
    }
    if (strcmp(type, "B") == 0) {
        return @([self boolValue]);
    }
    if (strcmp(type, "q") == 0) {
        return @([self longLongValue]);
    }
    return nil;
}
@end
