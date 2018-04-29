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
                @try {
                    [db beginTransaction];
                    NSString *create = @"CREATE TABLE IF NOT EXISTS Insurance_data(id INTEGER PRIMARY KEY AUTOINCREMENT,endowment_insurance TEXT,medical_insurance TEXT,unemployment_insurance TEXT,maternity_insurance TEXT,employment_injury_insurance TEXT,house_fund TEXT,city_id INTEGER UNIQUE)";
                    BOOL success = [db executeUpdate:create];
                    if (success) {
                        [instance initInsuranceData:db];
                    }
                    [db commit];
                } @catch (NSException *exception) {
                    NSLog(@"insert insurance data fail");
                    [db rollback];
                }
            }];
        }
    });
    return instance;
}

-(void) initInsuranceData:(FMDatabase *) db {
    NSString *insert = @"insert into Insurance_data(endowment_insurance,medical_insurance,unemployment_insurance,maternity_insurance,employment_injury_insurance,house_fund,city_id) values(\"{'high_base':23118,'low_base':3082,'personal_rate':0.2,'company_rate':0.08}\",\"{'high_base':23118,'low_base':4624,'personal_rate':0.1,'company_rate':0.02+3}\",\"{'high_base':23118,'low_base':3082,'personal_rate':0.008,'company_rate':0.002}\",\"{'high_base':23118,'low_base':4624,'personal_rate':0.008,'company_rate':0}\",\"{'high_base':23118,'low_base':4624,'personal_rate':0.005,'company_rate':0}\",\"{'high_base':23118,'low_base':5548,'personal_rate'0.12,'company_rate':0.12}\",1)";
    [db executeUpdate:insert];
}

-(InsuranceBase *) buildBase:(FMResultSet *) rs {
    InsuranceBase *insuranceBase = [[InsuranceBase alloc] init];
    insuranceBase.endowmentInsurance = [rs stringForColumn:@"endowment_insurance"];
    insuranceBase.medicalInsurance = [rs stringForColumn:@"medical_insurance"];
    insuranceBase.unemploymentInsurance = [rs stringForColumn:@"unemployment_insurance"];
    insuranceBase.maternityInsurance = [rs stringForColumn:@"maternity_insurance"];
    insuranceBase.employmentInjuryInsurance = [rs stringForColumn:@"employment_injury_insurance"];
    insuranceBase.houseFund = [rs stringForColumn:@"house_fund"];
    return insuranceBase;
}

-(InsuranceBase *) queryBaseByCityId:(int) cityId {
    __block InsuranceBase *insuranceBase = nil;
    [instance->databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *query = @"select * from Insurance_data where city_id = ?";
        FMResultSet *rs = [db executeQuery:query,cityId];
        while ([rs next]) {
            insuranceBase = [instance buildBase:rs];
        }
    }];
    return insuranceBase;
}
@end
