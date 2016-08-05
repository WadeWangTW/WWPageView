//
//  WWPageChildViewController.m
//  WWPageView
//
//  Created by Wade Wang on 2016/4/27.
//  Copyright © 2016年 Wade Wang. All rights reserved.
//

#import "WWPageChildViewController.h"
#import "WWImageDownloader.h"

@interface WWPageChildViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *pageImageView;
@end

@implementation WWPageChildViewController
@synthesize pageImageView;
@synthesize pageIndex;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(imageViewClicked)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark ChildViewImage
- (void)setChildImageViewWithImage:(UIImage *)image{
    dispatch_async(dispatch_get_main_queue(), ^{
        [pageImageView setImage:image];
    });
}
- (void)setChildImageViewWithURL:(NSURL *)imageURL{
    if (imageURL == nil) {
        return;
    }
    
    [[WWImageDownloader instance] getImageWithURL:imageURL
                                completionHandler:^(UIImage *image, NSError *error){
                                    if (!error) {
                                        [pageImageView setImage:image];
                                    }
                                }];
}
#pragma mark -
#pragma mark Delegate
- (void)imageViewClicked{
    [self.delegate chilViewDidClickedWithIndex:pageIndex];
}
@end
