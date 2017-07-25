//
//  ViewController.m
//  PageViewController
//
//  Created by gongguifei on 2017/7/24.
//  Copyright © 2017年 ggf. All rights reserved.
//

#import "ViewController.h"
#import "PageViewController.h"
#import "DetailViewController.h"

@interface ViewController ()<PageViewControllerDataSource>
@property (nonatomic, strong) PageViewController *pageViewController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    PageViewController *pageViewController = [[PageViewController alloc] init];
    pageViewController.view.frame = self.view.bounds;
    pageViewController.dataSource = self;
    DetailViewController *viewController = [self viewControllerAtIndex:0];
    pageViewController.viewControllers = @[viewController];
    [self.view addSubview:pageViewController.view];
    [self addChildViewController:pageViewController];
    self.pageViewController = pageViewController;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"目录" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    button.frame = CGRectMake(100, 100, 80, 40);
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)clickButton:(UIButton *)button {
    DetailViewController *viewController = [self viewControllerAtIndex:1];
    self.pageViewController.viewControllers = @[viewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (DetailViewController *)viewControllerAtIndex:(NSInteger)index {
    DetailViewController *viewController = [[DetailViewController alloc] init];
    viewController.pageIndex = index;
    
    return viewController;
}

- (nullable UIViewController *)pageViewController:(PageViewController *)pageViewController viewControllerBeforeViewController:(DetailViewController *)viewController {
    if (viewController.pageIndex <= 0) {
        return nil;
    }
    
    return [self viewControllerAtIndex:viewController.pageIndex - 1];
}
- (nullable UIViewController *)pageViewController:(PageViewController *)pageViewController viewControllerAfterViewController:(DetailViewController *)viewController {
    if (viewController.pageIndex >= 100) {
        return nil;
    }
    
    return [self viewControllerAtIndex:viewController.pageIndex + 1];
}
@end
