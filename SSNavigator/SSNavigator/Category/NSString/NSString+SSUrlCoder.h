//
//  NSString+SSUrlCoder.h
//  SSNavigator
//
//  Created by ShawnDu on 2016/11/21.
//  Copyright © 2016年 Shawn Du. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SSUrlCoder)

- (NSString *)ssEncodeUrl;
- (NSString *)ssDecodeUrl;
@end
