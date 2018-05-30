//
//  CityDao.m
//  salary-calc
//
//  Created by wang liang on 2018/4/22.
//  Copyright © 2018年 Eric Wang. All rights reserved.
//

#import "CityDao.h"
#import "FMDB.h"
#import "City.h"

static CityDao *instance;

static const NSString *kCityName = @"city_name";

static const NSString *kCitynInitial = @"city_initial";

static const NSString *kIsHot = @"is_hot";

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
                @try {
                    [db beginTransaction];
                    NSString *createCityTable = @"CREATE TABLE IF NOT EXISTS City (id INTEGER PRIMARY KEY AUTOINCREMENT, formula TEXT, city_name TEXT UNIQUE, city_initial TEXT, is_hot INTEGER)";
                    BOOL isSuccess = [db executeUpdate:createCityTable];
                    if (isSuccess) {
                        [instance initCityData:db];
                    } else {
                        NSLog(@"create City table fail");
                    }
                    [db commit];
                } @catch (NSException *exception) {
                    [db rollback];
                } @finally {
                    
                }
                
            }];
        }
    });
    return instance;
}

-(void) initCityData:(FMDatabase *) db {
    [db executeUpdate:@"insert into City(city_name, city_initial, is_hot, formula) values(\"北京\",\"B\", 1, \"dadsadsada\")"];
    [db executeUpdate:@"insert into City(city_name, city_initial, is_hot, formula) values(\"上海\",\"S\", 1, \"dadsadsada\")"];
    [db executeUpdate:@"insert into City(city_name, city_initial, is_hot, formula) values(\"广州\",\"G\", 1, \"dadsadsada\")"];
    [db executeUpdate:@"insert into City(city_name, city_initial, is_hot, formula) values(\"深圳\",\"S\", 1, \"dadsadsada\")"];
    [db executeUpdate:@"insert into City(city_name, city_initial, is_hot, formula) values(\"成都\",\"C\", 1, \"dadsadsada\")"];
    [db executeUpdate:@"insert into City(city_name, city_initial, is_hot, formula) values(\"武汉\",\"W\", 1, \"dadsadsada\")"];
    [db executeUpdate:@"insert into City(city_name, city_initial, is_hot, formula) values(\"杭州\",\"H\", 1, \"dadsadsada\")"];
    [db executeUpdate:@"insert into City(city_name, city_initial, is_hot, formula) values(\"苏州\",\"S\", 1, \"dadsadsada\")"];
    [db executeUpdate:@"insert into City(city_name, city_initial, is_hot, formula) values(\"长沙\",\"C\", 0, \"dadsadsada\")"];
    [db executeUpdate:@"insert into City(city_name, city_initial, is_hot, formula) values(\"长春\",\"C\", 0, \"dadsadsada\")"];
    [db executeUpdate:@"insert into City(city_name, city_initial, is_hot, formula) values(\"重庆\",\"C\", 0, \"dadsadsada\")"];
    [db executeUpdate:@"insert into City(city_name, city_initial, is_hot, formula) values(\"大连\",\"D\", 0, \"dadsadsada\")"];
    [db executeUpdate:@"insert into City(city_name, city_initial, is_hot, formula) values(\"福州\",\"F\", 0, \"dadsadsada\")"];
    [db executeUpdate:@"insert into City(city_name, city_initial, is_hot, formula) values(\"贵阳\",\"G\", 0, \"dadsadsada\")"];
    [db executeUpdate:@"insert into City(city_name, city_initial, is_hot, formula) values(\"海口\",\"H\", 0, \"dadsadsada\")"];
    [db executeUpdate:@"insert into City(city_name, city_initial, is_hot, formula) values(\"合肥\",\"H\", 0, \"dadsadsada\")"];
    [db executeUpdate:@"insert into City(city_name, city_initial, is_hot, formula) values(\"呼和浩特\",\"H\", 0, \"dadsadsada\");"];
    [db executeUpdate:@"insert into City(city_name, city_initial, is_hot, formula) values(\"哈尔滨\",\"H\", 0, \"dadsadsada\")"];
    [db executeUpdate:@"insert into City(city_name, city_initial, is_hot, formula) values(\"济南\",\"J\", 0, \"dadsadsada\")"];
    [db executeUpdate:@"insert into City(city_name, city_initial, is_hot, formula) values(\"昆明\",\"K\", 0, \"dadsadsada\")"];
    [db executeUpdate:@"insert into City(city_name, city_initial, is_hot, formula) values(\"兰州\",\"L\", 0, \"dadsadsada\")"];
    [db executeUpdate:@"insert into City(city_name, city_initial, is_hot, formula) values(\"宁波\",\"N\", 0, \"dadsadsada\")"];
    [db executeUpdate:@"insert into City(city_name, city_initial, is_hot, formula) values(\"南昌\",\"N\", 0, \"dadsadsada\")"];
    [db executeUpdate:@"insert into City(city_name, city_initial, is_hot, formula) values(\"南宁\",\"N\", 0, \"dadsadsada\")"];
    [db executeUpdate:@"insert into City(city_name, city_initial, is_hot, formula) values(\"南京\",\"N\", 0, \"dadsadsada\")"];
    [db executeUpdate:@"insert into City(city_name, city_initial, is_hot, formula) values(\"青岛\",\"Q\", 0, \"dadsadsada\")"];
    [db executeUpdate:@"insert into City(city_name, city_initial, is_hot, formula) values(\"石家庄\",\"S\", 0, \"dadsadsada\");"];
    [db executeUpdate:@"insert into City(city_name, city_initial, is_hot, formula) values(\"沈阳\",\"S\", 0, \"dadsadsada\")"];
    [db executeUpdate:@"insert into City(city_name, city_initial, is_hot, formula) values(\"太原\",\"T\", 0, \"dadsadsada\")"];
    [db executeUpdate:@"insert into City(city_name, city_initial, is_hot, formula) values(\"天津\",\"T\", 0, \"dadsadsada\")"];
    [db executeUpdate:@"insert into  City(city_name, city_initial, is_hot, formula) values(\"西安\",\"X\", 0, \"dadsadsada\")"];
    [db executeUpdate:@"insert into City(city_name, city_initial, is_hot, formula) values(\"厦门\",\"X\", 0, \"dadsadsada\")"];
    [db executeUpdate:@"insert into City(city_name, city_initial, is_hot, formula) values(\"郑州\",\"Z\", 0, \"dadsadsada\")"];
}

