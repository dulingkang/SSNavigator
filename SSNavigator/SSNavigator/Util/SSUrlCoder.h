//
//  SSUrlCoder.h
//  SSNavigator
//
//  Created by ShawnDu on 2016/11/21.
//  Copyright © 2016年 Shawn Du. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMUrlInfo : NSObject
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *urlOrigin;
@property (nonatomic, copy) NSString *urlPath;
@property (nonatomic, copy) NSString *protocol;
@property (nonatomic, copy) NSString *animation;
@property (nonatomic, copy) NSString *appPageName;
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, strong) NSMutableDictionary *frameworkParams;
@property (nonatomic, strong) NSMutableArray *paramsArray;
@end

@interface SSUrlCoder : NSObject

+ (DMUrlInfo *)decodeUrl:(NSString *)url;
+ (DMUrlInfo *)decodeParams:(NSString*)paramUrl;

+ (NSString *)encodeParams:(NSDictionary*)param;
@end
