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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topFirst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondBottom;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdBottom;
@property (weak, nonatomic) IBOutlet UIButton *labelObj;

@property (weak, nonatomic) id<HotCityDelegate> delegate;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *hotCity;

@end
