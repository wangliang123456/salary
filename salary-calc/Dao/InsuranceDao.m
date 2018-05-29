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
    NSString *beijing = [NSString stringWithFormat:@"insert into Insurance_data(endowment_insurance,medical_insurance,maternity_insurance,unemployment_insurance,employment_injury_insurance,house_fund,city_id) values('%@','%@','%@','%@','%@','%@',%d)",@"{\"high_base\":23118,\"low_base\":3082,\"personal_rate\":0.08,\"company_rate\":0.19}",@"{\"high_base\":23118,\"low_base\":4624,\"company_rate\":0.1,\"personal_rate\":\"0.02+3\"}",@"{\"high_base\":23118,\"low_base\":3082,\"personal_rate\":0.002,\"company_rate\":0.008}",@"{\"high_base\":23118,\"low_base\":4624,\"personal_rate\":0,\"company_rate\":0.008}",@"{\"high_base\":23118,\"low_base\":4624,\"personal_rate\":0,\"company_rate\":0.002}",@"{\"high_base\":23118,\"low_base\":5548,\"personal_rate\":0.12,\"company_rate\":0.12}",1];
    [db executeUpdate:beijing];
    NSString *shanghai = [NSString stringWithFormat:@"insert into Insurance_data(endowment_insurance,medical_insurance,maternity_insurance,unemployment_insurance,employment_injury_insurance,house_fund,city_id) values('%@','%@','%@','%@','%@','%@',%d)",@"{\"high_base\":19512,\"low_base\":3902,\"personal_rate\":0.08,\"company_rate\":0.20}",@"{\"high_base\":19512,\"low_base\":4624,\"company_rate\":0.095,\"personal_rate\":\"0.02+0\"}",@"{\"high_base\":19512,\"low_base\":3902,\"personal_rate\":0,\"company_rate\":0.001}",@"{\"high_base\":19512,\"low_base\":3902,\"personal_rate\":0.005,\"company_rate\":0.005}",@"{\"high_base\":19512,\"low_base\":3902,\"personal_rate\":0,\"company_rate\":0.005}",@"{\"high_base\":23118,\"low_base\":5548,\"personal_rate\":0.07,\"company_rate\":0.07}",2];
    [db executeUpdate:shanghai];
    
    NSString *chengdu = [NSString stringWithFormat:@"insert into Insurance_data(endowment_insurance,medical_insurance,maternity_insurance,unemployment_insurance,employment_injury_insurance,house_fund,city_id) values('%@','%@','%@','%@','%@','%@',%d)",@"{\"high_base\":16445,\"low_base\":2193,\"personal_rate\":0.08,\"company_rate\":0.19}",@"{\"high_base\":15333,\"low_base\":3067,\"company_rate\":0.065,\"personal_rate\":\"0.02+0\"}",@"{\"high_base\":15333,\"low_base\":3067,\"personal_rate\":0,\"company_rate\":0.006}",@"{\"high_base\":15333,\"low_base\":3067,\"personal_rate\":0.004,\"company_rate\":0.006}",@"{\"high_base\":15333,\"low_base\":3067,\"personal_rate\":0,\"company_rate\":0.007}",@"{\"high_base\":19321,\"low_base\":1500,\"personal_rate\":0.06,\"company_rate\":0.06}",5];
    [db executeUpdate:chengdu];
    
    NSString *changsha = [NSString stringWithFormat:@"insert into Insurance_data(endowment_insurance,medical_insurance,maternity_insurance,unemployment_insurance,employment_injury_insurance,house_fund,city_id) values('%@','%@','%@','%@','%@','%@',%d)",@"{\"high_base\":13473,\"low_base\":2695,\"personal_rate\":0.08,\"company_rate\":0.19}",@"{\"high_base\":13473,\"low_base\":2695,\"company_rate\":0.08,\"personal_rate\":\"0.02+0\"}",@"{\"high_base\":13473,\"low_base\":2695,\"personal_rate\":0,\"company_rate\":0.007}",@"{\"high_base\":13473,\"low_base\":2695,\"personal_rate\":0.003,\"company_rate\":0.007}",@"{\"high_base\":13473,\"low_base\":2695,\"personal_rate\":0,\"company_rate\":0.005}",@"{\"high_base\":23340,\"low_base\":1250,\"personal_rate\":0.08,\"company_rate\":0.12}",9];
    [db executeUpdate:changsha];
    //长春
    NSString *changchun = [NSString stringWithFormat:@"insert into Insurance_data(endowment_insurance,medical_insurance,maternity_insurance,unemployment_insurance,employment_injury_insurance,house_fund,city_id) values('%@','%@','%@','%@','%@','%@',%d)",@"{\"high_base\":14003,\"low_base\":2800.7,\"personal_rate\":0.08,\"company_rate\":0.20}",@"{\"high_base\":14003,\"low_base\":2800.7,\"company_rate\":0.07,\"personal_rate\":\"0.02+0\"}",@"{\"high_base\":14003,\"low_base\":2800.7,\"personal_rate\":0,\"company_rate\":0.007}",@"{\"high_base\":14003,\"low_base\":2800.7,\"personal_rate\":0.005,\"company_rate\":0.015}",@"{\"high_base\":14003,\"low_base\":2800.7,\"personal_rate\":0,\"company_rate\":0.005}",@"{\"high_base\":23335,\"low_base\":1320,\"personal_rate\":0.07,\"company_rate\":0.07}",10];
    [db executeUpdate:changchun];
    
    //重庆
    NSString *chongqing = [NSString stringWithFormat:@"insert into Insurance_data(endowment_insurance,medical_insurance,maternity_insurance,unemployment_insurance,employment_injury_insurance,house_fund,city_id) values('%@','%@','%@','%@','%@','%@',%d)",@"{\"high_base\":16847,\"low_base\":3370,\"personal_rate\":0.08,\"company_rate\":0.19}",@"{\"high_base\":16847,\"low_base\":3370,\"company_rate\":0.075,\"personal_rate\":\"0.02+0\"}",@"{\"high_base\":16847,\"low_base\":3370,\"personal_rate\":0,\"company_rate\":0.005}",@"{\"high_base\":16847,\"low_base\":3370,\"personal_rate\":0.005,\"company_rate\":0.005}",@"{\"high_base\":16847,\"low_base\":3370,\"personal_rate\":0,\"company_rate\":0.005}",@"{\"high_base\":14214,\"low_base\":1250,\"personal_rate\":0.12,\"company_rate\":0.12}",11];
    [db executeUpdate:chongqing];
    
    //大连
    NSString *dalian = [NSString stringWithFormat:@"insert into Insurance_data(endowment_insurance,medical_insurance,maternity_insurance,unemployment_insurance,employment_injury_insurance,house_fund,city_id) values('%@','%@','%@','%@','%@','%@',%d)",@"{\"high_base\":15093,\"low_base\":3181,\"personal_rate\":0.08,\"company_rate\":0.18}",@"{\"high_base\":15093,\"low_base\":3181,\"company_rate\":0.08,\"personal_rate\":\"0.02+0\"}",@"{\"high_base\":15093,\"low_base\":3181,\"personal_rate\":0,\"company_rate\":0.012}",@"{\"high_base\":15093,\"low_base\":3181,\"personal_rate\":0.005,\"company_rate\":0.005}",@"{\"high_base\":15093,\"low_base\":3181,\"personal_rate\":0,\"company_rate\":0.003}",@"{\"high_base\":28913,\"low_base\":1300,\"personal_rate\":0.1,\"company_rate\":0.1}",11];
    [db executeUpdate:dalian];
    
    //福州
    NSString *fuzhou = [NSString stringWithFormat:@"insert into Insurance_data(endowment_insurance,medical_insurance,maternity_insurance,unemployment_insurance,employment_injury_insurance,house_fund,city_id) values('%@','%@','%@','%@','%@','%@',%d)",@"{\"high_base\":16907.50,\"low_base\":3381.50,\"personal_rate\":0.08,\"company_rate\":0.18}",@"{\"high_base\":16907.50,\"low_base\":3381.50,\"company_rate\":0.08,\"personal_rate\":\"0.02+0\"}",@"{\"high_base\":14709.75,\"low_base\":2914.95,\"personal_rate\":0,\"company_rate\":0.007}",@"{\"high_base\":16907.50,\"low_base\":3381.50,\"personal_rate\":0.005,\"company_rate\":0.015}",@"{\"high_base\":16907.50,\"low_base\":3381.50,\"personal_rate\":0,\"company_rate\":0.003}",@"{\"high_base\":15621,\"low_base\":1350,\"personal_rate\":0.05,\"company_rate\":0.05}",13];
    [db executeUpdate:fuzhou];
    
    //广州
    NSString *guangzhou = [NSString stringWithFormat:@"insert into Insurance_data(endowment_insurance,medical_insurance,maternity_insurance,unemployment_insurance,employment_injury_insurance,house_fund,city_id) values('%@','%@','%@','%@','%@','%@',%d)",@"{\"high_base\":16575,\"low_base\":2408,\"personal_rate\":0.08,\"company_rate\":0.14}",@"{\"high_base\":20292,\"low_base\":4058,\"company_rate\":0.08,\"personal_rate\":\"0.02+0\"}",@"{\"high_base\":20292,\"low_base\":4058,\"personal_rate\":0,\"company_rate\":0.0085}",@"{\"high_base\":20292,\"low_base\":1895,\"personal_rate\":0.0002,\"company_rate\":0.0064}",@"{\"high_base\":20292,\"low_base\":1895,\"personal_rate\":0,\"company_rate\":0.002}",@"{\"high_base\":37125,\"low_base\":1895,\"personal_rate\":0.12,\"company_rate\":0.12}",3];
    [db executeUpdate:guangzhou];
    
    //贵阳
    NSString *guiyang = [NSString stringWithFormat:@"insert into Insurance_data(endowment_insurance,medical_insurance,maternity_insurance,unemployment_insurance,employment_injury_insurance,house_fund,city_id) values('%@','%@','%@','%@','%@','%@',%d)",@"{\"high_base\":14388,\"low_base\":2878,\"personal_rate\":0.08,\"company_rate\":0.19}",@"{\"high_base\":14388,\"low_base\":3643,\"company_rate\":0.075,\"personal_rate\":\"0.02+0\"}",@"{\"high_base\":14388,\"low_base\":2878,\"personal_rate\":0,\"company_rate\":0.0005}",@"{\"high_base\":14388,\"low_base\":2878,\"personal_rate\":0.005,\"company_rate\":0.01}",@"{\"high_base\":14388,\"low_base\":2878,\"personal_rate\":0,\"company_rate\":0.009}",@"{\"high_base\":19508,\"low_base\":1600,\"personal_rate\":0.12,\"company_rate\":0.12}",14];
    [db executeUpdate:guiyang];
    
    //杭州
    NSString *hangzhou = [NSString stringWithFormat:@"insert into Insurance_data(endowment_insurance,medical_insurance,maternity_insurance,unemployment_insurance,employment_injury_insurance,house_fund,city_id) values('%@','%@','%@','%@','%@','%@',%d)",@"{\"high_base\":14096.2,\"low_base\":2819.25,\"personal_rate\":0.08,\"company_rate\":0.14}",@"{\"high_base\":14096.2,\"low_base\":2819.25,\"company_rate\":0.115,\"personal_rate\":\"0.02+4\"}",@"{\"high_base\":14096.2,\"low_base\":2819.25,\"personal_rate\":0,\"company_rate\":0.01}",@"{\"high_base\":14096.2,\"low_base\":2819.25,\"personal_rate\":0.005,\"company_rate\":0.005}",@"{\"high_base\":14096.2,\"low_base\":2819.25,\"personal_rate\":0,\"company_rate\":0.003}",@"{\"high_base\":19717,\"low_base\":1860,\"personal_rate\":0.12,\"company_rate\":0.12}",14];
    [db executeUpdate:hangzhou];
    
    //海口
    NSString *haikou = [NSString stringWithFormat:@"insert into Insurance_data(endowment_insurance,medical_insurance,maternity_insurance,unemployment_insurance,employment_injury_insurance,house_fund,city_id) values('%@','%@','%@','%@','%@','%@',%d)",@"{\"high_base\":14601,\"low_base\":2920.2,\"personal_rate\":0.08,\"company_rate\":0.2}",@"{\"high_base\":14601,\"low_base\":2920.2,\"company_rate\":0.08,\"personal_rate\":\"0.02+0\"}",@"{\"high_base\":14601,\"low_base\":2920.2,\"personal_rate\":0,\"company_rate\":0.006}",@"{\"high_base\":14601,\"low_base\":2920.2,\"personal_rate\":0.005,\"company_rate\":0.01}",@"{\"high_base\":14601,\"low_base\":2920.2,\"personal_rate\":0,\"company_rate\":0.005}",@"{\"high_base\":14364,\"low_base\":1430,\"personal_rate\":0.05,\"company_rate\":0.05}",15];
    [db executeUpdate:haikou];
    
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
        NSString *query = [@"select * from Insurance_data where city_id = " stringByAppendingFormat:@"%d",cityId];
        FMResultSet *rs = [db executeQuery:query];
        while ([rs next]) {
            insuranceBase = [instance buildBase:rs];
        }
        NSLog(@"");
    }];
    return insuranceBase;
}
@end
