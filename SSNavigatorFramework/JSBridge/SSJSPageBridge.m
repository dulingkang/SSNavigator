//
//  SSJSPageBridge.m
//  SSNavigator
//
//  Created by ShawnDu on 2016/12/2.
//  Copyright © 2016年 Shawn Du. All rights reserved.
//

#import "SSJSPageBridge.h"
#import "NSString+SSUrlCoder.h"
#import "SSUrlCoder.h"
#import "SSPage.h"

@implementation SSJSPageBridge

- (NSString*)javascriptObjectName {
    return @"window.pageBridge";
}

- (void)forward:(NSString *)url {
    [self.navigator forward:url callback:^(NSDictionary *param) {
        NSString* str = [SSUrlCoder encodeParams:param];
        [self.jsPage stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"com.dmall.Bridge.appPageCallback(\"%@\")",str]];
    }];
}

- (void)backward:(NSString *)param {
    [self.navigator backward:param];
}

- (void)pushFlow {
    [self.navigator pushFlow];
}

- (void)popFlow:(NSString *)param {
    [self.navigator popFlow:param];
}

- (void)callback:(NSString *)param {
    [self.navigator callback:param];
}

- (void)registRedirect:(NSString*)fromUrl :(NSString *)toUrl {
    [SSNavigator registRedirectFromUrl:fromUrl toUrl:toUrl];
}

- (NSString *)topPage:(int)deep {
    return [((SSPage *)[[SSNavigator sharedInstance] topPage:deep]) pageUrl];
}

@end
