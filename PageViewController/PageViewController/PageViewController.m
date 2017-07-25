//
//  PageViewController.m
//  PageViewController
//
//  Created by gongguifei on 2017/7/24.
//  Copyright © 2017年 ggf. All rights reserved.
//

#import "PageViewController.h"

@interface PageViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIViewController *previousViewController;
@property (nonatomic, strong) UIViewController *nextViewController;

@property (nonatomic, assign) CGPoint contentOffset;
@end

@implementation PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupScrollView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)setupScrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
        UIViewAutoresizingFlexibleWidth       |
        UIViewAutoresizingFlexibleRightMargin  |
        UIViewAutoresizingFlexibleTopMargin  |
        UIViewAutoresizingFlexibleHeight    |
        UIViewAutoresizingFlexibleBottomMargin ;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_scrollView];
    }
}

- (void)layoutScrollView {
    
    NSInteger sizeCount = 1;
    if (self.previousViewController) {
        sizeCount++;
    }
    if (self.nextViewController) {
        sizeCount++;
    }
    
    [self.scrollView setContentSize:CGSizeMake(CGRectGetWidth(self.scrollView.bounds) * sizeCount, CGRectGetHeight(self.view.bounds))];
    if (sizeCount >= 3) {
        self.viewControllers.firstObject.view.frame = CGRectMake(CGRectGetWidth(self.scrollView.bounds), 0, CGRectGetWidth(self.scrollView.bounds), CGRectGetHeight(self.scrollView.bounds));
    } else {
        self.viewControllers.firstObject.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.scrollView.bounds), CGRectGetHeight(self.scrollView.bounds));
    }
    [self.scrollView setContentOffset:CGPointMake(CGRectGetMinX(self.viewControllers.firstObject.view.frame), 0)];
    
    if (self.previousViewController) {
        self.previousViewController.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.scrollView.bounds), CGRectGetHeight(self.view.bounds));
    }
    if (self.nextViewController) {
        self.nextViewController.view.frame = CGRectMake(CGRectGetMaxX(self.viewControllers[0].view.frame), 0, CGRectGetWidth(self.scrollView.bounds), CGRectGetHeight(self.scrollView.bounds));
    }

}

- (void)scrollToNextPage {
    if (self.nextViewController == nil) {
        return;
    }
    
    if (self.previousViewController) {
        [self.previousViewController.view removeFromSuperview];
        self.previousViewController = nil;
    }
    
    [self.viewControllers.firstObject removeFromParentViewController];
    
    self.previousViewController = self.viewControllers.firstObject;
    _viewControllers = @[self.nextViewController];
    self.nextViewController = [self.dataSource pageViewController:self viewControllerAfterViewController:self.viewControllers.firstObject];
    
    if (self.nextViewController) {
        [self.scrollView addSubview:self.nextViewController.view];
    }
    
    [self layoutScrollView];
    
}

- (void)scrollToPreviousPage {
    if (self.previousViewController == nil) {
        return;
    }
    
    if (self.nextViewController) {
        [self.nextViewController.view removeFromSuperview];
        self.nextViewController = nil;
    }
    
    [self.viewControllers.firstObject removeFromParentViewController];
    
    self.nextViewController = self.viewControllers.firstObject;
    _viewControllers = @[self.previousViewController];
    self.previousViewController = [self.dataSource pageViewController:self viewControllerBeforeViewController:self.viewControllers.firstObject];
    
    if (self.previousViewController) {
        [self.scrollView addSubview:self.previousViewController.view];
    }
    
    [self layoutScrollView];
}


- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers {
    _viewControllers = viewControllers;
    
    NSArray *childViewContollers = self.childViewControllers;
    [childViewContollers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromParentViewController];
    }];
    
    for (UIViewController *viewController in viewControllers) {
        [self addChildViewController:viewController];
    }
    
    self.previousViewController = [self.dataSource pageViewController:self viewControllerBeforeViewController:viewControllers.firstObject];
    self.nextViewController = [self.dataSource pageViewController:self viewControllerAfterViewController:viewControllers.firstObject];
    
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self.scrollView addSubview:viewControllers[0].view];
    if (self.previousViewController) {
        [self.scrollView addSubview:self.previousViewController.view];
    }
    if (self.nextViewController) {
        [self.scrollView addSubview:self.nextViewController.view];
    }
    
    [self layoutScrollView];
}

#pragma mark - UIScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.contentOffset = scrollView.contentOffset;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x - self.contentOffset.x >= CGRectGetWidth(scrollView.bounds) / 2) {
        [self scrollToNextPage];
    } else if (scrollView.contentOffset.x - self.contentOffset.x < -1 *CGRectGetWidth(scrollView.bounds) / 2) {
        [self scrollToPreviousPage];
    }
    
}
@end
