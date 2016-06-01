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

@interface EWRootViewController : BaseViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *salaryValue;

@end
