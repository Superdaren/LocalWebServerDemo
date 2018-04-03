//
//  ViewController.m
//  LocalWebServerDemo
//
//  Created by yg lin on 2018/4/3.
//  Copyright © 2018年 ymtx. All rights reserved.
//


#import "ViewController.h"
#import <WebKit/WebKit.h>
#import "MyHttpServer.h"

@interface ViewController () <WKNavigationDelegate, WKUIDelegate>
{
    WKWebView *_wkWebView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupWebView];
    
    //Start local web server
    [[MyHttpServer shared] startServer];
    
    //Local request which use local resource
        [self loadLocalRequest];
    
    //Remote request which use local resource
//    [self loadRemoteRequest];
    
}

- (void)setupWebView {
    if (!_wkWebView) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        WKUserContentController *controller = [[WKUserContentController alloc] init];
        configuration.userContentController = controller;
        configuration.processPool = [[WKProcessPool alloc] init];
        
        _wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds
                                        configuration:configuration];
        _wkWebView.navigationDelegate = self;
        _wkWebView.UIDelegate = self;
        
        [self.view addSubview:_wkWebView];
    }
}

- (void)loadRemoteRequest {
    if (_wkWebView) {
        [_wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@""]]];
    }
}

- (void)loadLocalRequest {
    if (_wkWebView) {
        [_wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://127.0.0.1:%ld/index.html", [MyHttpServer shared].defaultPort]]]];
    }
}

#pragma mark - WKNavigationDelegate
-                   (void)webView:(WKWebView *)webView
didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
                completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSURLCredential *card = [[NSURLCredential alloc] initWithTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential, card);
    }
}

@end
