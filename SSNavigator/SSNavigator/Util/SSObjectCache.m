//
//  SSObjectCache.m
//  SSNavigator
//
//  Created by ShawnDu on 2016/11/22.
//  Copyright © 2016年 Shawn Du. All rights reserved.
//

#import "SSObjectCache.h"

@interface SSCacheElement : NSObject
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) id value;
@end

@implementation SSCacheElement
@end

@interface SSObjectCache()
@property (strong,nonatomic) NSMutableDictionary *objectDict;
@property (strong,nonatomic) NSMutableArray *objectArray;
@property (nonatomic) NSInteger cap;
@end

@implementation SSObjectCache

#pragma mark - public method
- (instancetype)initWithCap:(NSInteger)size {
    if(self = [super init]) {
        self.cap = size;
    }
    return self;
}

- (void)setObject:(id)value forKey:(NSString*)key {
    // 删除可能重复的数据
    [self remove:key];
    if (self.objectArray.count >= self.cap) {
        [self removeOldeast];
    }
    [self.objectDict setObject:value forKey:key];
    SSCacheElement *element = [SSCacheElement new];
    element.key = key;
    element.value = value;
    [self.objectArray addObject:element];
}

- (id)objectForKey:(NSString*)key {
    return [self.objectDict objectForKey:key];
}

- (void)remove:(NSString *)key {
    [self.objectDict removeObjectForKey:key];
    for (int i = 0 ; i < self.objectArray.count ; i++) {
        SSCacheElement *element = self.objectArray[i];
        if ([key isEqualToString:element.key]) {
            [self.objectArray removeObjectAtIndex:i];
            break;
        }
    }
}

#pragma mark - private method
- (void)removeOldeast {
    if (self.objectArray.count == 0) {
        return;
    }
    SSCacheElement* first = self.objectArray[0];
    [self remove:first.key];
}

#pragma mark - getter
- (NSMutableDictionary *)objectDict {
    if(!_objectDict) {
        _objectDict = [[NSMutableDictionary alloc] init];
    }
    return _objectDict;
}

- (NSMutableArray *)objectArray {
    if (_objectArray == nil) {
        _objectArray = [[NSMutableArray alloc] init];
    }
    return _objectArray;
}
@end
