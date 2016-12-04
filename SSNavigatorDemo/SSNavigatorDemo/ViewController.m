//
//  ViewController.m
//  SSNavigatorDemo
//
//  Created by dulingkang on 2016/12/3.
//  Copyright © 2016年 com.shawn. All rights reserved.
//

#import "ViewController.h"
#import "SSTest1Page.h"

@interface ViewController ()

@end

@implementation ViewController

- (instancetype)init {
    if (self = [super init]) {
//        [SSNavigator registAppPage:@"test1" pageClass:[SSTest1Page class]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navigator.view];
    [self addTest1Button];
}

- (void)addTest1Button {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 64, 44, 44);
    [button setTitle:@"test1" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(test1ButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)test1ButtonPressed:(UIButton *)button {
    [self.navigator forward:@"app://SSTest1Page"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (SSNavigator *)navigator {
    if (!_navigator) {
        _navigator = [SSNavigator sharedInstance];
    }
    return _navigator;
}

@end
