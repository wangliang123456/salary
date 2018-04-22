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

/*
 单利
 */
+(instancetype) sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [[CityDao alloc] init];
            NSString *path = NSHomeDirectory();
            NSString *userName = NSUserName();
            NSString *rootPath = NSHomeDirectoryForUser(userName);
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *docPath = [documentsDirectory stringByAppendingString:@"/salary-calc.db"];
            dataBase = [FMDatabase databaseWithPath:docPath];
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
