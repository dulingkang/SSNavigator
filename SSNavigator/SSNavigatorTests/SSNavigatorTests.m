//
//  SSNavigatorTests.m
//  SSNavigatorTests
//
//  Created by ShawnDu on 2016/11/21.
//  Copyright © 2016年 Shawn Du. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSString+SSUrlCoder.h"
#import "NSString+SSUtil.h"

@interface SSNavigatorTests : XCTestCase

@end

@implementation SSNavigatorTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testUrlCoder {
    NSArray *urlArray = @[@"app://li&我", @"", @"app://test?abc"];
    NSArray *codedArray = @[@"app://li&%E6%88%91", @"", @"app://test?abc"];
    for (NSInteger i = 0; i < urlArray.count; i++) {
        NSLog(@"index:%ld", i);
        NSLog(@"encode:%@", [urlArray[i] ssEncodeUrl]);
        NSLog(@"decode:%@", [codedArray[i] ssDecodeUrl]);
    }
}

- (void)testStringUtil {
    NSArray *stringArray = @[@" appd ", @" ", @"", @"a", @"bdii"];
    for (NSInteger i = 0; i < stringArray.count; i++) {
        NSLog(@"trim:%@", [stringArray[i] ssTrim]);
        NSLog(@"empty:%ld", [stringArray[i] ssIsEmpty]);
        NSLog(@"upper:%@", [stringArray[i] ssFirstToUpper]);
    }
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
