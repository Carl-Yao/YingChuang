//
//  ViewController.m
//  YingChuang
//
//  Created by 姚振兴 on 16/1/12.
//  Copyright © 2016年 YZX. All rights reserved.
//

#import "ViewController.h"
#import "DetailTableViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [bg setImage:[UIImage imageNamed:@"mainbg.jpg"]];
    [self.view addSubview:bg];
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(325, 220, 128, 132)];
    [button1 addTarget:self action:@selector(btn1Action) forControlEvents:UIControlEventTouchUpInside];
    button1.backgroundColor = [UIColor redColor];
    [self.view addSubview:button1];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)btn1Action{
    DetailTableViewController * vc = [[DetailTableViewController alloc] init];
    vc.type = 1;
    vc.array = [NSMutableArray arrayWithArray: @[@"yjy1.png",@"yjy2.png",@"yjy3.png",@"yjy4.png", @"易加医是什么.mp4"]];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
