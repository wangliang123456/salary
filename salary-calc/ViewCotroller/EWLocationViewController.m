//
//  EWLocationViewController.m
//  salary-calc
//
//  Created by Eric Wang on 16/5/24.
//  Copyright © 2016年 Eric Wang. All rights reserved.
//

#import "EWLocationViewController.h"

@interface EWLocationViewController ()

@end

@implementation EWLocationViewController
{
    NSDictionary* cities;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"切换城市";
    [self loadCities];
}

-(void) loadCities {
    cities = [[CityManager sharedInstance] allCities];
    [self.contentView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark table view data source 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (cities.count > 0) {
        return cities.count + 1;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* identifier = @"contentCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = @"dsadsada";
    return cell;
}
@end
