//
//  CityManager.m
//  salary-calc
//
//  Created by Eric Wang on 16/5/24.
//  Copyright © 2016年 Eric Wang. All rights reserved.
//

#import "CityManager.h"

@implementation CityManager

static CityManager* instance;

+(instancetype) sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [[CityManager alloc] init];
        }
    });
    return instance;
}

-(NSDictionary*) allCities {
    NSBundle* bundle = [NSBundle mainBundle];
    NSString* plistPath = [bundle pathForResource:@"city" ofType:@"plist"];
    NSDictionary* dict = [[NSDictionary alloc]initWithContentsOfFile:plistPath];
    return dict;
}
@end
