//
//  SSLog.m
//  SSNavigator
//
//  Created by ShawnDu on 2016/11/21.
//  Copyright © 2016年 Shawn Du. All rights reserved.
//

#import "SSLog.h"
#import "NSString+SSUtil.h"

@interface SSLog()
@property (nonatomic, copy) NSString *name;
@end

@implementation SSLog

int SSLog_level = SSLogLevelInfo;
NSString* DMLog_filter = nil;
NSString* DMLog_msgFilter = nil;

+ (void)setLogLevel:(enum DMLogLevel) level {
    SSLog_level = level;
}

+ (void)setNameFilter:(NSString*)filter {
    DMLog_filter = filter;
}

+ (void)setMessageFilter:(NSString*)filter {
    DMLog_msgFilter = filter;
}

+ (void)setClassFilter:(Class)filter {
    DMLog_filter = NSStringFromClass(filter);
}

+ (BOOL)isLogEnable:(enum DMLogLevel) level {
    return level >= SSLog_level;
}

+ (NSString*)levelToString:(enum DMLogLevel)level {
    if (level == SSLogLevelDebug) {
        return @"debug";
    }
    if (level == SSLogLevelInfo) {
        return @" info";
    }
    if (level == SSLogLevelWarn) {
        return @" warn";
    }
    if (level == SSLogLevelError) {
        return @"error";
    }
    if (level == SSLogLevelFatal) {
        return @"fatal";
    }
    return @"log";
}

+ (enum DMLogLevel)levelFromString:(NSString *) level {
    level = [level ssTrim];
    if ([@"debug" isEqualToString:level]) {
        return SSLogLevelDebug;
    }
    if ([@"info" isEqualToString:level]) {
        return SSLogLevelInfo;
    }
    if ([@"warn" isEqualToString:level]) {
        return SSLogLevelWarn;
    }
    if ([@"error" isEqualToString:level]) {
        return SSLogLevelError;
    }
    if ([@"fatal" isEqualToString:level]) {
        return SSLogLevelFatal;
    }
    return SSLogLevelInfo;
}

+ (NSString*)colorForLevel:(enum DMLogLevel) level {
    if (level == SSLogLevelFatal) {
        return @"255,0,0";
    }
    if (level == SSLogLevelError) {
        return @"255,97,0";
    }
    if (level == SSLogLevelWarn) {
        return @"255,215,0";
    }
    if (level == SSLogLevelInfo) {
        return @"0,255,0";
    }
    return @"255,255,255";
}

+ (void)log:(NSString *)msg name:(NSString *)name level:(enum DMLogLevel)level {
    if (msg == nil) {
        return ;
    }
    
    if (![SSLog isLogEnable:level]) {
        return ;
    }
    
    if (DMLog_filter != nil && name != nil) {
        NSRange range = [name rangeOfString:DMLog_filter options:NSRegularExpressionSearch];
        if (range.location == NSNotFound) {
            return;
        }
    }
    
    if (DMLog_msgFilter != nil) {
        NSRange range = [msg rangeOfString:DMLog_msgFilter options:NSRegularExpressionSearch];
        if (range.location == NSNotFound) {
            return;
        }
    }
    
    NSLog(@"\033[fg65,105,225;[%@ %@]\033[; \033[fg%@; %@ \033[;\n",name,[SSLog levelToString:level],[SSLog colorForLevel:level],msg);
    
    if(level >= SSLogLevelWarn) {
        NSString* callstack = [[NSThread callStackSymbols] description];
        NSLog(@"\033[fg%@;%@\033[;\n",[SSLog colorForLevel:level],callstack);
    }
}


- (instancetype)initWithClass:(Class)clazz {
    if (self = [super init]) {
        self.name = NSStringFromClass(clazz);
        self.level = SSLogLevelDebug; // 默认由全局的开关控制, 因此此处全开，在全局打开的情况下，单个logger可以更细的设置级别
    }
    return self;
}

- (BOOL)isEnable:(enum DMLogLevel) level {
    return level >= self.level && [SSLog isLogEnable:level];
}

- (void)debug:(NSString*)msg {
    if (![self isEnable:SSLogLevelDebug]) {
        return;
    }
    [SSLog log:msg name:self.name level:SSLogLevelDebug];
}
- (void)info:(NSString*)msg {
    if (![self isEnable:SSLogLevelInfo]) {
        return;
    }
    [SSLog log:msg name:self.name level:SSLogLevelInfo];
}
- (void)warn:(NSString*)msg {
    if (![self isEnable:SSLogLevelWarn]) {
        return;
    }
    [SSLog log:msg name:self.name level:SSLogLevelWarn];
}
- (void)error:(NSString*)msg {
    if (![self isEnable:SSLogLevelError]) {
        return;
    }
    [SSLog log:msg name:self.name level:SSLogLevelError];
}
- (void)fatal:(NSString*)msg {
    if (![self isEnable:SSLogLevelFatal]) {
        return;
    }
    [SSLog log:msg name:self.name level:SSLogLevelFatal];
}


+ (void)initialize {
    NSString *propertyFile = [[NSBundle mainBundle] pathForResource:@"SSLog.plist" ofType:nil];
    if (propertyFile) {
        NSDictionary* propertyDic = [NSDictionary dictionaryWithContentsOfFile:propertyFile];
        NSString* logLevel = [propertyDic objectForKey:@"LogLevel"];
        if (!logLevel.ssIsEmpty) {
            [SSLog setLogLevel:[SSLog levelFromString:logLevel]];
        }
        NSString* nameFilter = [propertyDic objectForKey:@"NameFilter"];
        if (!nameFilter.ssIsEmpty) {
            [SSLog setNameFilter:nameFilter];
        }
        NSString* messageFilter = [propertyDic objectForKey:@"MessageFilter"];
        if (!messageFilter.ssIsEmpty) {
            [SSLog setMessageFilter:messageFilter];
        }
    }
}

@end