//获得所有城市
-(NSDictionary*) allCities {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [self->databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *sql = @"SELECT * FROM City ORDER BY city_initial ASC";
        FMResultSet *resultSet = [db executeQuery:sql];
        NSMutableArray *array = nil;
        while ([resultSet next]) {
            City *city = [self getCity:resultSet];
            NSString *cityInitial = [resultSet stringForColumn:@"city_initial"];
            array = [dict valueForKey:cityInitial];
            if (array == nil) {
                array = [NSMutableArray array];
                [array addObject:city];
                [dict setObject:array forKey:cityInitial];
            } else {
                [array addObject:city];
            }
        }
        [resultSet close];
    }];
    return dict;
}

-(City *) getCity:(FMResultSet *) resultSet {
    City *city = [[City alloc] init];
    NSString *cityName = [resultSet stringForColumn:@"city_name"];
    city.cityName = cityName;
    int isHot = [resultSet intForColumn:@"is_hot"];
    city.isHot = isHot;
    NSString *cityInitial = [resultSet stringForColumn:@"city_initial"];
    city.cityInitial = cityInitial;
    NSString *formula = [resultSet stringForColumn:@"formula"];
    city.formula = formula;
    city.ID = [resultSet stringForColumn:@"id"];
    return city;
}

//货得热门城市
-(NSArray*) hotCities {
    NSMutableArray *hotCities = [NSMutableArray array];
    [self->databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *sql = @"SELECT * FROM City WHERE is_hot = 1";
        FMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            City *city = [self getCity:resultSet];
            [hotCities addObject:city];
        }
        [resultSet close];
    }];
    return hotCities;
}
@end
