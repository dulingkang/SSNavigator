//
//  SSWebPage.m
//  SSNavigator
//
//  Created by ShawnDu on 2016/11/28.
//  Copyright © 2016年 Shawn Du. All rights reserved.
//

#import "SSWebPage.h"
#import "SSBridgeHelper.h"
#import "SSJSPageBridge.h"
#import "SSEvaluateScript.h"

@interface SSWebPage ()<UIWebViewDelegate, SSEvaluateScript>
@property (nonatomic, strong) SSJSPageBridge *jsPageBridge;
@end

@implementation SSWebPage

#pragma mark - life cycle
- (void)loadView {
    self.view = self.webView;
    self.webView.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void) pageWillBeShown {
    [super pageWillBeShown];
    [[SSBridgeHelper sharedInstance] registBridge:self.jsPageBridge];
    [[SSBridgeHelper sharedInstance] bindWebView:self.webView];
    NSString *pageUrl = self.pageUrl;
    NSURL *url = nil;
    if ([pageUrl rangeOfString:@"file://"].location == 0) {
        NSString *filePath = [pageUrl substringFromIndex:7];
        NSString *fileFolder = [filePath substringToIndex:
                                (filePath.length-filePath.lastPathComponent.length-1)];
        NSURL *context = [NSURL fileURLWithPath:fileFolder];
        
        [self.webView loadHTMLString:[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil] baseURL:context];
    } else {
        url = [NSURL URLWithString:pageUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url] ;
        [self.webView loadRequest:request];
    }
}

- (void)dealloc {
    [self.webView stopLoading];
    self.webView = nil;
}

#pragma mark - evaluate script protocol
-(NSString*) evaluateScript:(NSString*) script {
    return [self.webView stringByEvaluatingJavaScriptFromString:script];
}

#pragma mark - getter
- (SSJSPageBridge *)jsPageBridge {
    if (!_jsPageBridge) {
        _jsPageBridge = [[SSJSPageBridge alloc] init];
        _jsPageBridge.jsPage = self.webView;
        _jsPageBridge.navigator = self.navigator;
    }
    return _jsPageBridge;
}



- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _webView.backgroundColor = [UIColor greenColor];
    }
    return _webView;
}
@end
