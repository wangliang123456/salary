//
//  InsuranceDao.m
//  salary-calc
//
//  Created by wang liang on 2018/4/29.
//  Copyright © 2018年 Eric Wang. All rights reserved.
//

#import "InsuranceDao.h"


static InsuranceDao *instance;

@implementation InsuranceDao
{
    FMDatabaseQueue *databaseQueue;
}

+(instancetype) sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [[InsuranceDao alloc] init];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *dbPath = [documentsDirectory stringByAppendingString:@"/salary-calc.db"];
            instance->databaseQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
            [instance->databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
                [db beginTransaction];
                NSString *create = @"CREATE TABLE IF NOT EXISTS Insurance_data(id INTEGER PRIMARY KEY AUTOINCREMENT,endowment_insurance TEXT,medical_insurance TEXT,unemployment_insurance TEXT,maternity_insurance TEXT,employment_injury_insurance TEXT,accumulation_fund TEXT,city_id INTEGER)";
                BOOL success = [db executeUpdate:create];
                if (success) {
                    
                }
            }];
        }
    });
    return instance;
}

@end
