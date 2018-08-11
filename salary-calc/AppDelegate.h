//
//  AppDelegate.h
//  salary-calc
//
//  Created by Eric Wang on 16/5/24.
//  Copyright © 2016年 Eric Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GDTSplashAd.h"

static NSString *kGDTMobSDKAppId = @"1105344611";

@interface AppDelegate : UIResponder <UIApplicationDelegate,GDTSplashAdDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) GDTSplashAd *splash;

@end

