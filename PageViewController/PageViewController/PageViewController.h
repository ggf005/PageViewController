//
//  PageViewController.h
//  PageViewController
//
//  Created by gongguifei on 2017/7/24.
//  Copyright © 2017年 ggf. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PageViewControllerDataSource;

@interface PageViewController : UIViewController

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray<__kindof UIViewController *> *viewControllers;

@property (nonatomic, weak) id<PageViewControllerDataSource> dataSource;


@end


@protocol PageViewControllerDataSource <NSObject>

- (nullable UIViewController *)pageViewController:(PageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController;
- (nullable UIViewController *)pageViewController:(PageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController;


@end

NS_ASSUME_NONNULL_END
