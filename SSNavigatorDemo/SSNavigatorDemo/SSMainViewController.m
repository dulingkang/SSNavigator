//
//  SSMainViewController.m
//  SSNavigatorDemo
//
//  Created by dulingkang on 2016/12/4.
//  Copyright © 2016年 com.shawn. All rights reserved.
//

#import "SSMainViewController.h"
#import "SSHomePage.h"
#import "SSCartPage.h"
#import "SSCategoryPage.h"
#import "SSMinePage.h"
#import "SSTest1Page.h"

@interface SSMainViewController ()<SSNavigatorDelegate>

@end

@implementation SSMainViewController

#pragma mark - life cycle
+ (SSMainViewController *)sharedInstance {
    static SSMainViewController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SSMainViewController alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        [SSNavigator registAppPage:@"home" pageClass:[SSHomePage class]];
        [SSNavigator registAppPage:@"category" pageClass:[SSCategoryPage class]];
        [SSNavigator registAppPage:@"cart" pageClass:[SSCartPage class]];
        [SSNavigator registAppPage:@"mine" pageClass:[SSMinePage class]];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navigator.view];
    [self.view bringSubviewToFront:self.tabBar];
}

#pragma mark - delegate
- (void)navigatorDidChangedPageTo:(NSString *)url {
    [self.view bringSubviewToFront:self.tabBar];
}

#pragma mark  - getter
- (SSNavigator *)navigator {
    if (!_navigator) {
        _navigator = [SSNavigator sharedInstance];
        _navigator.delegate = self;
    }
    return _navigator;
}
@end
