//
//  SSEvaluateScript.h
//  SSNavigator
//
//  Created by ShawnDu on 2016/12/2.
//  Copyright © 2016年 Shawn Du. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SSEvaluateScript <NSObject>
- (NSString *)evaluateScript:(NSString *)script;
@end
