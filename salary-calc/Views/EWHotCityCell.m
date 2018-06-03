//
//  EWHotCityCell.m
//  salary-calc
//
//  Created by Eric Wang on 16/5/25.
//  Copyright © 2016年 Eric Wang. All rights reserved.
//

#import "EWHotCityCell.h"
#import "City.h"
#import "EWLocationViewController.h"

@implementation EWHotCityCell

- (void)awakeFromNib {
    [super awakeFromNib];
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
        NSNumber *style = [NSNumber numberWithInt:NSUnderlineStyleSingle];
        NSDictionary *dict = @{NSUnderlineStyleAttributeName:style};
        NSAttributedString *att = [[NSAttributedString alloc] initWithString:city.cityName attributes:dict];
        [btn setAttributedTitle:att forState:UIControlStateNormal];
        [btn setAttributedTitle:att forState:UIControlStateHighlighted];
        [btn.layer setValue:city.ID forKey:kSelectedCityId];
        [btn.layer setValue:city.cityName forKey:kSelectedCityKey];
        index++;
    }
}

- (void) setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void) hotCityDidSelected:(id) sender {
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *) sender;
        NSString *cityName = [btn.layer valueForKey:kSelectedCityKey];
        NSString *cityId = [btn.layer valueForKey:kSelectedCityId];
        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:cityName forKey:kSelectedCityKey];
        [userDefaults setObject:cityId forKey:kSelectedCityId];
    }
    NSNotification *noti = [[NSNotification alloc] initWithName:@"CityHasChange" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:noti];
    UIResponder *responder = self.nextResponder.nextResponder.nextResponder;
    if ([responder isKindOfClass:[EWLocationViewController class]]) {
        EWLocationViewController *coontroller = (EWLocationViewController *)responder;
        [coontroller.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (void) hotCitySelected:(id)sender {
    if(self.delegate) {
        [self.delegate hotCityDidSelected:sender];
    }
}

@end
