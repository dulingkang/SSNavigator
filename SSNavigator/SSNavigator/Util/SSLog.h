//
//  SSLog.h
//  SSNavigator
//
//  Created by ShawnDu on 2016/11/21.
//  Copyright © 2016年 Shawn Du. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SSLogDefine(className)\
SSLog* className##_logger = nil;\
+(SSLog*)logger {\
if(className##_logger == nil) {\
className##_logger = [[SSLog alloc] initWithClass:[className class]];\
}\
return className##_logger;\
}\
-(SSLog*)logger {\
return [className logger];\
}

#define SSDebugEnabled() \
[self.logger isEnable:DMLogLevelDebug]

#define SSInfoEnabled() \
[self.logger isEnable:SSLogLevelInfo]

#define SSWarnEnabled() \
[self.logger isEnable:SSLogLevelWarn]

#define SSErrorEnabled() \
[self.logger isEnable:SSLogLevelError]

#define SSFatalEnabled() \
[self.logger isEnable:SSLogLevelFatal]

#define SSDebug( ... ) \
if ([self.logger isEnable:SSLogLevelDebug]) {\
[self.logger debug:[NSString stringWithFormat:__VA_ARGS__]];\
}

#define SSInfo( ... ) \
if ([self.logger isEnable:SSLogLevelInfo]) {\
[self.logger info:[NSString stringWithFormat:__VA_ARGS__]];\
}

#define SSWarn( ... ) \
if ([self.logger isEnable:SSLogLevelWarn]) {\
[self.logger warn:[NSString stringWithFormat:__VA_ARGS__]];\
}

#define SSError( ... ) \
if ([self.logger isEnable:SSLogLevelError]) {\
[self.logger error:[NSString stringWithFormat:__VA_ARGS__]];\
}

#define SSFatal( ... ) \
if ([self.logger isEnable:SSLogLevelFatal]) {\
[self.logger fatal:[NSString stringWithFormat:__VA_ARGS__]];\
}


typedef NS_ENUM(NSInteger, DMLogLevel) {
    SSLogLevelDebug,//默认从0开始
    SSLogLevelInfo,
    SSLogLevelWarn,
    SSLogLevelError,
    SSLogLevelFatal,
    SSLogLevelSilent
};


@interface SSLog : NSObject


+ (BOOL)isLogEnable:(enum DMLogLevel) level;

- (instancetype)initWithClass:(Class)clazz;

@property (nonatomic) enum DMLogLevel level;

-(BOOL)isEnable:(enum DMLogLevel) level;
-(void)debug:(NSString*)msg;
-(void)info:(NSString*)msg;
-(void)warn:(NSString*)msg;
-(void)error:(NSString*)msg;
-(void)fatal:(NSString*)msg;
@end
