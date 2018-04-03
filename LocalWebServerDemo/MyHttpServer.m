//
//  MyHttpServer.m
//  LocalWebServerDemo
//
//  Created by yg lin on 2018/4/3.
//  Copyright © 2018年 ymtx. All rights reserved.
//

#import "MyHttpServer.h"
#import "HTTPServer.h"
#import "MyHttpConnect.h"

@interface MyHttpServer()

@end

@implementation MyHttpServer

+ (MyHttpServer *)shared {
    static id p_instance = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        p_instance = [[self alloc] init];
    });
    return p_instance;
}

- (id)init {
    if (self = [super init]) {
        /* 默认端口号 */
        self.defaultPort = 8000;
    }
    return self;
}

/* 开启服务器 */
- (void)startServer
{
    [self stopServer];
    _httpServer = [[HTTPServer alloc] init];
    [_httpServer setType:@"_http._tcp."];
    [_httpServer setConnectionClass:[MyHttpConnect class]];
    NSString *webPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Resource"];
    [_httpServer setDocumentRoot:webPath];
    [_httpServer setPort:self.defaultPort];
    if (![_httpServer isRunning]) {
        NSError *error;
        if([_httpServer start:&error])
        {
            NSLog(@"start server success in port %d %@", [_httpServer listeningPort], [_httpServer publishedName]);
        }
        else
        {
            NSLog(@"启动失败");
        }
    }
    else {
        NSLog(@"httpServer isRunning");
    }
}

/* 停止本地服务器 */
- (void)stopServer {
    if (self.httpServer) {
        [_httpServer stop];
        _httpServer = nil;
    }
}


@end
