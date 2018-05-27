//
//  InsuranceConfigCellTableViewCell.h
//  salary-calc
//
//  Created by wang liang on 2018/5/24.
//  Copyright © 2018年 Eric Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InsuranceConfigCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *indexLabel;
@property (weak, nonatomic) IBOutlet UITextField *baseValue;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;

@end
