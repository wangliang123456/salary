//
//  EWRootViewController.h
//  salary-calc
//
//  Created by Eric Wang on 16/5/24.
//  Copyright © 2016年 Eric Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@import GoogleMobileAds;
@import Charts;

@interface EWRootViewController : BaseViewController<UITextFieldDelegate,ChartViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *salaryValue;
@property (weak, nonatomic) IBOutlet PieChartView *salaryPieChart;

@end
