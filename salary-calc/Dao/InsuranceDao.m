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
                    NSString *create = @"CREATE TABLE IF NOT EXISTS Insurance_data(id INTEGER PRIMARY KEY AUTOINCREMENT,endowment_insurance TEXT,medical_insurance TEXT,unemployment_insurance TEXT,maternity_insurance TEXT,employment_injury_insurance TEXT,house_fund TEXT,city_name TEXT UNIQUE)";
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
    NSString *beijing = [NSString stringWithFormat:@"insert into Insurance_data(endowment_insurance,medical_insurance,maternity_insurance,unemployment_insurance,employment_injury_insurance,house_fund,city_name) values('%@','%@','%@','%@','%@','%@','%@')",@"{\"high_base\":23118,\"low_base\":3082,\"personal_rate\":0.08,\"company_rate\":0.19}",@"{\"high_base\":23118,\"low_base\":4624,\"company_rate\":0.1,\"personal_rate\":\"0.02+3\"}",@"{\"high_base\":23118,\"low_base\":3082,\"personal_rate\":0.002,\"company_rate\":0.008}",@"{\"high_base\":23118,\"low_base\":4624,\"personal_rate\":0,\"company_rate\":0.008}",@"{\"high_base\":23118,\"low_base\":4624,\"personal_rate\":0,\"company_rate\":0.002}",@"{\"high_base\":23118,\"low_base\":5548,\"personal_rate\":0.12,\"company_rate\":0.12}",@"北京"];
    [db executeUpdate:beijing];
    
    NSString *shanghai = [NSString stringWithFormat:@"insert into Insurance_data(endowment_insurance,medical_insurance,maternity_insurance,unemployment_insurance,employment_injury_insurance,house_fund,city_name) values('%@','%@','%@','%@','%@','%@','%@')",@"{\"high_base\":19512,\"low_base\":3902,\"personal_rate\":0.08,\"company_rate\":0.20}",@"{\"high_base\":19512,\"low_base\":4624,\"company_rate\":0.095,\"personal_rate\":\"0.02+0\"}",@"{\"high_base\":19512,\"low_base\":3902,\"personal_rate\":0,\"company_rate\":0.001}",@"{\"high_base\":19512,\"low_base\":3902,\"personal_rate\":0.005,\"company_rate\":0.005}",@"{\"high_base\":19512,\"low_base\":3902,\"personal_rate\":0,\"company_rate\":0.005}",@"{\"high_base\":23118,\"low_base\":4600,\"personal_rate\":0.07,\"company_rate\":0.07}",@"上海"];
    [db executeUpdate:shanghai];
    
    NSString *chengdu = [NSString stringWithFormat:@"insert into Insurance_data(endowment_insurance,medical_insurance,maternity_insurance,unemployment_insurance,employment_injury_insurance,house_fund,city_name) values('%@','%@','%@','%@','%@','%@','%@')",@"{\"high_base\":16445,\"low_base\":2193,\"personal_rate\":0.08,\"company_rate\":0.19}",@"{\"high_base\":15333,\"low_base\":3067,\"company_rate\":0.065,\"personal_rate\":\"0.02+0\"}",@"{\"high_base\":15333,\"low_base\":3067,\"personal_rate\":0,\"company_rate\":0.006}",@"{\"high_base\":15333,\"low_base\":3067,\"personal_rate\":0.004,\"company_rate\":0.006}",@"{\"high_base\":15333,\"low_base\":3067,\"personal_rate\":0,\"company_rate\":0.007}",@"{\"high_base\":19321,\"low_base\":1500,\"personal_rate\":0.06,\"company_rate\":0.06}",@"成都"];
    [db executeUpdate:chengdu];
    
    NSString *changsha = [NSString stringWithFormat:@"insert into Insurance_data(endowment_insurance,medical_insurance,maternity_insurance,unemployment_insurance,employment_injury_insurance,house_fund,city_name) values('%@','%@','%@','%@','%@','%@','%@')",@"{\"high_base\":13473,\"low_base\":2695,\"personal_rate\":0.08,\"company_rate\":0.19}",@"{\"high_base\":13473,\"low_base\":2695,\"company_rate\":0.08,\"personal_rate\":\"0.02+0\"}",@"{\"high_base\":13473,\"low_base\":2695,\"personal_rate\":0,\"company_rate\":0.007}",@"{\"high_base\":13473,\"low_base\":2695,\"personal_rate\":0.003,\"company_rate\":0.007}",@"{\"high_base\":13473,\"low_base\":2695,\"personal_rate\":0,\"company_rate\":0.005}",@"{\"high_base\":23340,\"low_base\":1250,\"personal_rate\":0.08,\"company_rate\":0.12}",@"长沙"];
    [db executeUpdate:changsha];
    
    //长春
    NSString *changchun = [NSString stringWithFormat:@"insert into Insurance_data(endowment_insurance,medical_insurance,maternity_insurance,unemployment_insurance,employment_injury_insurance,house_fund,city_name) values('%@','%@','%@','%@','%@','%@','%@')",@"{\"high_base\":14003,\"low_base\":2800.7,\"personal_rate\":0.08,\"company_rate\":0.20}",@"{\"high_base\":14003,\"low_base\":2800.7,\"company_rate\":0.07,\"personal_rate\":\"0.02+0\"}",@"{\"high_base\":14003,\"low_base\":2800.7,\"personal_rate\":0,\"company_rate\":0.007}",@"{\"high_base\":14003,\"low_base\":2800.7,\"personal_rate\":0.005,\"company_rate\":0.015}",@"{\"high_base\":14003,\"low_base\":2800.7,\"personal_rate\":0,\"company_rate\":0.005}",@"{\"high_base\":23335,\"low_base\":1320,\"personal_rate\":0.07,\"company_rate\":0.07}",@"长春"];
    [db executeUpdate:changchun];
    
    //重庆
    NSString *chongqing = [NSString stringWithFormat:@"insert into Insurance_data(endowment_insurance,medical_insurance,maternity_insurance,unemployment_insurance,employment_injury_insurance,house_fund,city_name) values('%@','%@','%@','%@','%@','%@','%@')",@"{\"high_base\":16847,\"low_base\":3370,\"personal_rate\":0.08,\"company_rate\":0.19}",@"{\"high_base\":16847,\"low_base\":3370,\"company_rate\":0.075,\"personal_rate\":\"0.02+0\"}",@"{\"high_base\":16847,\"low_base\":3370,\"personal_rate\":0,\"company_rate\":0.005}",@"{\"high_base\":16847,\"low_base\":3370,\"personal_rate\":0.005,\"company_rate\":0.005}",@"{\"high_base\":16847,\"low_base\":3370,\"personal_rate\":0,\"company_rate\":0.005}",@"{\"high_base\":14214,\"low_base\":1250,\"personal_rate\":0.12,\"company_rate\":0.12}",@"重庆"];
    [db executeUpdate:chongqing];
    
    //大连
    NSString *dalian = [NSString stringWithFormat:@"insert into Insurance_data(endowment_insurance,medical_insurance,maternity_insurance,unemployment_insurance,employment_injury_insurance,house_fund,city_name) values('%@','%@','%@','%@','%@','%@','%@')",@"{\"high_base\":15093,\"low_base\":3181,\"personal_rate\":0.08,\"company_rate\":0.18}",@"{\"high_base\":15093,\"low_base\":3181,\"company_rate\":0.08,\"personal_rate\":\"0.02+0\"}",@"{\"high_base\":15093,\"low_base\":3181,\"personal_rate\":0,\"company_rate\":0.012}",@"{\"high_base\":15093,\"low_base\":3181,\"personal_rate\":0.005,\"company_rate\":0.005}",@"{\"high_base\":15093,\"low_base\":3181,\"personal_rate\":0,\"company_rate\":0.003}",@"{\"high_base\":28913,\"low_base\":1300,\"personal_rate\":0.1,\"company_rate\":0.1}",@"大连"];
    [db executeUpdate:dalian];
    
    //福州
    NSString *fuzhou = [NSString stringWithFormat:@"insert into Insurance_data(endowment_insurance,medical_insurance,maternity_insurance,unemployment_insurance,employment_injury_insurance,house_fund,city_name) values('%@','%@','%@','%@','%@','%@','%@')",@"{\"high_base\":16907.50,\"low_base\":3381.50,\"personal_rate\":0.08,\"company_rate\":0.18}",@"{\"high_base\":16907.50,\"low_base\":3381.50,\"company_rate\":0.08,\"personal_rate\":\"0.02+0\"}",@"{\"high_base\":14709.75,\"low_base\":2914.95,\"personal_rate\":0,\"company_rate\":0.007}",@"{\"high_base\":16907.50,\"low_base\":3381.50,\"personal_rate\":0.005,\"company_rate\":0.015}",@"{\"high_base\":16907.50,\"low_base\":3381.50,\"personal_rate\":0,\"company_rate\":0.003}",@"{\"high_base\":15621,\"low_base\":1350,\"personal_rate\":0.05,\"company_rate\":0.05}",@"福州"];
    [db executeUpdate:fuzhou];
    
    //广州
    NSString *guangzhou = [NSString stringWithFormat:@"insert into Insurance_data(endowment_insurance,medical_insurance,maternity_insurance,unemployment_insurance,employment_injury_insurance,house_fund,city_name) values('%@','%@','%@','%@','%@','%@','%@')",@"{\"high_base\":16575,\"low_base\":2408,\"personal_rate\":0.08,\"company_rate\":0.14}",@"{\"high_base\":20292,\"low_base\":4058,\"company_rate\":0.08,\"personal_rate\":\"0.02+0\"}",@"{\"high_base\":20292,\"low_base\":4058,\"personal_rate\":0,\"company_rate\":0.0085}",@"{\"high_base\":20292,\"low_base\":1895,\"personal_rate\":0.0002,\"company_rate\":0.0064}",@"{\"high_base\":20292,\"low_base\":1895,\"personal_rate\":0,\"company_rate\":0.002}",@"{\"high_base\":37125,\"low_base\":1895,\"personal_rate\":0.12,\"company_rate\":0.12}",@"广州"];
    [db executeUpdate:guangzhou];
    
    //贵阳
    NSString *guiyang = [NSString stringWithFormat:@"insert into Insurance_data(endowment_insurance,medical_insurance,maternity_insurance,unemployment_insurance,employment_injury_insurance,house_fund,city_name) values('%@','%@','%@','%@','%@','%@','%@')",@"{\"high_base\":14388,\"low_base\":2878,\"personal_rate\":0.08,\"company_rate\":0.19}",@"{\"high_base\":14388,\"low_base\":3643,\"company_rate\":0.075,\"personal_rate\":\"0.02+0\"}",@"{\"high_base\":14388,\"low_base\":2878,\"personal_rate\":0,\"company_rate\":0.0005}",@"{\"high_base\":14388,\"low_base\":2878,\"personal_rate\":0.005,\"company_rate\":0.01}",@"{\"high_base\":14388,\"low_base\":2878,\"personal_rate\":0,\"company_rate\":0.009}",@"{\"high_base\":19508,\"low_base\":1600,\"personal_rate\":0.12,\"company_rate\":0.12}",@"贵阳"];
    [db executeUpdate:guiyang];
    
    //杭州
    NSString *hangzhou = [NSString stringWithFormat:@"insert into Insurance_data(endowment_insurance,medical_insurance,maternity_insurance,unemployment_insurance,employment_injury_insurance,house_fund,city_name) values('%@','%@','%@','%@','%@','%@','%@')",@"{\"high_base\":14096.2,\"low_base\":2819.25,\"personal_rate\":0.08,\"company_rate\":0.14}",@"{\"high_base\":14096.2,\"low_base\":2819.25,\"company_rate\":0.115,\"personal_rate\":\"0.02+4\"}",@"{\"high_base\":14096.2,\"low_base\":2819.25,\"personal_rate\":0,\"company_rate\":0.01}",@"{\"high_base\":14096.2,\"low_base\":2819.25,\"personal_rate\":0.005,\"company_rate\":0.005}",@"{\"high_base\":14096.2,\"low_base\":2819.25,\"personal_rate\":0,\"company_rate\":0.003}",@"{\"high_base\":19717,\"low_base\":1860,\"personal_rate\":0.12,\"company_rate\":0.12}",@"杭州"];
    [db executeUpdate:hangzhou];
    
    //海口
    NSString *haikou = [NSString stringWithFormat:@"insert into Insurance_data(endowment_insurance,medical_insurance,maternity_insurance,unemployment_insurance,employment_injury_insurance,house_fund,city_name) values('%@','%@','%@','%@','%@','%@','%@')",@"{\"high_base\":14601,\"low_base\":2920.2,\"personal_rate\":0.08,\"company_rate\":0.2}",@"{\"high_base\":14601,\"low_base\":2920.2,\"company_rate\":0.08,\"personal_rate\":\"0.02+0\"}",@"{\"high_base\":14601,\"low_base\":2920.2,\"personal_rate\":0,\"company_rate\":0.006}",@"{\"high_base\":14601,\"low_base\":2920.2,\"personal_rate\":0.005,\"company_rate\":0.01}",@"{\"high_base\":14601,\"low_base\":2920.2,\"personal_rate\":0,\"company_rate\":0.005}",@"{\"high_base\":14364,\"low_base\":1430,\"personal_rate\":0.05,\"company_rate\":0.05}",@"海口"];
    [db executeUpdate:haikou];
    
    //合肥
    NSString *hefei = [NSString stringWithFormat:@"insert into Insurance_data(endowment_insurance,medical_insurance,maternity_insurance,unemployment_insurance,employment_injury_insurance,house_fund,city_name) values('%@','%@','%@','%@','%@','%@','%@')",@"{\"high_base\":11952,\"low_base\":2620,\"personal_rate\":0.08,\"company_rate\":0.2}",@"{\"high_base\":11952,\"low_base\":2620,\"company_rate\":0.07,\"personal_rate\":\"0.02+0\"}",@"{\"high_base\":11952,\"low_base\":2620,\"personal_rate\":0,\"company_rate\":0.01}",@"{\"high_base\":11952,\"low_base\":2620,\"personal_rate\":0.005,\"company_rate\":0.015}",@"{\"high_base\":11952,\"low_base\":2620,\"personal_rate\":0,\"company_rate\":0.005}",@"{\"high_base\":14426,\"low_base\":1260,\"personal_rate\":0.1,\"company_rate\":0.1}",@"合肥"];
    [db executeUpdate:hefei];
    
    //呼和浩特
    NSString *huhehaote = [NSString stringWithFormat:@"insert into Insurance_data(endowment_insurance,medical_insurance,maternity_insurance,unemployment_insurance,employment_injury_insurance,house_fund,city_name) values('%@','%@','%@','%@','%@','%@','%@')",@"{\"high_base\":14469,\"low_base\":2684.88,\"personal_rate\":0.08,\"company_rate\":0.2}",@"{\"high_base\":14469,\"low_base\":2684.88,\"company_rate\":0.06,\"personal_rate\":\"0.02+0\"}",@"{\"high_base\":14469,\"low_base\":2684.88,\"personal_rate\":0,\"company_rate\":0.007}",@"{\"high_base\":14469,\"low_base\":2684.88,\"personal_rate\":0,\"company_rate\":0.015}",@"{\"high_base\":14469,\"low_base\":2684.88,\"personal_rate\":0,\"company_rate\":0.004}",@"{\"high_base\":14469,\"low_base\":1640,\"personal_rate\":0.11,\"company_rate\":0.11}",@"呼和浩特"];
    [db executeUpdate:huhehaote];
    
    //哈尔滨
    NSString *haerbin = [NSString stringWithFormat:@"insert into Insurance_data(endowment_insurance,medical_insurance,maternity_insurance,unemployment_insurance,employment_injury_insurance,house_fund,city_name) values('%@','%@','%@','%@','%@','%@','%@')",@"{\"high_base\":10675,\"low_base\":2315,\"personal_rate\":0.08,\"company_rate\":0.2}",@"{\"high_base\":12887.8,\"low_base\":4295.92,\"company_rate\":0.075,\"personal_rate\":\"0.02+2.5\"}",@"{\"high_base\":12887.8,\"low_base\":2577.55,\"personal_rate\":0,\"company_rate\":0.006}",@"{\"high_base\":0,\"low_base\":2577.55,\"personal_rate\":0.005,\"company_rate\":0.015}",@"{\"high_base\":12887.8,\"low_base\":2577.55,\"personal_rate\":0,\"company_rate\":0.005}",@"{\"high_base\":12888,\"low_base\":1160,\"personal_rate\":0.08,\"company_rate\":0.08}",@"哈尔滨"];
    [db executeUpdate:haerbin];
    
    //济南
    NSString *jinan = [NSString stringWithFormat:@"insert into Insurance_data(endowment_insurance,medical_insurance,maternity_insurance,unemployment_insurance,employment_injury_insurance,house_fund,city_name) values('%@','%@','%@','%@','%@','%@','%@')",@"{\"high_base\":15999,\"low_base\":3200,\"personal_rate\":0.08,\"company_rate\":0.18}",@"{\"high_base\":15999,\"low_base\":3200,\"company_rate\":0.09,\"personal_rate\":\"0.02+0\"}",@"{\"high_base\":15999,\"low_base\":3200,\"personal_rate\":0,\"company_rate\":0.0085}",@"{\"high_base\":15999,\"low_base\":3200,\"personal_rate\":0.003,\"company_rate\":0.007}",@"{\"high_base\":15999,\"low_base\":3200,\"personal_rate\":0,\"company_rate\":0.002}",@"{\"high_base\":15999,\"low_base\":1810,\"personal_rate\":0.05,\"company_rate\":0.05}",@"济南"];
    [db executeUpdate:jinan];
    
    //昆明
    NSString *kunming = [NSString stringWithFormat:@"insert into Insurance_data(endowment_insurance,medical_insurance,maternity_insurance,unemployment_insurance,employment_injury_insurance,house_fund,city_name) values('%@','%@','%@','%@','%@','%@','%@')",@"{\"high_base\":14603.16,\"low_base\":2390,\"personal_rate\":0.08,\"company_rate\":0.2}",@"{\"high_base\":14603.16,\"low_base\":2390,\"company_rate\":0.09,\"personal_rate\":\"0.02+1\"}",@"{\"high_base\":14603.16,\"low_base\":2390,\"personal_rate\":0,\"company_rate\":0.009}",@"{\"high_base\":14603.16,\"low_base\":2390,\"personal_rate\":0.014,\"company_rate\":0.006}",@"{\"high_base\":14603.16,\"low_base\":2390,\"personal_rate\":0,\"company_rate\":0.009}",@"{\"high_base\":17094,\"low_base\":0,\"personal_rate\":0.12,\"company_rate\":0.12}",@"昆明"];
    [db executeUpdate:kunming];
    
    //兰州
    NSString *lanzhou = [NSString stringWithFormat:@"insert into Insurance_data(endowment_insurance,medical_insurance,maternity_insurance,unemployment_insurance,employment_injury_insurance,house_fund,city_name) values('%@','%@','%@','%@','%@','%@','%@')",@"{\"high_base\":14887.25,\"low_base\":2977.45,\"personal_rate\":0.08,\"company_rate\":0.2}",@"{\"high_base\":14887.25,\"low_base\":2977.45,\"company_rate\":0.06,\"personal_rate\":\"0.02+0\"}",@"{\"high_base\":14887.25,\"low_base\":2977.45,\"personal_rate\":0,\"company_rate\":0.009}",@"{\"high_base\":14887.25,\"low_base\":2977.45,\"personal_rate\":0.007,\"company_rate\":0.003}",@"{\"high_base\":14887.25,\"low_base\":2977.45,\"personal_rate\":0,\"company_rate\":0.009}",@"{\"high_base\":16752.75,\"low_base\":1620,\"personal_rate\":0.09,\"company_rate\":0.12}",@"兰州"];
    [db executeUpdate:lanzhou];
    
    //宁波
    NSString *ningbo = [NSString stringWithFormat:@"insert into Insurance_data(endowment_insurance,medical_insurance,maternity_insurance,unemployment_insurance,employment_injury_insurance,house_fund,city_name) values('%@','%@','%@','%@','%@','%@','%@')",@"{\"high_base\":15335,\"low_base\":3068,\"personal_rate\":0.08,\"company_rate\":0.14}",@"{\"high_base\":15335,\"low_base\":3068,\"company_rate\":0.09,\"personal_rate\":\"0.02+0\"}",@"{\"high_base\":15335,\"low_base\":3068,\"personal_rate\":0,\"company_rate\":0.007}",@"{\"high_base\":15335,\"low_base\":3068,\"personal_rate\":0.005,\"company_rate\":0.005}",@"{\"high_base\":15335,\"low_base\":3068,\"personal_rate\":0,\"company_rate\":0.009}",@"{\"high_base\":28615,\"low_base\":1860,\"personal_rate\":0.05,\"company_rate\":0.05}",@"宁波"];
    [db executeUpdate:ningbo];

    //南昌
    NSString *nanchang = [NSString stringWithFormat:@"insert into Insurance_data(endowment_insurance,medical_insurance,maternity_insurance,unemployment_insurance,employment_injury_insurance,house_fund,city_name) values('%@','%@','%@','%@','%@','%@','%@')",@"{\"high_base\":11556,\"low_base\":2312,\"personal_rate\":0.08,\"company_rate\":0.2}",@"{\"high_base\":12648,\"low_base\":2530,\"company_rate\":0.06,\"personal_rate\":\"0.02+0\"}",@"{\"high_base\":12648,\"low_base\":2530,\"personal_rate\":0,\"company_rate\":0.008}",@"{\"high_base\":11556,\"low_base\":2312,\"personal_rate\":0.005,\"company_rate\":0.015}",@"{\"high_base\":12648,\"low_base\":2530,\"personal_rate\":0,\"company_rate\":0.004}",@"{\"high_base\":16000,\"low_base\":1083,\"personal_rate\":0.12,\"company_rate\":0.12}",@"南昌"];
    [db executeUpdate:nanchang];
    
    //南宁
    NSString *nanning = [NSString stringWithFormat:@"insert into Insurance_data(endowment_insurance,medical_insurance,maternity_insurance,unemployment_insurance,employment_injury_insurance,house_fund,city_name) values('%@','%@','%@','%@','%@','%@','%@')",@"{\"high_base\":11711.4,\"low_base\":2342.3,\"personal_rate\":0.08,\"company_rate\":0.2}",@"{\"high_base\":11711.4,\"low_base\":2342.3,\"company_rate\":0.08,\"personal_rate\":\"0.02+0\"}",@"{\"high_base\":11711.4,\"low_base\":2342.3,\"personal_rate\":0,\"company_rate\":0.008}",@"{\"high_base\":11711.4,\"low_base\":2342.3,\"personal_rate\":0.005,\"company_rate\":0.015}",@"{\"high_base\":11711.4,\"low_base\":2342.3,\"personal_rate\":0,\"company_rate\":0.005}",@"{\"high_base\":13707,\"low_base\":1400,\"personal_rate\":0.12,\"company_rate\":0.12}",@"南宁"];
    [db executeUpdate:nanning];
    
    //南京
    NSString *nanjing = [NSString stringWithFormat:@"insert into Insurance_data(endowment_insurance,medical_insurance,maternity_insurance,unemployment_insurance,employment_injury_insurance,house_fund,city_name) values('%@','%@','%@','%@','%@','%@','%@')",@"{\"high_base\":18171,\"low_base\":2772,\"personal_rate\":0.08,\"company_rate\":0.19}",@"{\"high_base\":18171,\"low_base\":2772,\"company_rate\":0.09,\"personal_rate\":\"0.02+0\"}",@"{\"high_base\":18171,\"low_base\":2772,\"personal_rate\":0,\"company_rate\":0.008}",@"{\"high_base\":18171,\"low_base\":2772,\"personal_rate\":0.005,\"company_rate\":0.005}",@"{\"high_base\":18171,\"low_base\":2772,\"personal_rate\":0,\"company_rate\":0.004}",@"{\"high_base\":22500,\"low_base\":1890,\"personal_rate\":0.08,\"company_rate\":0.08}",@"南京"];
    [db executeUpdate:nanjing];
    
    //青岛
    NSString *qingdao = [NSString stringWithFormat:@"insert into Insurance_data(endowment_insurance,medical_insurance,maternity_insurance,unemployment_insurance,employment_injury_insurance,house_fund,city_name) values('%@','%@','%@','%@','%@','%@','%@')",@"{\"high_base\":13428,\"low_base\":2946,\"personal_rate\":0.08,\"company_rate\":0.18}",@"{\"high_base\":13428,\"low_base\":2946,\"company_rate\":0.088,\"personal_rate\":\"0.02+0\"}",@"{\"high_base\":13428,\"low_base\":2946,\"personal_rate\":0,\"company_rate\":0.015}",@"{\"high_base\":13428,\"low_base\":2946,\"personal_rate\":0.003,\"company_rate\":0.007}",@"{\"high_base\":13428,\"low_base\":2946,\"personal_rate\":0,\"company_rate\":0.002}",@"{\"high_base\":24548.75,\"low_base\":1664.17,\"personal_rate\":0.05,\"company_rate\":0.05}",@"青岛"];
    [db executeUpdate:qingdao];
    
    //深圳
    NSString *shenzhen = [NSString stringWithFormat:@"insert into Insurance_data(endowment_insurance,medical_insurance,maternity_insurance,unemployment_insurance,employment_injury_insurance,house_fund,city_name) values('%@','%@','%@','%@','%@','%@','%@')",@"{\"high_base\":22440,\"low_base\":2130,\"personal_rate\":0.08,\"company_rate\":0.13}",@"{\"high_base\":22440,\"low_base\":2130,\"company_rate\":0.062,\"personal_rate\":\"0.02+0\"}",@"{\"high_base\":22440,\"low_base\":2130,\"personal_rate\":0,\"company_rate\":0.045}",@"{\"high_base\":22440,\"low_base\":2130,\"personal_rate\":0.005,\"company_rate\":0.009}",@"{\"high_base\":22440,\"low_base\":2130,\"personal_rate\":0,\"company_rate\":0.0023}",@"{\"high_base\":37400,\"low_base\":2030,\"personal_rate\":0.05,\"company_rate\":0.05}",@"深圳"];
    [db executeUpdate:shenzhen];
    
    //苏州
    NSString *suzhou = [NSString stringWithFormat:@"insert into Insurance_data(endowment_insurance,medical_insurance,maternity_insurance,unemployment_insurance,employment_injury_insurance,house_fund,city_name) values('%@','%@','%@','%@','%@','%@','%@')",@"{\"high_base\":19613,\"low_base\":2130,\"personal_rate\":0.08,\"company_rate\":0.19}",@"{\"high_base\":19613,\"low_base\":2130,\"company_rate\":0.08,\"personal_rate\":\"0.02+0\"}",@"{\"high_base\":19613,\"low_base\":2130,\"personal_rate\":0,\"company_rate\":0.008}",@"{\"high_base\":19613,\"low_base\":2130,\"personal_rate\":0.005,\"company_rate\":0.005}",@"{\"high_base\":19613,\"low_base\":2130,\"personal_rate\":0,\"company_rate\":0.016}",@"{\"high_base\":20000,\"low_base\":3030,\"personal_rate\":0.1,\"company_rate\":0.1}",@"苏州"];
    [db executeUpdate:suzhou];
    
    //石家庄
    NSString *shijiazhuang = [NSString stringWithFormat:@"insert into Insurance_data(endowment_insurance,medical_insurance,maternity_insurance,unemployment_insurance,employment_injury_insurance,house_fund,city_name) values('%@','%@','%@','%@','%@','%@','%@')",@"{\"high_base\":14246.75,\"low_base\":2849.35,\"personal_rate\":0.08,\"company_rate\":0.2}",@"{\"high_base\":14246.75,\"low_base\":4666.67,\"company_rate\":0.08,\"personal_rate\":\"0.02+0\"}",@"{\"high_base\":14246.75,\"low_base\":4666.67,\"personal_rate\":0,\"company_rate\":0.005}",@"{\"high_base\":14246.75,\"low_base\":3028.3,\"personal_rate\":0.007,\"company_rate\":0.003}",@"{\"high_base\":14246.75,\"low_base\":2849.35,\"personal_rate\":0,\"company_rate\":0.012}",@"{\"high_base\":14246.75,\"low_base\":3308,\"personal_rate\":0.1,\"company_rate\":0.12}",@"石家庄"];
    [db executeUpdate:shijiazhuang];
    
    //沈阳
    NSString *shenyang = [NSString stringWithFormat:@"insert into Insurance_data(endowment_insurance,medical_insurance,maternity_insurance,unemployment_insurance,employment_injury_insurance,house_fund,city_name) values('%@','%@','%@','%@','%@','%@','%@')",@"{\"high_base\":15456.75,\"low_base\":3091.35,\"personal_rate\":0.08,\"company_rate\":0.2}",@"{\"high_base\":14877,\"low_base\":2975,\"company_rate\":0.08,\"personal_rate\":\"0.02+0\"}",@"{\"high_base\":14877,\"low_base\":2975,\"personal_rate\":0,\"company_rate\":0.006}",@"{\"high_base\":15456.75,\"low_base\":3091.35,\"personal_rate\":0.005,\"company_rate\":0.01}",@"{\"high_base\":15456.75,\"low_base\":3091.35,\"personal_rate\":0,\"company_rate\":0.007}",@"{\"high_base\":14246.75,\"low_base\":3308,\"personal_rate\":0.1,\"company_rate\":0.12}",@"沈阳"];
    [db executeUpdate:shenyang];
    
    //天津
    NSString *tianjin = [NSString stringWithFormat:@"insert into Insurance_data(endowment_insurance,medical_insurance,maternity_insurance,unemployment_insurance,employment_injury_insurance,house_fund,city_name) values('%@','%@','%@','%@','%@','%@','%@')",@"{\"high_base\":16821,\"low_base\":3364,\"personal_rate\":0.08,\"company_rate\":0.19}",@"{\"high_base\":16821,\"low_base\":3364,\"company_rate\":0.1,\"personal_rate\":\"0.02+0\"}",@"{\"high_base\":16821,\"low_base\":3364,\"personal_rate\":0,\"company_rate\":0.005}",@"{\"high_base\":16821,\"low_base\":3364,\"personal_rate\":0.005,\"company_rate\":0.005}",@"{\"high_base\":16821,\"low_base\":3364,\"personal_rate\":0,\"company_rate\":0.004}",@"{\"high_base\":16821,\"low_base\":3364,\"personal_rate\":0.11,\"company_rate\":0.11}",@"天津"];
    [db executeUpdate:tianjin];
    
    //太原
    NSString *taiyuan = [NSString stringWithFormat:@"insert into Insurance_data(endowment_insurance,medical_insurance,maternity_insurance,unemployment_insurance,employment_injury_insurance,house_fund,city_name) values('%@','%@','%@','%@','%@','%@','%@')",@"{\"high_base\":15456.75,\"low_base\":3091.35,\"personal_rate\":0.08,\"company_rate\":0.2}",@"{\"high_base\":14877,\"low_base\":2975,\"company_rate\":0.08,\"personal_rate\":\"0.02+0\"}",@"{\"high_base\":14877,\"low_base\":2975,\"personal_rate\":0,\"company_rate\":0.006}",@"{\"high_base\":15456.75,\"low_base\":3091.35,\"personal_rate\":0.005,\"company_rate\":0.01}",@"{\"high_base\":15456.75,\"low_base\":3091.35,\"personal_rate\":0,\"company_rate\":0.007}",@"{\"high_base\":14246.75,\"low_base\":3308,\"personal_rate\":0.1,\"company_rate\":0.12}",@"太原"];
    [db executeUpdate:taiyuan];
    
    //武汉
    NSString *wuhan = [NSString stringWithFormat:@"insert into Insurance_data(endowment_insurance,medical_insurance,maternity_insurance,unemployment_insurance,employment_injury_insurance,house_fund,city_name) values('%@','%@','%@','%@','%@','%@','%@')",@"{\"high_base\":17990.7,\"low_base\":3091.35,\"personal_rate\":0.08,\"company_rate\":0.19}",@"{\"high_base\":17990.7,\"low_base\":3091.35,\"company_rate\":0.08,\"personal_rate\":\"0.02+0\"}",@"{\"high_base\":17990.7,\"low_base\":3091.35,\"personal_rate\":0,\"company_rate\":0.007}",@"{\"high_base\":17990.7,\"low_base\":3091.35,\"personal_rate\":0.003,\"company_rate\":0.007}",@"{\"high_base\":17990.7,\"low_base\":3091.35,\"personal_rate\":0,\"company_rate\":0.0048}",@"{\"high_base\":15156,\"low_base\":1550,\"personal_rate\":0.08,\"company_rate\":0.08}",@"武汉"];
    [db executeUpdate:wuhan];
    
    //西安
    NSString *xian = [NSString stringWithFormat:@"insert into Insurance_data(endowment_insurance,medical_insurance,maternity_insurance,unemployment_insurance,employment_injury_insurance,house_fund,city_name) values('%@','%@','%@','%@','%@','%@','%@')",@"{\"high_base\":15406,\"low_base\":3082,\"personal_rate\":0.08,\"company_rate\":0.19}",@"{\"high_base\":15406,\"low_base\":3082,\"company_rate\":0.07,\"personal_rate\":\"0.02+0\"}",@"{\"high_base\":15406,\"low_base\":3082,\"personal_rate\":0,\"company_rate\":0.0025}",@"{\"high_base\":15406,\"low_base\":3082,\"personal_rate\":0.003,\"company_rate\":0.007}",@"{\"high_base\":15406,\"low_base\":3082,\"personal_rate\":0,\"company_rate\":0.0028}",@"{\"high_base\":17403,\"low_base\":1480,\"personal_rate\":0.1,\"company_rate\":0.1}",@"西安"];
    [db executeUpdate:xian];
    
    //厦门
    NSString *xiamen = [NSString stringWithFormat:@"insert into Insurance_data(endowment_insurance,medical_insurance,maternity_insurance,unemployment_insurance,employment_injury_insurance,house_fund,city_name) values('%@','%@','%@','%@','%@','%@','%@')",@"{\"high_base\":15287.25,\"low_base\":3057.45,\"personal_rate\":0.08,\"company_rate\":0.19}",@"{\"high_base\":15287.25,\"low_base\":3057.45,\"company_rate\":0.08,\"personal_rate\":\"0.02+0\"}",@"{\"high_base\":15287.25,\"low_base\":3057.45,\"personal_rate\":0,\"company_rate\":0.01}",@"{\"high_base\":15287.25,\"low_base\":3057.45,\"personal_rate\":0.003,\"company_rate\":0.007}",@"{\"high_base\":15287.25,\"low_base\":3057.45,\"personal_rate\":0,\"company_rate\":0.004}",@"{\"high_base\":13250,\"low_base\":1600,\"personal_rate\":0.08,\"company_rate\":0.08}",@"厦门"];
    [db executeUpdate:xiamen];
    
    //郑州
    NSString *zhengzhou = [NSString stringWithFormat:@"insert into Insurance_data(endowment_insurance,medical_insurance,maternity_insurance,unemployment_insurance,employment_injury_insurance,house_fund,city_name) values('%@','%@','%@','%@','%@','%@','%@')",@"{\"high_base\":17990.7,\"low_base\":3091.35,\"personal_rate\":0.08,\"company_rate\":0.19}",@"{\"high_base\":17990.7,\"low_base\":3091.35,\"company_rate\":0.08,\"personal_rate\":\"0.02+0\"}",@"{\"high_base\":17990.7,\"low_base\":3091.35,\"personal_rate\":0,\"company_rate\":0.007}",@"{\"high_base\":17990.7,\"low_base\":3091.35,\"personal_rate\":0.003,\"company_rate\":0.007}",@"{\"high_base\":17990.7,\"low_base\":3091.35,\"personal_rate\":0,\"company_rate\":0.0048}",@"{\"high_base\":15156,\"low_base\":1550,\"personal_rate\":0.08,\"company_rate\":0.08}",@"郑州"];
    [db executeUpdate:zhengzhou];
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
    }];
    return insuranceBase;
}

-(InsuranceBase *) queryBaseByCityName:(NSString *) cityName {
    __block InsuranceBase *insuranceBase = nil;
    [instance->databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *query = [@"select * from Insurance_data where city_name = '" stringByAppendingFormat:@"%@'",cityName];
        FMResultSet *rs = [db executeQuery:query];
        while ([rs next]) {
            insuranceBase = [instance buildBase:rs];
        }
    }];
    return insuranceBase;
}
@end
