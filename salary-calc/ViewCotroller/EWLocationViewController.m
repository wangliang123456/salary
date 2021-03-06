//
//  EWLocationViewController.m
//  salary-calc
//
//  Created by Eric Wang on 16/5/24.
//  Copyright © 2016年 Eric Wang. All rights reserved.
//

#import "EWLocationViewController.h"
#import "City.h"

static const CGFloat kHotCityCellHeight = 130;

@interface EWLocationViewController ()

@end

@implementation EWLocationViewController
{
    NSDictionary* cities;
    NSArray* allKeys;
    UIBarButtonItem* cancel;
    NSArray* hotCities;
    UIBarButtonItem *config;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择城市";
    self.contentView.delegate = self;
    self.contentView.dataSource = self;
    self.contentView.sectionIndexColor = [UIColor colorWithRed:0 green:0.74902 blue:1 alpha:1];
    [self initView];
    [self loadCities];
}

-(void) initView {
    cancel = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    cancel.tintColor = [UIColor colorWithRed:0 green:0.74902 blue:1 alpha:1];
    self.navigationItem.leftBarButtonItem = cancel;
}


-(void) config:(id) sender {
    [self.navigationController performSegueWithIdentifier:@"insuranceConfig" sender:nil];
}

-(void) cancel:(id) sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

-(void) loadCities {
    cities = [[CityManager sharedInstance] allCities];
    allKeys = [cities.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        if ([obj1 isKindOfClass:[NSString class]] && [obj2 isKindOfClass:[NSString class]]) {
            NSString* s1 = (NSString*) obj1;
            NSString* s2 = (NSString*) obj2;
            unichar char1 = [s1 characterAtIndex:0];
            unichar char2 = [s2 characterAtIndex:0];
            if (char1 == char2) {
                return NSOrderedSame;
            } else if (char1 > char2) {
                return NSOrderedDescending;
            } else if (char1 < char2) {
                return NSOrderedAscending;
            }
        }
        return NSOrderedSame;
    }];
    hotCities = [[CityManager sharedInstance] hotCities];
    [self.contentView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark table view data source start
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
    EWHotCityCell* hotCell = nil;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (indexPath.row == 0 && indexPath.section == 0) {
        NSArray* list = [[NSBundle mainBundle] loadNibNamed:@"EWHotCityCell" owner:self options:nil];
        hotCell = list.firstObject;
        hotCell.selectionStyle = UITableViewCellSelectionStyleNone;
        hotCell.delegate = self;
        hotCell.dataSource = hotCities;
        [hotCell renderView];
        return hotCell;
    } else {
        NSString* text = @"";
        NSString* key = [allKeys objectAtIndex:indexPath.section - 1];
        NSArray* values = [cities valueForKey:key];
        City *city = [values objectAtIndex:indexPath.row];
        text = city.cityName;
        cell.textLabel.text = text;
    }
    return cell;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString* headerTitle = @"";
    if (section == 0) {
        headerTitle = @"热门城市";
    } else {
        headerTitle = [allKeys objectAtIndex:section - 1];
    }
    return headerTitle;
}

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray<NSString*>* titles = [NSMutableArray array];
    [titles addObject:@"热门"];
    [titles addObjectsFromArray:allKeys];
    return titles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if ([title isEqualToString:@"热门"]) {
        return 0;
    } else {
        NSInteger i = 0;
        NSInteger titleIndex = 0;
        for (NSString* key in allKeys) {
            if ([key isEqualToString:title]) {
                titleIndex = i;
                break;
            }
            i++;
        }
        return titleIndex;
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return kHotCityCellHeight;
    } else {
        return UITableViewAutomaticDimension;
    }
}
#pragma mark table view datasource end

#pragma mark table view delegate start
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return;
    }
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray* cityArray = [cities valueForKey:[allKeys objectAtIndex:indexPath.section - 1]];
    City *city = [cityArray objectAtIndex:indexPath.row];
    [userDefaults setObject:city.cityName forKey:kSelectedCityKey];
    [userDefaults setObject:city.ID forKey:kSelectedCityId];
    [self dismissViewControllerAnimated:true completion:nil];
    NSNotification *noti = [[NSNotification alloc] initWithName:@"CityHasChange" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:noti];
}

#pragma mark table view delegate end
-(void) hotCityDidSelected:(id) sender {
    UIButton *btn = (UIButton*) sender;
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:btn.titleLabel.text forKey:kSelectedCityKey];
    [self dismissViewControllerAnimated:true completion:nil];
    NSNotification *noti = [[NSNotification alloc] initWithName:@"CityHasChange" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:noti];
}
@end
