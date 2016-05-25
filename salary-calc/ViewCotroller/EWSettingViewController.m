//
//  EWSettingViewController.m
//  salary-calc
//
//  Created by Eric Wang on 16/5/24.
//  Copyright © 2016年 Eric Wang. All rights reserved.
//

#import "EWSettingViewController.h"

@interface EWSettingViewController ()

@end

@implementation EWSettingViewController
{
    UIBarButtonItem* right;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    [self initView];
}

-(void) initView {
    right = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneSetting)];
    self.navigationItem.rightBarButtonItem = right;
}

#pragma mark done logic
-(void) doneSetting {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
