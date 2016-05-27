//
//  EWSettingViewController.h
//  salary-calc
//
//  Created by Eric Wang on 16/5/24.
//  Copyright © 2016年 Eric Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@import GoogleMobileAds;

@interface EWSettingViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,GADBannerViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *contentView;

@end
