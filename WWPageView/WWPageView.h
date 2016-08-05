//
//  WWPageView.h
//  WWPageView
//
//  Created by Wade Wang on 2016/4/26.
//  Copyright © 2016年 Wade Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WWPageViewResourceType){
    WWPageViewResourceTypeImageURL,
    WWPageViewResourceTypeImage
};

@class WWPageView;
@protocol WWPageViewDataSource;
@protocol WWPageViewDelegate;

@interface WWPageView : UIView
@property (nonatomic, weak, nullable) id <WWPageViewDataSource> dataSource;
@property (nonatomic, weak, nullable) id <WWPageViewDelegate> delegate;
@property (nonatomic, assign) WWPageViewResourceType resourceType;

@property (nonatomic, strong, nullable) UIImage *defaultImage;
- (void)reloadData;
@end

@protocol WWPageViewDataSource <NSObject>
@required
- (nullable NSArray *)resourceArrayWithWWPageView:(nullable WWPageView *)pageView;
@optional
- (float)carouselIntervalWithWWPageView:(nullable WWPageView *)pageView;
@end

@protocol WWPageViewDelegate <NSObject>
@optional
- (void)pageView:(nullable WWPageView *)pageView didSelectedPageAtIndex:(NSInteger)index;
@end