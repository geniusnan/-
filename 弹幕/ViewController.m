//
//  ViewController.m
//  弹幕
//
//  Created by sunroam on 17/2/15.
//  Copyright © 2017年 sunroam. All rights reserved.
//

#import "ViewController.h"
#import "BulletManager.h"
#import "BulletView.h"
@interface ViewController ()
@property (nonatomic ,strong)BulletManager *manager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   UIButton * button =[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame =CGRectMake(100, 140, 175, 40);
    [button setTitle:@"开始弹幕" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(bulletClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    button =[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame =CGRectMake(100, 200, 175, 40);
    [button setTitle:@"关闭弹幕" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(bulletStop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    self.manager =[[BulletManager alloc]init];
    __weak typeof(self)weakSelf =self;
    self.manager.generateViewBlock =^(BulletView *view){
        [weakSelf addBulletView:view];
    };
}
-(void)bulletClick{
    [self.manager start];
}

-(void)bulletStop{
    [self.manager stop];
}

-(void)addBulletView:(BulletView *)view{
    CGFloat width =[UIScreen mainScreen].bounds.size.width;
    view.frame =CGRectMake(width, 300+view.trajectory*50, CGRectGetWidth(view.frame), CGRectGetHeight(view.bounds));
    [self.view addSubview:view];
    [view startAnimation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
