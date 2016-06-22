//
//  EWHotCityCell.m
//  salary-calc
//
//  Created by Eric Wang on 16/5/25.
//  Copyright © 2016年 Eric Wang. All rights reserved.
//

#import "EWHotCityCell.h"

@implementation EWHotCityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self renderView];
}

-(void) renderView {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)hotCitySelected:(id)sender {
    if(self.delegate) {
        [self.delegate hotCityDidSelected:sender];
    }
}

@end
