//
//  Salary.h
//  salary-calc
//
//  Created by wang liang on 2018/4/30.
//  Copyright © 2018年 Eric Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Salary : NSObject

@property(nonatomic, assign) double salaryWithoutTax;//税前工资
@property(nonatomic, assign) double salaryWithTax;//税后工资
@property(nonatomic, assign) double endowmentInsurancePersonalValue;//个人养老金
@property(nonatomic, assign) double unemploymentInsurancePersonalValue;//个人失业金
@property(nonatomic, assign) double employmentInjuryInsurancePersonalValue;//个人工伤
@property(nonatomic, assign) double medicalInsurancePersoalValue;//个人医疗
@property(nonatomic, assign) double housingFundPersonalValue;//个人公积金
@property(nonatomic, assign) double childbirthInsurancePersonalValue;//个人生育
@property(nonatomic, assign) double endowmentInsuranceCompanyValue;//公司养老金
@property(nonatomic, assign) double unemploymentInsuranceCompanyValue;//公司失业金
@property(nonatomic, assign) double employmentInjuryInsuranceCompanyValue;//公司工伤
@property(nonatomic, assign) double medicalInsuranceCompanyValue;//公司医疗
@property(nonatomic, assign) double housingFundCompanyValue;//公司公积金
@property(nonatomic, assign) double childbirthInsuranceCompanyValue;//公司生育

@end
