//
//  InsuranceCinfigViewController.m
//  salary-calc
//
//  Created by wang liang on 2018/5/22.
//  Copyright © 2018年 Eric Wang. All rights reserved.
//

#import "InsuranceCinfigViewController.h"

@interface InsuranceCinfigViewController ()

@end

@implementation InsuranceCinfigViewController


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return 4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
