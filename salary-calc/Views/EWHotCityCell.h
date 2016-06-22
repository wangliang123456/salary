//
//  EWHotCityCell.h
//  salary-calc
//
//  Created by Eric Wang on 16/5/25.
//  Copyright © 2016年 Eric Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HotCityDelegate <NSObject>

@required
-(void) hotCityDidSelected:(id) sender;

@end

@interface EWHotCityCell : UITableViewCell

@property (weak, nonatomic) id<HotCityDelegate> delegate;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *hotCity;

@end
