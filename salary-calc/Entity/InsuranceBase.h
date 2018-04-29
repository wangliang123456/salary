//
//  InsuranceBase.h
//  salary-calc
//
//  Created by wang liang on 2018/4/29.
//  Copyright © 2018年 Eric Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InsuranceBase : NSObject
@property(nonatomic,strong) NSString *endowmentInsurance;
@property(nonatomic,strong) NSString *medicalInsurance;
@property(nonatomic,strong) NSString *unemploymentInsurance;
@property(nonatomic,strong) NSString *maternityInsurance;
@property(nonatomic,strong) NSString *employmentInjuryInsurance;
@property(nonatomic,strong) NSString *houseFund;
@end
