//
//  EWLocationViewController.h
//  salary-calc
//
//  Created by Eric Wang on 16/5/24.
//  Copyright © 2016年 Eric Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityManager.h"
#import "BaseViewController.h"

@interface EWLocationViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *contentView;

@end
