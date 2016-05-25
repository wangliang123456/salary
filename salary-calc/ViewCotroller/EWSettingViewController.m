//
//  EWSettingViewController.m
//  salary-calc
//
//  Created by Eric Wang on 16/5/24.
//  Copyright © 2016年 Eric Wang. All rights reserved.
//

#import "EWSettingViewController.h"

static const NSUInteger kSettingSectionCount = 3;
static const CGFloat kHeaderViewHieght = 25;

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
    self.contentView.delegate = self;
    self.contentView.dataSource = self;
    self.contentView.scrollEnabled = false;
}

#pragma mark done logic
-(void) doneSetting {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark table view data source start
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 2;
    } else {
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return kSettingSectionCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellIdentifer = @"contentCell";
    UITableViewCell* contentCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (!contentCell) {
        contentCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    if (indexPath.section == 0) {
        contentCell.textLabel.text = @"使用说明";
        contentCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
            {
                contentCell.textLabel.text = @"写评论";
                contentCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
                break;
                
            case 1:
            {
                contentCell.textLabel.text = @"意见反馈";
                contentCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
                break;
                
            default:
                break;
        }
    } else {
        contentCell.textLabel.text = @"软件版本";
        UILabel* version = [[UILabel alloc] initWithFrame:CGRectZero];
        version.translatesAutoresizingMaskIntoConstraints = false;
        [contentCell.contentView addSubview:version];
        NSLayoutConstraint* versionCenterY = [NSLayoutConstraint constraintWithItem:version attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:contentCell.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
        NSLayoutConstraint* versionTrailing = [NSLayoutConstraint constraintWithItem:version attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:contentCell.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-13];
        [contentCell.contentView addConstraints:@[versionCenterY,versionTrailing]];
        NSDictionary* info = [NSBundle mainBundle].infoDictionary;
        version.text = [NSString stringWithFormat:@"v %@",[info valueForKey:@"CFBundleShortVersionString"]];
    }
    return contentCell;
}
#pragma mark table view data source end

#pragma mark table view delegate start
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kHeaderViewHieght;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}
#pragma mark table view delegate end
@end
