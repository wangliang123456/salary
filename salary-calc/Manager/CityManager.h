//
//  CityManager.h
//  salary-calc
//
//  Created by Eric Wang on 16/5/24.
//  Copyright © 2016年 Eric Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CityDao.h"

@interface CityManager : NSObject

@property(strong, nonatomic) CityDao *cityDao;

+(instancetype) sharedInstance;
-(NSDictionary*) allCities;
-(NSArray*) hotCities;

@end
