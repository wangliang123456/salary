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
    NSArray* allKeys;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"切换城市";
    self.contentView.delegate = self;
    self.contentView.dataSource = self;
    [self loadCities];
}

-(void) loadCities {
    cities = [[CityManager sharedInstance] allCities];
    allKeys = cities.allKeys;
    [self.contentView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark table view data source 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        NSString* key = [allKeys objectAtIndex:section - 1];
        NSArray* values = [cities valueForKey:key];
        if (values.count > 0) {
            return values.count;
        }
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (allKeys.count > 0) {
        return allKeys.count + 1;
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
    if (indexPath.row == 0 && indexPath.section == 0) {
        cell.textLabel.text = @"热门城市";
    } else {
        NSString* text = @"";
        NSString* key = [allKeys objectAtIndex:indexPath.section - 1];
        NSArray* values = [cities valueForKey:key];
        text = [values objectAtIndex:indexPath.row];
        cell.textLabel.text = text;
    }
    return cell;
}
@end
