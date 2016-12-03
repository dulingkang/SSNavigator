//
//  SSWebPage.h
//  SSNavigator
//
//  Created by ShawnDu on 2016/11/28.
//  Copyright © 2016年 Shawn Du. All rights reserved.
//

#import "SSPage.h"

@interface SSWebPage : SSPage

@property (nonatomic, strong) UIWebView *webView;
/*!
 在loadView里自定义self.view
 */
-(void)loadView;
@end
