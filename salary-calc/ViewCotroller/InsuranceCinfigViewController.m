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
    self.contentView.dataSource = self;
    [self.contentView registerNib:[UINib nibWithNibName:@"InsuranceConfigCellTableViewCell" bundle:nil] forCellReuseIdentifier:@"baseCell"];
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

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title = @"";
    if (section == 0) {
        title = @"当前城市";
    } else if (section == 1) {
        title = @"养老保险";
    } else if (section == 2) {
        title = @"医疗保险";
    } else if (section == 3) {
        title = @"失业保险";
    } else if (section == 4) {
        title = @"工伤保险";
    } else if (section == 5) {
        title = @"生育保险";
    } else if (section == 6) {
        title = @"公积金";
    }
    return title;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"baseCell";
    InsuranceConfigCellTableViewCell *configCell = (InsuranceConfigCellTableViewCell *) [tableView dequeueReusableCellWithIdentifier:identifier];
    if (indexPath.section == 0) {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        configCell.indexLabel.text = @"当前城市";
        configCell.baseValue.text = [userDefault valueForKey:kSelectedCityKey];
    }
    return configCell;
}

@end
