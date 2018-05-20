//
//  EWRootViewController.h
//  salary-calc
//
//  Created by Eric Wang on 16/5/24.
//  Copyright © 2016年 Eric Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <salary_calc-Swift.h>

@import GoogleMobileAds;
@import Charts;


@interface EWRootViewController : BaseViewController<UITextFieldDelegate,ChartViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *houseSeg;

@property (weak, nonatomic) IBOutlet UITextField *salaryValue;

@end
