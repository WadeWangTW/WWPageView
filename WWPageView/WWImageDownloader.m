//
//  WWImageDownloader.m
//  WWPageView
//
//  Created by Wade Wang on 2016/4/27.
//  Copyright © 2016年 Wade Wang. All rights reserved.
//

#import "WWImageDownloader.h"
@import UIKit;

@implementation WWImageDownloader
+ (instancetype)instance{
    static WWImageDownloader *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WWImageDownloader alloc] init];
    });
    return instance;
}
- (void)getImageWithURL:(NSURL *)url completionHandler:(CompleteImageBlock)handler{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.requestCachePolicy = NSURLRequestReturnCacheDataElseLoad;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil && handler) {
            __strong UIImage *image = [UIImage imageWithData:data];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    handler(image,error);
                });
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSError *error = [NSError errorWithDomain:@"WWPageView"
                                                         code:100
                                                     userInfo:@{@"Error":@"Image not found"}];
                    handler(nil,error);
                });
            }
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(nil,error);
            });
        }
    }];
    [task resume];
}
@end
