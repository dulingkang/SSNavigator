//
//  SSMainViewController.h
//  SSNavigatorDemo
//
//  Created by dulingkang on 2016/12/4.
//  Copyright © 2016年 com.shawn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SSNavigatorFramework/SSNavigator.h>

@interface SSMainViewController : UIViewController
@property (nonatomic, strong) SSNavigator *navigator;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
+ (SSMainViewController *)sharedInstance;
@end
