//
//  SSPage.h
//  SSNavigator
//
//  Created by ShawnDu on 2016/11/21.
//  Copyright © 2016年 Shawn Du. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSPageLifeCircle.h"
#import "SSPageAware.h"

@interface SSPage : UIViewController<SSPageAware, SSPageLifeCircle>
-(void)forward:(NSString *)url;
-(void)forward:(NSString *)url callback:(void(^)(NSDictionary *dict))callback;
-(void)backward;
-(void)backward:(NSString *)param;
-(void)callback:(NSString *)param;
-(void)pushFlow;
-(void)popFlow:(NSString *)param;
@end
