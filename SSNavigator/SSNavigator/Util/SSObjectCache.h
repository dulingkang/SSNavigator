//
//  SSObjectCache.h
//  SSNavigator
//
//  Created by ShawnDu on 2016/11/22.
//  Copyright © 2016年 Shawn Du. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSObjectCache : NSObject
- (instancetype)initWithCap:(NSInteger)size;
- (void)setObject:(id)value forKey:(NSString *)key;
- (id)objectForKey:(NSString *)key;
- (void)remove:(NSString *)key;
@end
