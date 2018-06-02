//
//  InsuranceCinfigViewController.h
//  salary-calc
//
//  Created by wang liang on 2018/5/22.
//  Copyright © 2018年 Eric Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InsuranceConfigCellTableViewCell.h"
#import "BaseViewController.h"

@interface InsuranceCinfigViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *contentView;

@end
