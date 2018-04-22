//
//  CityDao.m
//  salary-calc
//
//  Created by wang liang on 2018/4/22.
//  Copyright © 2018年 Eric Wang. All rights reserved.
//

#import "CityDao.h"
#import "FMDB.h"

static CityDao *instance;

@implementation CityDao
{
    FMDatabaseQueue *databaseQueue;
}

/*
 单利
 */
+(instancetype) sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [[CityDao alloc] init];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *dbPath = [documentsDirectory stringByAppendingString:@"/salary-calc.db"];
            instance->databaseQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
            [instance->databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
                NSString *create = @"create table is not exist City (id INTEGER PRIMARY KEY AUTOINCREMENT, formula TEXT, city_name TEXT, city_initial TEXT，is_hot INTEGER)";
                BOOL isSuccess = [db executeUpdate:create];
                if (isSuccess) {
                    NSLog(@"create City table success");
                } else {
                    NSLog(@"create City table fail");
                }
                
            }];
        }
    });
    return instance;
}

//获得所有城市
-(NSDictionary*) allCities {
    return [[NSDictionary alloc] init];
}

//货得热门城市
-(NSArray*) hotCities {
    return [NSArray array];
}
@end
