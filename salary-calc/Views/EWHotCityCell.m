//
//  EWHotCityCell.m
//  salary-calc
//
//  Created by Eric Wang on 16/5/25.
//  Copyright © 2016年 Eric Wang. All rights reserved.
//

#import "EWHotCityCell.h"
#import "City.h"

@implementation EWHotCityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self renderView];
}

-(void) renderView {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat space = (width - self.labelObj.bounds.size.width * 4 - 64) / 3;
    for (NSLayoutConstraint *con in self.topCollection) {
        con.constant = space;
    }
    NSInteger index = 0;
    for (UIButton *btn in self.btns) {
        [btn addTarget:self action:@selector(hotCityDidSelected:) forControlEvents:UIControlEventTouchUpInside];
        City *city = (City *)[self.dataSource objectAtIndex:index];
        btn.titleLabel.text = city.cityName;
        index++;
    }
}

- (void) setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void) hotCityDidSelected:(id) sender {
    NSLog(@"hotCityDidSelected");
}

- (void) hotCitySelected:(id)sender {
    if(self.delegate) {
        [self.delegate hotCityDidSelected:sender];
    }
}

@end
