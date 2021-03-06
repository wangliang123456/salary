//
//  EWSettingViewController.m
//  salary-calc
//
//  Created by Eric Wang on 16/5/24.
//  Copyright © 2016年 Eric Wang. All rights reserved.
//

#import "EWSettingViewController.h"

static const NSUInteger kSettingSectionCount = 1;
static const CGFloat kHeaderViewHieght = 25;

@interface EWSettingViewController ()

@property (weak, nonatomic) IBOutlet DFPBannerView *bannerView;

@end

@implementation EWSettingViewController
{
    UIBarButtonItem* right;
}

#pragma mark load the banner ad
-(void) loadBannerAD {
    self.bannerView.adUnitID = @"ca-app-pub-6212992129754905/8546169709";
    self.bannerView.rootViewController = self;
    GADRequest* request  = [GADRequest request];
    [self.bannerView loadRequest:request];
}

#pragma mark life cycle method
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    [self initView];
    [self loadBannerAD]; 
}

#pragma mark init view
-(void) initView {
    right = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneSetting)];
    right.tintColor = [UIColor colorWithRed:0 green:0.74902 blue:1 alpha:1];
    self.navigationItem.rightBarButtonItem = right;
    self.contentView.delegate = self;
    self.contentView.dataSource = self;
    self.contentView.scrollEnabled = false;
}

#pragma mark done logic
-(void) doneSetting {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark table view data source start
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
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
    contentCell.textLabel.text = @"软件版本";
    contentCell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel* version = [[UILabel alloc] initWithFrame:CGRectZero];
    version.translatesAutoresizingMaskIntoConstraints = false;
    [contentCell.contentView addSubview:version];
    NSLayoutConstraint* versionCenterY = [NSLayoutConstraint constraintWithItem:version attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:contentCell.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    NSLayoutConstraint* versionTrailing = [NSLayoutConstraint constraintWithItem:version attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:contentCell.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-13];
    [contentCell.contentView addConstraints:@[versionCenterY,versionTrailing]];
    NSDictionary* info = [NSBundle mainBundle].infoDictionary;
    version.text = [NSString stringWithFormat:@"v %@",[info valueForKey:@"CFBundleShortVersionString"]];
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
