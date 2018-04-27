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
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat space = (width - self.labelObj.bounds.size.width * 4 - 64) / 3;
    self.topFirst.constant = space;
    self.secondTop.constant = space;
    self.thirdTop.constant = space;
    self.firstBottom.constant = space;
    self.secondBottom.constant = space;
    self.thirdBottom.constant = space;
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
