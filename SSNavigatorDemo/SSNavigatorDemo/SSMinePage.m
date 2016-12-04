//
//  SSMinePage.m
//  SSNavigatorDemo
//
//  Created by dulingkang on 2016/12/4.
//  Copyright © 2016年 com.shawn. All rights reserved.
//

#import "SSMinePage.h"

@interface SSMinePage ()

@end

@implementation SSMinePage

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addButton];}

- (void)addButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 64, 44, 44);
    [button setTitle:NSStringFromClass([self class]) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)buttonPressed:(UIButton *)button {
    [self.navigator forward:@"app://SSTest1Page"];
}

@end
