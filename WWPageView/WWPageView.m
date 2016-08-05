//
//  WWPageView.m
//  WWPageView
//
//  Created by Wade Wang on 2016/4/26.
//  Copyright © 2016年 Wade Wang. All rights reserved.
//

#import "WWPageView.h"
#import "WWPageChildViewController.h"

@interface WWPageView () <UIPageViewControllerDataSource,UIPageViewControllerDelegate,WWPageChildViewDelegate>

@property (nonatomic, strong) NSMutableArray *pageViewDataArray;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSTimer *pageViewCarouselTimer;
@property (nonatomic, assign) float carouselInterval;

@end

@implementation WWPageView
@synthesize pageViewDataArray;
@synthesize pageControl;
@synthesize carouselInterval;
@synthesize defaultImage;
@synthesize resourceType;

#pragma mark -
#pragma mark Life Cycle
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initSelf];
    }
    return self;
}
- (id)init{
    self = [super init];
    if (self) {
        [self initSelf];
    }
    return self;
}
- (void)removeFromSuperview{
    [super removeFromSuperview];
    [self.pageViewCarouselTimer invalidate];
    self.pageViewCarouselTimer = nil;
    
}
#pragma mark -
#pragma mark PageView Method
- (void)initSelf{
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:nil];
    UIView *pageView = self.pageViewController.view;
    [self addSubview:pageView];
 
    pageView.translatesAutoresizingMaskIntoConstraints = false;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[pageView]|"
                                                                 options:NSLayoutFormatDirectionLeftToRight
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(pageView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[pageView]|"
                                                                 options:NSLayoutFormatDirectionLeftToRight
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(pageView)]];
    
    pageControl = [[UIPageControl alloc] init];
    [self addSubview:pageControl];
    pageControl.hidden = true;
    pageControl.translatesAutoresizingMaskIntoConstraints = false;
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[pageControl(20)]|"
                                                                 options:NSLayoutFormatDirectionLeftToRight
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(pageControl)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[pageControl]|"
                                                                 options:NSLayoutFormatDirectionLeftToRight
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(pageControl)]];
}
- (WWPageChildViewController *)childViewControllerWithIndex:(NSInteger)pageIndex{
    WWPageChildViewController *PCVC = [[WWPageChildViewController alloc] initWithNibName:@"WWPageChildViewController" bundle:nil];
    PCVC.delegate = self;
    [PCVC setPageIndex:pageIndex];
    
    if (resourceType == WWPageViewResourceTypeImage) {
        [PCVC setChildImageViewWithImage:pageViewDataArray[pageIndex]];
    }else{
        [PCVC setChildImageViewWithURL:[NSURL URLWithString:pageViewDataArray[pageIndex]]];
    }
    
    if (defaultImage) {
        [PCVC setDefaultImage:defaultImage];
    }
    return PCVC;
}
- (void)carouselEvent{
    WWPageChildViewController *currentVC = self.pageViewController.viewControllers.firstObject;
    NSInteger pageIndex = (currentVC.pageIndex + 1) % pageViewDataArray.count;
    WWPageChildViewController *childView = [self childViewControllerWithIndex:pageIndex];
    [self.pageViewController setViewControllers:@[childView]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:true
                                     completion:nil];
    self.pageControl.currentPage = pageIndex;
}
#pragma mark -
#pragma mark DataSource
- (void)setDataSource:(id<WWPageViewDataSource>)dataSource{
    _dataSource = dataSource;
    pageViewDataArray = [[NSMutableArray alloc] initWithArray:[self.dataSource resourceArrayWithWWPageView:self]];
    
    if (pageViewDataArray.count > 0) {
        pageControl.numberOfPages = pageViewDataArray.count;
        pageControl.currentPage = 0;
        pageControl.hidden = false;
        
        WWPageChildViewController *childView = [self childViewControllerWithIndex:0];
        self.pageViewController.dataSource = self;
        self.pageViewController.delegate = self;
        
        [self.pageViewController setViewControllers:@[childView]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:false
                                         completion:nil];
        
    }
    
    if ([self.dataSource respondsToSelector:@selector(carouselIntervalWithWWPageView:)]) {
        carouselInterval = [self.dataSource carouselIntervalWithWWPageView:self]
        ;
        self.pageViewCarouselTimer = [NSTimer scheduledTimerWithTimeInterval:carouselInterval
                                                                      target:self
                                                                    selector:@selector(carouselEvent)
                                                                    userInfo:nil
                                                                     repeats:true];
    }
}
- (void)reloadData{
    if ([self.pageViewCarouselTimer isValid]) {
        [self.pageViewCarouselTimer invalidate];
    }
    
    pageViewDataArray = [[NSMutableArray alloc] initWithArray:[self.dataSource resourceArrayWithWWPageView:self]];
    
    if (pageViewDataArray.count > 0) {
        pageControl.numberOfPages = pageViewDataArray.count;
        pageControl.currentPage = 0;
        pageControl.hidden = false;
        
        WWPageChildViewController *childView = [self childViewControllerWithIndex:0];

        [self.pageViewController setViewControllers:@[childView]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:false
                                         completion:nil];
        
    }
    
    if ([self.dataSource respondsToSelector:@selector(carouselIntervalWithWWPageView:)]) {
        carouselInterval = [self.dataSource carouselIntervalWithWWPageView:self]
        ;
        if (carouselInterval != 0 && !self.pageViewCarouselTimer.isValid) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.pageViewCarouselTimer = [NSTimer scheduledTimerWithTimeInterval:carouselInterval
                                                                              target:self
                                                                            selector:@selector(carouselEvent)
                                                                            userInfo:nil
                                                                             repeats:true];
            });
        }
    }
}
#pragma mark -
#pragma mark Delegate
- (void)chilViewDidClickedWithIndex:(NSInteger)index{
    if ([self.delegate respondsToSelector:@selector(pageView:didSelectedPageAtIndex:)]) {
        [self.delegate pageView:self didSelectedPageAtIndex:index];
    }
}
#pragma mark -
#pragma mark UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(WWPageChildViewController *)viewController{
    if (pageViewDataArray.count <= 1) {
        return nil;
    }
    else if ([self.pageViewCarouselTimer isValid]) {
        [self.pageViewCarouselTimer invalidate];
    }
    
    NSInteger pageIndex = viewController.pageIndex - 1;
    if (pageIndex == -1) {
        pageIndex = self.pageViewDataArray.count -1;
    }
    WWPageChildViewController *PCVC = [self childViewControllerWithIndex:pageIndex];
    return PCVC;
    
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(WWPageChildViewController *)viewController{
    if (pageViewDataArray.count <= 1) {
        return nil;
    }
    else if ([self.pageViewCarouselTimer isValid]) {
        [self.pageViewCarouselTimer invalidate];
    }
    
    NSInteger pageIndex = viewController.pageIndex + 1;
    if (pageIndex == self.pageViewDataArray.count) {
        pageIndex = 0;
    }
    WWPageChildViewController *PCVC = [self childViewControllerWithIndex:pageIndex];
    return PCVC;
}
- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray<WWPageChildViewController *> *)previousViewControllers
       transitionCompleted:(BOOL)completed {
    
    WWPageChildViewController *PCVC = pageViewController.viewControllers.firstObject;
    self.pageControl.currentPage = PCVC.pageIndex;
    if (carouselInterval != 0 && !self.pageViewCarouselTimer.isValid) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.pageViewCarouselTimer = [NSTimer scheduledTimerWithTimeInterval:carouselInterval
                                                                          target:self
                                                                        selector:@selector(carouselEvent)
                                                                        userInfo:nil
                                                                         repeats:true];
        });
    }
}
@end
