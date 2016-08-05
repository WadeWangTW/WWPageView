//
//  WWImageDownloader.h
//  WWPageView
//
//  Created by Wade Wang on 2016/4/27.
//  Copyright © 2016年 Wade Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage;
typedef void(^CompleteImageBlock)(UIImage *image, NSError *error);

@interface WWImageDownloader : NSObject
+ (instancetype)instance;
- (void)getImageWithURL:(NSURL *)url completionHandler:(CompleteImageBlock)handler;
@end
