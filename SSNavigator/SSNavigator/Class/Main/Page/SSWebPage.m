//
//  SSWebPage.m
//  SSNavigator
//
//  Created by ShawnDu on 2016/11/28.
//  Copyright © 2016年 Shawn Du. All rights reserved.
//

#import "SSWebPage.h"

@interface SSWebPage ()<UIWebViewDelegate>

@end

@implementation SSWebPage

- (void)loadView {
    self.view = self.webView;
    self.webView.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

@end
