//
//  ViewController.m
//  ArrangeLabelDemo
//
//  Created by Sven Liu on 16/7/19.
//  Copyright © 2016年 Sven Liu. All rights reserved.
//

#import "ViewController.h"
#import "ArrangeLabelManager.h"
#import "ColorSlider.h"

@interface ViewController ()

@property (nonatomic, strong) ArrangeLabelManager *manager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.manager = [[ArrangeLabelManager alloc] init];
    
    [self.manager layoutLabelsWithDataSource:@[@"这是测试", @"这测试", @"这是一个测试", @"试", @"测试", @"这是一个一个", @"测试", @"这个测试", @"测试", @"这是测试", @"这测试", @"这是一个测试", @"试", @"测试",@"这是测试", @"这测试", @"这是一个测试", @"试", @"测试", @"这是一个一个", @"测试", @"这个测试", @"测试", @"这是测试", @"这测试", @"这是一个测试", @"试", @"测试",] superView:self.view];
    
    UIButton *reset = [[UIButton alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height-80, 200, 40)];
    reset.center = CGPointMake(CGRectGetMidX(self.view.frame), reset.center.y);
    [reset setBackgroundColor:[UIColor lightGrayColor]];
    [reset setTitle:@"重置" forState:UIControlStateNormal];
    [reset addTarget:self action:@selector(reloadLabels) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reset];
    
    ColorSlider *slider = [[ColorSlider alloc] initWithFrame:CGRectMake(0, 400, CGRectGetWidth(self.view.frame), 60)];
//    slider.backgroundColor = [UIColor whiteColor];
    NSArray *arr = @[[UIColor redColor], [UIColor blueColor], [UIColor greenColor], [UIColor darkGrayColor]];
    slider.colors = arr;
    slider.numLevels = @[@"哈哈80cm", @"阿斯蒂芬90cm", @"违法100cm"];
    slider.stringLevels = @[@"偏瘦", @"标准", @"偏胖", @"肥胖"];
    slider.sliderValue = 89;
    [self.view addSubview:slider];


}

- (void)reloadLabels {
    
    for (UILabel *lab in self.view.subviews) {
        if ([lab isKindOfClass:[UILabel class]]) {
            [lab removeFromSuperview];
        }
    }
    
    [self.manager layoutLabelsWithDataSource:@[@"这是测试", @"这测试", @"这是一个测试", @"试", @"测试", @"这是一个一个", @"测试", @"这个测试", @"测试", @"这是测试", @"这测试", @"这是一个测试", @"试", @"测试",@"这是测试", @"这测试", @"这是一个测试", @"试", @"测试", @"这是一个一个", @"测试", @"这个测试", @"测试", @"这是测试", @"这测试", @"这是一个测试", @"试", @"测试",] superView:self.view];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
