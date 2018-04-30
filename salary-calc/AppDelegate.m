//
//  AppDelegate.m
//  salary-calc
//
//  Created by Eric Wang on 16/5/24.
//  Copyright © 2016年 Eric Wang. All rights reserved.
//

#import "AppDelegate.h"
#import "CityDao.h"
#import "InsuranceDao.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    dispatch_queue_t concurrentQueue =
    dispatch_queue_create("initBaseDataQueue",
                          DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^{
        [CityDao sharedInstance];
        [InsuranceDao sharedInstance];
    });
    return true;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

@end
