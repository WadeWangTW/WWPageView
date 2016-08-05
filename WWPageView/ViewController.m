//
//  ViewController.m
//  WWPageView
//
//  Created by Wade Wang on 2016/4/26.
//  Copyright © 2016年 Wade Wang. All rights reserved.
//

#import "ViewController.h"
#import "WWPageView.h"

#define ARC4RANDOM_MAX      0x100000000

@interface ViewController () <WWPageViewDataSource,WWPageViewDelegate>
@property (weak, nonatomic) IBOutlet WWPageView *advertisementView;
@property (nonatomic, strong) NSMutableArray *imageArray;

@end

@implementation ViewController
@synthesize advertisementView;
@synthesize imageArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    imageArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 5; i++) {
        [imageArray addObject:[self imageFromColor]];
    }
    advertisementView.resourceType = WWPageViewResourceTypeImage;
    
    advertisementView.dataSource = self;
    advertisementView.delegate = self;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark Just For Test
- (UIImage *)imageFromColor
{
    double red = floorf(((double)arc4random() / ARC4RANDOM_MAX) * 255.f) / 255.f;
    double green = floorf(((double)arc4random() / ARC4RANDOM_MAX) * 255.f) / 255.f;
    double blue = floorf(((double)arc4random() / ARC4RANDOM_MAX) * 255.f) / 255.f;
    
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.f];
    CGRect rect = CGRectMake(0, 0, CGRectGetWidth(advertisementView.frame), CGRectGetHeight(advertisementView.frame));
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
#pragma mark -
#pragma mark WWPageViewDataSource
- (NSArray *)resourceArrayWithWWPageView:(WWPageView *)pageView{
    return imageArray;
}
- (float)carouselIntervalWithWWPageView:(WWPageView *)pageView{
    return 2.f;
}
#pragma mark -
#pragma mark WWPageViewDelegate
- (void)pageView:(nullable WWPageView *)pageView didSelectedPageAtIndex:(NSInteger)index{
    NSLog(@"Click : %li",(long)index);
}
@end
