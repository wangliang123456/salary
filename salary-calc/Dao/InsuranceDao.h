//
//  InsuranceDao.h
//  salary-calc
//
//  Created by wang liang on 2018/4/29.
//  Copyright © 2018年 Eric Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "InsuranceBase.h"

@interface InsuranceDao : NSObject

+(instancetype) sharedInstance;

-(InsuranceBase *) queryBaseByCityId:(int) cityId;

@end
