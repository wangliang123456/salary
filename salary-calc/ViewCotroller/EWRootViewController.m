//
//  EWRootViewController.m
//  salary-calc
//
//  Created by Eric Wang on 16/5/24.
//  Copyright © 2016年 Eric Wang. All rights reserved.
//

#import "EWRootViewController.h"

@interface EWRootViewController ()
{
    UIBarButtonItem* left;
    UIBarButtonItem* right;
}
@end

@implementation EWRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"薪资计算";
    [self initView];
}

-(void) initView {
    left = [[UIBarButtonItem alloc] initWithTitle:@"北京" style:UIBarButtonItemStylePlain target:self action:@selector(changeCity:)];
    right = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(changeSetting:)];
    self.navigationItem.leftBarButtonItem = left;
    self.navigationItem.rightBarButtonItem = right;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    left.title = [userDefault valueForKey:kSelectedCityKey];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark change city
-(void) changeCity:(id) sender {
    [self performSegueWithIdentifier:@"Location" sender:nil];
}

#pragma mark change setting
-(void) changeSetting:(id) sender {
    [self performSegueWithIdentifier:@"Setting" sender:nil];
}
@end
