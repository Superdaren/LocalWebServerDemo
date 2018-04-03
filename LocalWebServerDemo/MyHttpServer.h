//
//  MyHttpServer.h
//  LocalWebServerDemo
//
//  Created by yg lin on 2018/4/3.
//  Copyright © 2018年 ymtx. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HTTPServer;

@interface MyHttpServer : NSObject

@property (nonatomic, assign) NSUInteger defaultPort;

@property (nonatomic, strong)  HTTPServer *httpServer;

+ (MyHttpServer *)shared;

/**
 *  开启本地Server
 */
- (void)startServer;

/**
 *  关闭本地Server
 */
- (void)stopServer;

@end
