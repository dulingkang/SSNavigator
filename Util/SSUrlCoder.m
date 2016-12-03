//
//  SSUrlCoder.m
//  SSNavigator
//
//  Created by ShawnDu on 2016/11/21.
//  Copyright © 2016年 Shawn Du. All rights reserved.
//

#import "SSUrlCoder.h"
#import "NSString+SSUrlCoder.h"
#import "NSString+SSUtil.h"

@implementation SSUrlInfo

- (NSMutableDictionary *)params {
    if (!_params) {
        _params = [NSMutableDictionary new];
    }
    return _params;
}

- (NSMutableDictionary *)frameworkParams {
    if (!_frameworkParams) {
        _frameworkParams = [NSMutableDictionary new];
    }
    return _frameworkParams;
}

- (NSMutableArray *)paramsArray {
    if (!_paramsArray) {
        _paramsArray = [NSMutableArray new];
    }
    return _paramsArray;
}
@end

@implementation SSUrlCoder

+ (SSUrlInfo *)decodeUrl:(NSString *)url {
    SSUrlInfo* info = nil;
    if (!url) {
        return info;
    }
    url             = [url ssTrim];
    NSRange stub    = [url rangeOfString:@"?"];
    
    if(stub.location != NSNotFound && url.length > (stub.location + 1)) {
        NSString* paramUrl  = [url substringFromIndex:stub.location + 1];
        info                = [self decodeParams:paramUrl];
        info.urlPath        = [url substringToIndex:stub.location];
    } else {
        info            = [[SSUrlInfo alloc] init];
        info.urlPath    = url;
    }
    info.urlOrigin = url;
    
    NSRange protocolStub = [url rangeOfString:@"://"];
    if (protocolStub.location != NSNotFound) {
        info.protocol = [url substringToIndex:protocolStub.location];
        NSArray* pathComponents = [[url substringFromIndex:protocolStub.location+3] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"?"]];
        info.appPageName = pathComponents[0];
    }
    
    NSMutableString* buffer = [[NSMutableString alloc] init];
    [buffer appendString:info.urlPath];
    if (info.params.count > 0) {
        [buffer appendString:@"?"];
        BOOL first = YES;
        for (NSDictionary *dict in info.paramsArray) {
            for (NSString *key in dict) {
                if (first) {
                    first = NO;
                } else {
                    [buffer appendString:@"&"];
                }
                id value = dict[key];
                [buffer appendFormat:@"%@=%@",[key ssEncodeUrl], [value ssEncodeUrl]];
            }
        }
    }
    info.url = buffer;
    return info;
}

+ (SSUrlInfo *)decodeParams:(NSString*)paramUrl {
    if([paramUrl ssIsEmpty]) {
        return nil;
    }
    
    SSUrlInfo* info = [[SSUrlInfo alloc] init];
    paramUrl        = [paramUrl ssTrim];
    info.urlOrigin  = paramUrl;
    info.url        = paramUrl;
    
    NSArray* components = [paramUrl componentsSeparatedByString:@"&"];
    for (NSString* element in components) {
        NSArray* keyValuePair   =  [element componentsSeparatedByString:@"="];
        if (keyValuePair.count < 2) {
            [info.params setObject:@"" forKey:element];
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"", element, nil];
            [info.paramsArray addObject:dict];
            continue;
        }
        NSString* key           =  [[keyValuePair[0] ssDecodeUrl] ssTrim];
        NSString* value         =  [[keyValuePair[1] ssDecodeUrl] ssTrim];
        if ([key rangeOfString:@"@"].location == 0) {
            [info.frameworkParams setObject:value forKey:[key substringFromIndex:1]];
        } else {
            [info.params setObject:value forKey:key];
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:value, key, nil];
            [info.paramsArray addObject:dict];
        }
    }
    return info;
}

+ (NSString *)encodeParams:(NSDictionary*)param {
    NSMutableString* buffer = [[NSMutableString alloc] init];
    
    BOOL first = YES;
    NSEnumerator* enumerator = [param keyEnumerator];
    id key = nil;
    while ((key = [enumerator nextObject]) != nil) {
        id value = [param objectForKey:key];
        if (first) {
            first = NO;
        } else {
            [buffer appendString:@"&"];
        }
        
        [buffer appendFormat:@"%@=%@", [key ssEncodeUrl], [value ssEncodeUrl]];
    }
    
    return buffer;
}

@end
