//
//  WWPageChildViewController.h
//  WWPageView
//
//  Created by Wade Wang on 2016/4/27.
//  Copyright © 2016年 Wade Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WWPageChildViewDelegate <NSObject>
@required
- (void)chilViewDidClickedWithIndex:(NSInteger)index;
@end
@interface WWPageChildViewController : UIViewController
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) UIImage *defaultImage;
@property (nonatomic, weak) id <WWPageChildViewDelegate> delegate;

- (void)setChildImageViewWithImage:(UIImage *)image;
- (void)setChildImageViewWithURL:(NSURL *)imageURL;
@end
