//
//  InsuranceConfigCellTableViewCell.m
//  salary-calc
//
//  Created by wang liang on 2018/5/24.
//  Copyright © 2018年 Eric Wang. All rights reserved.
//

#import "InsuranceConfigCellTableViewCell.h"

@implementation InsuranceConfigCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(NSString *) reuseIdentifier {
    return @"baseCell";
}

@end
