//
//  EWHotCityCell.h
//  salary-calc
//
//  Created by Eric Wang on 16/5/25.
//  Copyright © 2016年 Eric Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@protocol HotCityDelegate <NSObject>

@required
-(void) hotCityDidSelected:(id) sender;
-(void) reloadData;

@end

@interface EWHotCityCell : UITableViewCell
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *topCollection;
@property (weak, nonatomic) IBOutlet UIButton *labelObj;
@property (strong, nonatomic) NSArray *dataSource;
@property (weak, nonatomic) id<HotCityDelegate> delegate;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btns;


@end
