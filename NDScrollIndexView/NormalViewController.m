//
//  NormalViewController.m
//  NDScrollIndexView
//
//  Created by NDMAC on 15/12/29.
//  Copyright © 2015年 NDEducation. All rights reserved.
//

#import "NormalViewController.h"

#import "NDIndexListView.h"
@interface NormalViewController ()

@end

@implementation NormalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"正常";
    NDIndexListView *indexListView = [[NDIndexListView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) indexTitleArray:@[@"First",@"Second",@"Third",@"Fourth"] dataSourceArray:@[@[@"1",@"2",@"3",@"4"],@[@"5",@"6",@"7",@"8"],@[@"9",@"10",@"11",@"12"]] load:NO];
    [self.view addSubview:indexListView];
                                      
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
