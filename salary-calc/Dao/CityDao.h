//
//  CityDao.h
//  salary-calc
//
//  Created by wang liang on 2018/4/22.
//  Copyright © 2018年 Eric Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityDao : NSObject
/*
 单利
 */
+(instancetype) sharedInstance;
//获得所有城市
-(NSDictionary*) allCities;
//货得热门城市
-(NSArray*) hotCities;

@end
