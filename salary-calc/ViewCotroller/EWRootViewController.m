//
//  EWRootViewController.m
//  salary-calc
//
//  Created by Eric Wang on 16/5/24.
//  Copyright © 2016年 Eric Wang. All rights reserved.
//

#import "EWRootViewController.h"
#import "InsuranceBase.h"
#import "InsuranceDao.h"
#import "Salary.h"

static NSString *kCenterText = @"税后工资:";

static int kInsuranceTag = 1;
static int kHouseFundTag = 2;


@interface EWRootViewController ()
{
    UIBarButtonItem *left;
    UIBarButtonItem *right;
    PieChartView *pieCharView;
    NSArray *parties;
    BOOL insuranceBaseIsHighBase;
    BOOL houseFundBaseIsHighBase;
    int selfDefineHouseFundBase;
    int selfDefineInsuranceBase;
    BOOL isPersonalDetail;
    NSInteger insuranceIndex;
    NSInteger houseFundIndex;
}

@property (weak, nonatomic) IBOutlet DFPBannerView *bannerView;

@end

@implementation EWRootViewController
{
    InsuranceBase *insuranceBase;
}

#pragma mark 社保基数变化
- (IBAction)insuranceBaseChange:(UISegmentedControl *)sender {
    insuranceIndex = sender.selectedSegmentIndex;
    if (sender.selectedSegmentIndex == 0) {//high base
        insuranceBaseIsHighBase = YES;
        selfDefineInsuranceBase = 0;
    } else if (sender.selectedSegmentIndex == 1) {//low base
        insuranceBaseIsHighBase = NO;
        selfDefineInsuranceBase = 0;
    } else {//self define
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请输入你的社保基数" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"完成", nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alertView textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
        alertView.tag = kInsuranceTag;
        alertView.delegate = self;
        [alertView show];
    }
    if (sender.selectedSegmentIndex == 0 || sender.selectedSegmentIndex == 1) {
        [self calc:[self.salaryValue.text doubleValue]];
    }
}

-(void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CityHasChange" object:nil];
}

-(void) recalc {
    [self calc:[self.salaryValue.text doubleValue]];
}

-(void) loadTableView:(Salary *) salary {
    [[self.view viewWithTag:111] removeFromSuperview];
    [UIView animateWithDuration:0.5 animations:^{
        UIScreen *screen = [UIScreen mainScreen];
        int width = (screen.bounds.size.width - 26) / 3;
        NSArray<NSNumber *> *array = @[@(width),@(width),@(width)];
        NALLabelsMatrixView *matrixView = [[NALLabelsMatrixView alloc] initWithFrame:CGRectZero columns:array];
        matrixView.headerColour = self.houseSeg.tintColor;
        matrixView.tag = 111;
        matrixView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:matrixView];
        NSLayoutConstraint *matrixViewHeight = [NSLayoutConstraint constraintWithItem:matrixView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:100];
        NSLayoutConstraint *matrixViewWidth = [NSLayoutConstraint constraintWithItem:matrixView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:-26];
        NSLayoutConstraint *matrixViewCenter = [NSLayoutConstraint constraintWithItem:matrixView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
        NSLayoutConstraint *matrixViewBottom = [NSLayoutConstraint constraintWithItem:matrixView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.houseSeg attribute:NSLayoutAttributeBottom multiplier:1.0 constant:15];
        [self.view addConstraints:@[matrixViewHeight,matrixViewWidth,matrixViewCenter,matrixViewBottom]];
        NSArray* header = @[@"工资明细",@"个人详情(比例)",@"公司详情(比例)"];
        [matrixView addRecordWithRecord:header];
        
        NSData *data = [insuranceBase.houseFund dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *dict = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:&error];
        //公积金
        
        NSString *houseFundPRate = [NSString stringWithFormat:@"%.f",[[dict valueForKey:kPersonalRate]doubleValue] * 100];
        NSString *houseFundCRate = [NSString stringWithFormat:@"%.f",[[dict valueForKey:kCompanyRate]doubleValue] * 100];
        NSArray *houseFund = @[@"公积金",[NSString stringWithFormat:@"%.1f(%@%%)",salary.housingFundPersonalValue,houseFundPRate],[NSString stringWithFormat:@"%.1f(%@%%)",salary.housingFundCompanyValue,houseFundCRate]];
        [matrixView addRecordWithRecord:houseFund];
        
        
        data = [insuranceBase.endowmentInsurance dataUsingEncoding:NSUTF8StringEncoding];
        dict = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:&error];
        NSString *endowmentInsurancePRate = [NSString stringWithFormat:@"%.f",[[dict valueForKey:kPersonalRate]doubleValue] * 100];
        NSString *endowmentInsuranceCRate = [NSString stringWithFormat:@"%.f",[[dict valueForKey:kCompanyRate]doubleValue] * 100];
        //养老
        NSArray *endowmentInsurance = @[@"养老保险",[NSString stringWithFormat:@"%.1f(%@%%)",salary.endowmentInsurancePersonalValue,endowmentInsurancePRate],[NSString stringWithFormat:@"%.1f(%@%%)",salary.endowmentInsuranceCompanyValue,endowmentInsuranceCRate]];
        [matrixView addRecordWithRecord:endowmentInsurance];
        
        data = [insuranceBase.unemploymentInsurance dataUsingEncoding:NSUTF8StringEncoding];
        dict = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:&error];
        NSString *unemploymentInsurancePRate = [NSString stringWithFormat:@"%.2f",[[dict valueForKey:kPersonalRate]doubleValue] * 100];
        NSString *unemploymentInsuranceCRate = [NSString stringWithFormat:@"%.1f",[[dict valueForKey:kCompanyRate]doubleValue] * 100];
        
        //失业
        NSArray *unemploymentInsurance = @[@"失业保险",[NSString stringWithFormat:@"%.1f(%@%%)",salary.unemploymentInsurancePersonalValue,unemploymentInsurancePRate],[NSString stringWithFormat:@"%.1f(%@%%)",salary.unemploymentInsuranceCompanyValue,unemploymentInsuranceCRate]];
        [matrixView addRecordWithRecord:unemploymentInsurance];
        
        data = [insuranceBase.medicalInsurance dataUsingEncoding:NSUTF8StringEncoding];
        dict = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:&error];
        NSArray<NSString *> *exp = [[dict valueForKey:kPersonalRate] componentsSeparatedByString:@"+"];
        NSString *medicalInsurancePRate = [NSString stringWithFormat:@"%.f", [exp[0] doubleValue] * 100];
        NSString *medicalInsuranceCRate = [NSString stringWithFormat:@"%.f",[[dict valueForKey:kCompanyRate]doubleValue] * 100];
        //医疗
        NSArray *medicalInsurance = @[@"医疗保险",[NSString stringWithFormat:@"%.1f(%@%%+%@)",salary.medicalInsurancePersoalValue,medicalInsurancePRate,exp[1]],[NSString stringWithFormat:@"%.1f(%@%%)",salary.medicalInsuranceCompanyValue,medicalInsuranceCRate]];
        [matrixView addRecordWithRecord:medicalInsurance];
        
        data = [insuranceBase.maternityInsurance dataUsingEncoding:NSUTF8StringEncoding];
        dict = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:&error];
        NSString *maternityInsurancePRate = [NSString stringWithFormat:@"%.f",[[dict valueForKey:kPersonalRate]doubleValue] * 100];
        NSString *maternityInsuranceCRate = [NSString stringWithFormat:@"%.f",[[dict valueForKey:kCompanyRate]doubleValue] * 100];
        
        //生育
        NSArray *childbirthInsurance = @[@"生育保险",[NSString stringWithFormat:@"%.1f(%@%%)",salary.childbirthInsurancePersonalValue,maternityInsurancePRate],[NSString stringWithFormat:@"%.1f(%@%%)",salary.childbirthInsuranceCompanyValue,maternityInsuranceCRate]];
        [matrixView addRecordWithRecord:childbirthInsurance];
        
        
        data = [insuranceBase.employmentInjuryInsurance dataUsingEncoding:NSUTF8StringEncoding];
        dict = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:&error];
        NSString *employmentInjuryInsurancePRate = [NSString stringWithFormat:@"%.f",[[dict valueForKey:kPersonalRate]doubleValue] * 100];
        NSString *employmentInjuryInsuranceCRate = [NSString stringWithFormat:@"%.1f",[[dict valueForKey:kCompanyRate]doubleValue] * 100];
        
        //工伤
        NSArray *employmentInjuryInsurance = @[@"工伤保险",[NSString stringWithFormat:@"%.1f(%@%%)",salary.employmentInjuryInsurancePersonalValue,employmentInjuryInsurancePRate],[NSString stringWithFormat:@"%.1f(%@%%)",salary.employmentInjuryInsuranceCompanyValue,employmentInjuryInsuranceCRate]];
        [matrixView addRecordWithRecord:employmentInjuryInsurance];
        
        //个税
        NSArray *tax = @[@"个人所得税",[NSString stringWithFormat:@"%.1f",salary.tax],@"0"];
        [matrixView addRecordWithRecord:tax];
        
        //总计
        NSArray *total = @[@"税后工资",[NSString stringWithFormat:@"%.1f",salary.salaryWithTax],@"0"];
        [matrixView addRecordWithRecord:total];
        
    }];
}

#pragma mark 公积金基数变化
-(void)houseFundBaseChange:(UISegmentedControl *)sender {
    houseFundIndex = sender.selectedSegmentIndex;
    if (sender.selectedSegmentIndex == 0) {//high base
        houseFundBaseIsHighBase = YES;
        selfDefineHouseFundBase = 0;
    } else if (sender.selectedSegmentIndex == 1) {//low base
        houseFundBaseIsHighBase = NO;
        selfDefineHouseFundBase = 0;
    } else {//self define
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请输入你的公积金基数" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"完成", nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        alertView.tag = kHouseFundTag;
        alertView.delegate = self;
        [alertView textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
        [alertView show];
    }
    if (sender.selectedSegmentIndex == 0 || sender.selectedSegmentIndex == 1) {
        [self calc:[self.salaryValue.text doubleValue]];
    }
}
    


#pragma mark 计算详情变化
-(void)resultDetailChange:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {//personal detail
        isPersonalDetail = YES;
    } else {//conpany detail
        isPersonalDetail = NO;
    }
}

#pragma mark text field resign first responder
- (IBAction)doTap:(id)sender {
    [self.salaryValue resignFirstResponder];
}

#pragma mark 计算税后工资
-(void) calc:(double) salaryParam {
    if (salaryParam == 0) {
        return;
    }
    Salary *salary = [[Salary alloc] init];
    salary.salaryWithoutTax = salaryParam;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *currentCityName = [userDefault valueForKey:kSelectedCityKey];
    insuranceBase = [[InsuranceDao sharedInstance] queryBaseByCityName:currentCityName];
    //养老
    NSData *endowmentInsuranceData = [insuranceBase.endowmentInsurance dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *endowmentInsuranceDataDict = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:endowmentInsuranceData options:kNilOptions error:&error];
    if (insuranceBaseIsHighBase) {
        if (salaryParam > [[endowmentInsuranceDataDict valueForKey:kLowBase] doubleValue] && salaryParam < [[endowmentInsuranceDataDict valueForKey:kHighBase] doubleValue]) {
            salary.endowmentInsurancePersonalValue = salaryParam * [[endowmentInsuranceDataDict valueForKey:kPersonalRate] doubleValue];
            salary.endowmentInsuranceCompanyValue = salaryParam * [[endowmentInsuranceDataDict valueForKey:kCompanyRate] doubleValue];
        } else if (salaryParam > [[endowmentInsuranceDataDict valueForKey:kHighBase] doubleValue]) {
            salary.endowmentInsurancePersonalValue = [[endowmentInsuranceDataDict valueForKey:kHighBase] doubleValue] * [[endowmentInsuranceDataDict valueForKey:kPersonalRate] doubleValue];
            salary.endowmentInsuranceCompanyValue = [[endowmentInsuranceDataDict valueForKey:kHighBase] doubleValue] * [[endowmentInsuranceDataDict valueForKey:kCompanyRate] doubleValue];
        } else if (salaryParam < [[endowmentInsuranceDataDict valueForKey:kLowBase] doubleValue]) {
            salary.endowmentInsurancePersonalValue = [[endowmentInsuranceDataDict valueForKey:kLowBase] doubleValue] * [[endowmentInsuranceDataDict valueForKey:kPersonalRate] doubleValue];
            salary.endowmentInsuranceCompanyValue = [[endowmentInsuranceDataDict valueForKey:kLowBase] doubleValue] * [[endowmentInsuranceDataDict valueForKey:kCompanyRate] doubleValue];
        }
        
        //医疗保险
        NSString *medicalInsuranceData = [insuranceBase.medicalInsurance dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *medicalInsuranceDict = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:medicalInsuranceData options:kNilOptions error:&error];
        NSString *exp = [medicalInsuranceDict valueForKey:kPersonalRate];
        NSArray<NSString *> *array = [exp componentsSeparatedByString:@"+"];
        if (salaryParam > [[endowmentInsuranceDataDict valueForKey:kLowBase] doubleValue] && salaryParam < [[medicalInsuranceDict valueForKey:kHighBase] doubleValue]) {
            salary.medicalInsurancePersoalValue = salaryParam * [array[0] doubleValue] + [array[1] integerValue];
            salary.medicalInsuranceCompanyValue = salaryParam * [[medicalInsuranceDict valueForKey:kCompanyRate] doubleValue];
        } else if (salaryParam > [[endowmentInsuranceDataDict valueForKey:kHighBase] doubleValue]) {
            salary.medicalInsurancePersoalValue = [[endowmentInsuranceDataDict valueForKey:kHighBase] doubleValue] * [array[0] doubleValue] + [array[1] integerValue];
            salary.medicalInsuranceCompanyValue = [[endowmentInsuranceDataDict valueForKey:kHighBase] doubleValue] * [[medicalInsuranceDict valueForKey:kCompanyRate] doubleValue];
        } else if (salaryParam < [[endowmentInsuranceDataDict valueForKey:kLowBase] doubleValue]) {
            salary.medicalInsurancePersoalValue = [[endowmentInsuranceDataDict valueForKey:kLowBase] doubleValue] * [array[0] doubleValue] + [array[1] integerValue];
            salary.medicalInsuranceCompanyValue = [[endowmentInsuranceDataDict valueForKey:kLowBase] doubleValue] * [[medicalInsuranceDict valueForKey:kCompanyRate] doubleValue];
        }
        
        //失业保险
        NSString *unemploymentInsuranceData = [insuranceBase.unemploymentInsurance dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *unemploymentInsuranceDict = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:unemploymentInsuranceData options:kNilOptions error:&error];
        if (salaryParam > [[unemploymentInsuranceDict valueForKey:kLowBase] doubleValue] && salaryParam < [[unemploymentInsuranceDict valueForKey:kHighBase] doubleValue]) {
            salary.unemploymentInsurancePersonalValue = salaryParam * [[unemploymentInsuranceDict valueForKey:kPersonalRate] doubleValue];
            salary.unemploymentInsuranceCompanyValue = salaryParam * [[unemploymentInsuranceDict valueForKey:kCompanyRate] doubleValue];
        } else if (salaryParam > [[unemploymentInsuranceDict valueForKey:kHighBase] doubleValue]) {
            salary.unemploymentInsurancePersonalValue = [[unemploymentInsuranceDict valueForKey:kHighBase] doubleValue] * [[unemploymentInsuranceDict valueForKey:kPersonalRate] doubleValue];
            salary.unemploymentInsuranceCompanyValue = [[unemploymentInsuranceDict valueForKey:kHighBase] doubleValue] * [[unemploymentInsuranceDict valueForKey:kCompanyRate] doubleValue];
        } else if (salaryParam < [[unemploymentInsuranceDict valueForKey:kLowBase] doubleValue]) {
            salary.unemploymentInsurancePersonalValue = [[unemploymentInsuranceDict valueForKey:kLowBase] doubleValue] * [[unemploymentInsuranceDict valueForKey:kPersonalRate] doubleValue];
            salary.unemploymentInsuranceCompanyValue = [[unemploymentInsuranceDict valueForKey:kLowBase] doubleValue] * [[unemploymentInsuranceDict valueForKey:kCompanyRate] doubleValue];
        }
        
        //工伤保险
        NSString *employmentInjuryInsuranceData = [insuranceBase.employmentInjuryInsurance dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *employmentInjuryInsuranceDict = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:employmentInjuryInsuranceData options:kNilOptions error:&error];
        if (salaryParam > [[employmentInjuryInsuranceDict valueForKey:kLowBase] doubleValue] && salaryParam < [[employmentInjuryInsuranceDict valueForKey:kHighBase] doubleValue]) {
            salary.employmentInjuryInsurancePersonalValue = salaryParam * [[employmentInjuryInsuranceDict valueForKey:kPersonalRate] doubleValue];
            salary.employmentInjuryInsuranceCompanyValue = salaryParam * [[employmentInjuryInsuranceDict valueForKey:kCompanyRate] doubleValue];
        } else if (salaryParam > [[unemploymentInsuranceDict valueForKey:kHighBase] doubleValue]) {
            salary.employmentInjuryInsurancePersonalValue = [[employmentInjuryInsuranceDict valueForKey:kHighBase] doubleValue] * [[employmentInjuryInsuranceDict valueForKey:kPersonalRate] doubleValue];
            salary.employmentInjuryInsuranceCompanyValue = [[employmentInjuryInsuranceDict valueForKey:kHighBase] doubleValue] * [[employmentInjuryInsuranceDict valueForKey:kCompanyRate] doubleValue];
        } else if (salaryParam < [[employmentInjuryInsuranceDict valueForKey:kLowBase] doubleValue]) {
            salary.employmentInjuryInsurancePersonalValue = [[employmentInjuryInsuranceDict valueForKey:kLowBase] doubleValue] * [[employmentInjuryInsuranceDict valueForKey:kPersonalRate] doubleValue];
            salary.employmentInjuryInsuranceCompanyValue = [[employmentInjuryInsuranceDict valueForKey:kLowBase] doubleValue] * [[employmentInjuryInsuranceDict valueForKey:kCompanyRate] doubleValue];
        }
        //生育保险
        NSString *maternityInsuranceData = [insuranceBase.maternityInsurance dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *maternityInsuranceDict = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:maternityInsuranceData options:kNilOptions error:&error];
        if (salaryParam > [[maternityInsuranceDict valueForKey:kLowBase] doubleValue] && salaryParam < [[maternityInsuranceDict valueForKey:kHighBase] doubleValue]) {
            salary.childbirthInsurancePersonalValue = salaryParam * [[maternityInsuranceDict valueForKey:kPersonalRate] doubleValue];
            salary.childbirthInsuranceCompanyValue = salaryParam * [[maternityInsuranceDict valueForKey:kCompanyRate] doubleValue];
        } else if (salaryParam > [[maternityInsuranceDict valueForKey:kHighBase] doubleValue]) {
            salary.childbirthInsurancePersonalValue = [[maternityInsuranceDict valueForKey:kHighBase] doubleValue] * [[maternityInsuranceDict valueForKey:kPersonalRate] doubleValue];
            salary.childbirthInsuranceCompanyValue = [[maternityInsuranceDict valueForKey:kHighBase] doubleValue] * [[maternityInsuranceDict valueForKey:kCompanyRate] doubleValue];
        } else if (salaryParam < [[maternityInsuranceDict valueForKey:kLowBase] doubleValue]) {
            salary.childbirthInsurancePersonalValue = [[maternityInsuranceDict valueForKey:kLowBase] doubleValue] * [[maternityInsuranceDict valueForKey:kPersonalRate] doubleValue];
            salary.childbirthInsuranceCompanyValue = [[maternityInsuranceDict valueForKey:kLowBase] doubleValue] * [[maternityInsuranceDict valueForKey:kCompanyRate] doubleValue];
        }
    } else {
        //养老保险
        salary.endowmentInsurancePersonalValue = [[endowmentInsuranceDataDict valueForKey:kLowBase] doubleValue] * [[endowmentInsuranceDataDict valueForKey:kPersonalRate] doubleValue];
        salary.endowmentInsuranceCompanyValue = [[endowmentInsuranceDataDict valueForKey:kLowBase] doubleValue] * [[endowmentInsuranceDataDict valueForKey:kCompanyRate] doubleValue];
        
        //医疗保险
        NSString *medicalInsuranceData = [insuranceBase.medicalInsurance dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *medicalInsuranceDict = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:medicalInsuranceData options:kNilOptions error:&error];
        NSString *exp = [medicalInsuranceDict valueForKey:kPersonalRate];
        NSArray<NSString *> *array = [exp componentsSeparatedByString:@"+"];
        salary.medicalInsurancePersoalValue = [[endowmentInsuranceDataDict valueForKey:kLowBase] doubleValue] * [array[0] doubleValue] + [array[1] integerValue];
        salary.medicalInsuranceCompanyValue = [[endowmentInsuranceDataDict valueForKey:kLowBase] doubleValue] * [[medicalInsuranceDict valueForKey:kCompanyRate] doubleValue];
        
        //失业保险
        NSString *unemploymentInsuranceData = [insuranceBase.unemploymentInsurance dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *unemploymentInsuranceDict = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:unemploymentInsuranceData options:kNilOptions error:&error];
        salary.unemploymentInsurancePersonalValue = [[unemploymentInsuranceDict valueForKey:kLowBase] doubleValue] * [[unemploymentInsuranceDict valueForKey:kPersonalRate] doubleValue];
        salary.unemploymentInsuranceCompanyValue = [[unemploymentInsuranceDict valueForKey:kLowBase] doubleValue] * [[unemploymentInsuranceDict valueForKey:kCompanyRate] doubleValue];
        
        
        //工伤保险
        NSString *employmentInjuryInsuranceData = [insuranceBase.employmentInjuryInsurance dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *employmentInjuryInsuranceDict = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:employmentInjuryInsuranceData options:kNilOptions error:&error];
        salary.employmentInjuryInsurancePersonalValue = [[employmentInjuryInsuranceDict valueForKey:kLowBase] doubleValue] * [[employmentInjuryInsuranceDict valueForKey:kPersonalRate] doubleValue];
        salary.employmentInjuryInsuranceCompanyValue = [[employmentInjuryInsuranceDict valueForKey:kLowBase] doubleValue] * [[employmentInjuryInsuranceDict valueForKey:kCompanyRate] doubleValue];
        
        //生育保险
        NSString *maternityInsuranceData = [insuranceBase.maternityInsurance dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *maternityInsuranceDict = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:maternityInsuranceData options:kNilOptions error:&error];
        salary.childbirthInsurancePersonalValue = [[maternityInsuranceDict valueForKey:kLowBase] doubleValue] * [[maternityInsuranceDict valueForKey:kPersonalRate] doubleValue];
        salary.childbirthInsuranceCompanyValue = [[maternityInsuranceDict valueForKey:kLowBase] doubleValue] * [[maternityInsuranceDict valueForKey:kCompanyRate] doubleValue];
        
    }
    if (selfDefineInsuranceBase) {//自定义金额
        //养老保险
        if (salaryParam >= selfDefineInsuranceBase) {
            salary.endowmentInsurancePersonalValue = selfDefineInsuranceBase * [[endowmentInsuranceDataDict valueForKey:kPersonalRate] doubleValue];
            salary.endowmentInsuranceCompanyValue = selfDefineInsuranceBase * [[endowmentInsuranceDataDict valueForKey:kCompanyRate] doubleValue];
        } else if (salaryParam < selfDefineInsuranceBase && salaryParam > [[endowmentInsuranceDataDict valueForKey:kLowBase] doubleValue]) {
            salary.endowmentInsurancePersonalValue = salaryParam * [[endowmentInsuranceDataDict valueForKey:kPersonalRate] doubleValue];
            salary.endowmentInsuranceCompanyValue = salaryParam * [[endowmentInsuranceDataDict valueForKey:kCompanyRate] doubleValue];
        } else {
            salary.endowmentInsurancePersonalValue = [[endowmentInsuranceDataDict valueForKey:kLowBase] doubleValue] * [[endowmentInsuranceDataDict valueForKey:kPersonalRate] doubleValue];
            salary.endowmentInsuranceCompanyValue = [[endowmentInsuranceDataDict valueForKey:kLowBase] doubleValue] * [[endowmentInsuranceDataDict valueForKey:kCompanyRate] doubleValue];
        }
        
        NSString *medicalInsuranceData = [insuranceBase.medicalInsurance dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *medicalInsuranceDict = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:medicalInsuranceData options:kNilOptions error:&error];
        NSString *exp = [medicalInsuranceDict valueForKey:kPersonalRate];
        NSArray<NSString *> *array = [exp componentsSeparatedByString:@"+"];
        //医疗保险
        if (salaryParam >= selfDefineInsuranceBase) {
            salary.medicalInsurancePersoalValue = selfDefineInsuranceBase * [array[0] doubleValue] + [array[1] integerValue];
            salary.medicalInsuranceCompanyValue = selfDefineInsuranceBase * [[medicalInsuranceDict valueForKey:kCompanyRate] doubleValue];
        } else if (salaryParam < selfDefineInsuranceBase && salaryParam > [[medicalInsuranceDict valueForKey:kLowBase] doubleValue]) {
            salary.medicalInsurancePersoalValue = salaryParam * [array[0] doubleValue] + [array[1] integerValue];
            salary.medicalInsuranceCompanyValue = salaryParam * [[medicalInsuranceDict valueForKey:kCompanyRate] doubleValue];
        } else {
            salary.medicalInsurancePersoalValue = [[medicalInsuranceDict valueForKey:kLowBase] doubleValue] * [array[0] doubleValue] + [array[1] integerValue];
            salary.medicalInsuranceCompanyValue = [[medicalInsuranceDict valueForKey:kLowBase] doubleValue] * [[medicalInsuranceDict valueForKey:kCompanyRate] doubleValue];
        }
        
        //失业保险
        NSString *unemploymentInsuranceData = [insuranceBase.unemploymentInsurance dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *unemploymentInsuranceDict = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:unemploymentInsuranceData options:kNilOptions error:&error];
        if (salaryParam >= selfDefineInsuranceBase) {
            salary.unemploymentInsurancePersonalValue = selfDefineInsuranceBase * [[unemploymentInsuranceDict valueForKey:kPersonalRate] doubleValue];
            salary.unemploymentInsuranceCompanyValue = selfDefineInsuranceBase * [[unemploymentInsuranceDict valueForKey:kCompanyRate] doubleValue];
        } else if (salaryParam < selfDefineInsuranceBase && salaryParam > [[unemploymentInsuranceDict valueForKey:kLowBase] doubleValue]) {
            salary.unemploymentInsurancePersonalValue = salaryParam * [[unemploymentInsuranceDict valueForKey:kPersonalRate] doubleValue];
            salary.unemploymentInsuranceCompanyValue = salaryParam * [[unemploymentInsuranceDict valueForKey:kCompanyRate] doubleValue];
        } else {
            salary.unemploymentInsurancePersonalValue = [[unemploymentInsuranceDict valueForKey:kLowBase] doubleValue] * [[unemploymentInsuranceDict valueForKey:kPersonalRate] doubleValue];
            salary.unemploymentInsuranceCompanyValue = [[unemploymentInsuranceDict valueForKey:kLowBase] doubleValue] * [[unemploymentInsuranceDict valueForKey:kCompanyRate] doubleValue];
        }
        
        //工伤保险
        NSString *employmentInjuryInsuranceData = [insuranceBase.employmentInjuryInsurance dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *employmentInjuryInsuranceDict = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:employmentInjuryInsuranceData options:kNilOptions error:&error];
        if (salaryParam >= selfDefineInsuranceBase) {
            salary.employmentInjuryInsurancePersonalValue = selfDefineInsuranceBase * [[employmentInjuryInsuranceDict valueForKey:kPersonalRate] doubleValue];
            salary.employmentInjuryInsuranceCompanyValue = selfDefineInsuranceBase * [[employmentInjuryInsuranceDict valueForKey:kCompanyRate] doubleValue];
        } else if (salaryParam < selfDefineInsuranceBase && salaryParam < [[employmentInjuryInsuranceDict valueForKey:kLowBase] doubleValue]) {
            salary.employmentInjuryInsurancePersonalValue = salaryParam * [[employmentInjuryInsuranceDict valueForKey:kPersonalRate] doubleValue];
            salary.employmentInjuryInsuranceCompanyValue = salaryParam * [[employmentInjuryInsuranceDict valueForKey:kCompanyRate] doubleValue];
        } else {
            salary.employmentInjuryInsurancePersonalValue = [[employmentInjuryInsuranceDict valueForKey:kLowBase] doubleValue] * [[employmentInjuryInsuranceDict valueForKey:kPersonalRate] doubleValue];
            salary.employmentInjuryInsuranceCompanyValue = [[employmentInjuryInsuranceDict valueForKey:kLowBase] doubleValue] * [[employmentInjuryInsuranceDict valueForKey:kCompanyRate] doubleValue];
        }
        
        //生育保险
        NSString *maternityInsuranceData = [insuranceBase.maternityInsurance dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *maternityInsuranceDict = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:maternityInsuranceData options:kNilOptions error:&error];
        if (salaryParam >= selfDefineInsuranceBase) {
            salary.childbirthInsurancePersonalValue = selfDefineInsuranceBase * [[maternityInsuranceDict valueForKey:kPersonalRate] doubleValue];
            salary.childbirthInsuranceCompanyValue = selfDefineInsuranceBase * [[maternityInsuranceDict valueForKey:kCompanyRate] doubleValue];
        } else if (salaryParam < selfDefineInsuranceBase && salaryParam < [[maternityInsuranceDict valueForKey:kLowBase] doubleValue]) {
            salary.childbirthInsurancePersonalValue = salaryParam * [[maternityInsuranceDict valueForKey:kPersonalRate] doubleValue];
            salary.childbirthInsuranceCompanyValue = salaryParam * [[maternityInsuranceDict valueForKey:kCompanyRate] doubleValue];
        } else {
            salary.childbirthInsurancePersonalValue = [[maternityInsuranceDict valueForKey:kLowBase] doubleValue] * [[maternityInsuranceDict valueForKey:kPersonalRate] doubleValue];
            salary.childbirthInsuranceCompanyValue = [[maternityInsuranceDict valueForKey:kLowBase] doubleValue] * [[maternityInsuranceDict valueForKey:kCompanyRate] doubleValue];
        }
    }
    
    
    //公积金
    NSString *houseFundData = [insuranceBase.houseFund dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *mhouseFundDict = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:houseFundData options:kNilOptions error:&error];
    if (houseFundBaseIsHighBase) {
        if (salaryParam > [[mhouseFundDict valueForKey:kLowBase] doubleValue] && salaryParam < [[mhouseFundDict valueForKey:kHighBase] doubleValue]) {
            salary.housingFundPersonalValue = salaryParam * [[mhouseFundDict valueForKey:kPersonalRate] doubleValue];
            salary.housingFundCompanyValue = salaryParam * [[mhouseFundDict valueForKey:kCompanyRate] doubleValue];
        } else if (salaryParam > [[mhouseFundDict valueForKey:kHighBase] doubleValue]) {
            salary.housingFundPersonalValue = [[mhouseFundDict valueForKey:kHighBase] doubleValue] * [[mhouseFundDict valueForKey:kPersonalRate] doubleValue];
            salary.housingFundCompanyValue = [[mhouseFundDict valueForKey:kHighBase] doubleValue] * [[mhouseFundDict valueForKey:kCompanyRate] doubleValue];
        } else if (salaryParam < [[mhouseFundDict valueForKey:kLowBase] doubleValue]) {
            salary.housingFundPersonalValue = [[mhouseFundDict valueForKey:kLowBase] doubleValue] * [[mhouseFundDict valueForKey:kPersonalRate] doubleValue];
            salary.housingFundCompanyValue = [[mhouseFundDict valueForKey:kLowBase] doubleValue] * [[mhouseFundDict valueForKey:kCompanyRate] doubleValue];
        }
    } else {//最低基数
        salary.housingFundPersonalValue = [[mhouseFundDict valueForKey:kLowBase] doubleValue] * [[mhouseFundDict valueForKey:kPersonalRate] doubleValue];
        salary.housingFundCompanyValue = [[mhouseFundDict valueForKey:kLowBase] doubleValue] * [[mhouseFundDict valueForKey:kCompanyRate] doubleValue];
    }
    if (selfDefineHouseFundBase > 0) {
        if (salaryParam >= selfDefineHouseFundBase) {
            salary.housingFundPersonalValue = selfDefineHouseFundBase * [[mhouseFundDict valueForKey:kPersonalRate] doubleValue];
            salary.housingFundCompanyValue = selfDefineHouseFundBase * [[mhouseFundDict valueForKey:kCompanyRate] doubleValue];
        } else if (salaryParam < selfDefineHouseFundBase) {
            if (salaryParam > [[mhouseFundDict valueForKey:kLowBase] doubleValue]) {
                salary.housingFundPersonalValue = salaryParam * [[mhouseFundDict valueForKey:kPersonalRate] doubleValue];
                salary.housingFundCompanyValue = salaryParam * [[mhouseFundDict valueForKey:kCompanyRate] doubleValue];
            }
        }
    }
    
    salary.salaryWithTax = salary.salaryWithoutTax - salary.housingFundPersonalValue - salary.unemploymentInsurancePersonalValue - salary.medicalInsurancePersoalValue - salary.childbirthInsurancePersonalValue - salary.employmentInjuryInsurancePersonalValue - salary.endowmentInsurancePersonalValue;
    if (salary.salaryWithTax > 3500) {
        double tax = 0;
        double baseTax = salary.salaryWithTax - 3500;
        if (baseTax < 1500) {
            tax = baseTax * 0.03;
        } else if (baseTax <= 4500 && baseTax >= 1500) {
            tax = baseTax * 0.1 - 105;
        } else if (baseTax <= 9000 && baseTax > 4500) {
            tax = baseTax * 0.2 - 555;
        } else if (baseTax <= 35000 && baseTax > 9000) {
            tax = baseTax * 0.25 - 1005;
        } else if (baseTax <= 55000 && baseTax > 35000) {
            tax = baseTax * 0.3 - 2755;
        } else if (baseTax <= 80000 && baseTax > 55000) {
            tax = baseTax * 0.35 - 5505;
        } else {
            tax = baseTax * 0.45 - 13505;
        }
        salary.tax = tax;
        salary.salaryWithTax = salary.salaryWithTax - tax;
    }
    [self loadTableView:salary];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"薪资计算";
    [self initVariable];
    [self initView];
    UIScreen *screen = [UIScreen mainScreen];
    if (screen.bounds.size.height == 568) {
        for (NSLayoutConstraint *con in self.spaces) {
            con.constant = 10;
        }
    } else {
        [self loadBanerAD];
    }
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    int currentCityId = [[userDefault valueForKey:kSelectedCityId] intValue];
    if (currentCityId == 0) {
        [self changeCity:nil];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recalc) name:@"CityHasChange" object:nil];
}

-(void) initVariable {
    isPersonalDetail = YES;
    houseFundBaseIsHighBase = YES;
    insuranceBaseIsHighBase = YES;
}

-(void) loadBanerAD {
    self.bannerView.adUnitID = @"ca-app-pub-6212992129754905/8546169709";
    self.bannerView.rootViewController = self;
    GADRequest* request  = [GADRequest request];
    [self.bannerView loadRequest:request];
    houseFundIndex = 0;
    insuranceIndex = 0;
}

-(void) initView {
    left = [[UIBarButtonItem alloc] initWithTitle:@"北京" style:UIBarButtonItemStylePlain target:self action:@selector(changeCity:)];
    right = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(changeSetting:)];
    right.tintColor = self.houseSeg.tintColor;
    left.tintColor = self.houseSeg.tintColor;
    self.navigationItem.leftBarButtonItem = left;
    self.navigationItem.rightBarButtonItem = right;
    self.salaryValue.delegate = self;
    self.salaryValue.layer.borderWidth = 1.0;
    self.salaryValue.layer.borderColor = self.houseSeg.tintColor.CGColor;
}

#pragma mark 加载饼图
-(void) loadPieChartView:(Salary *) salary {
    if (pieCharView) {
        [pieCharView removeFromSuperview];
    }
    pieCharView = [[PieChartView alloc] initWithFrame:CGRectZero];
    pieCharView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:pieCharView];
    NSLayoutConstraint *pieChartHeight = [NSLayoutConstraint constraintWithItem:pieCharView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:230];
    NSLayoutConstraint *pieChartWidth = [NSLayoutConstraint constraintWithItem:pieCharView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
    NSLayoutConstraint *pieChartLeading = [NSLayoutConstraint constraintWithItem:pieCharView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    NSLayoutConstraint *pieChartBottom = [NSLayoutConstraint constraintWithItem:pieCharView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-130];
    [self.view addConstraints:@[pieChartHeight,pieChartWidth,pieChartLeading,pieChartBottom]];
    pieCharView.legend.enabled = NO;
    pieCharView.delegate = self;
    [pieCharView setExtraOffsetsWithLeft:20.f top:0.f right:20.f bottom:0.f];
    [pieCharView animateWithYAxisDuration:1.4 easingOption:ChartEasingOptionEaseInCirc];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setupPieChartView:pieCharView];
    [self setDataSet:salary];
}

- (void)setDataSet:(Salary *) salary
{
    pieCharView.centerText = [NSString stringWithFormat:@"税后:%.2f",salary.salaryWithTax];
    PieChartDataEntry *endowmentInsuranceEntry = [[PieChartDataEntry alloc] initWithValue:salary.endowmentInsurancePersonalValue label:[NSString stringWithFormat:@"养老保险:%.f",salary.endowmentInsurancePersonalValue]];
    PieChartDataEntry *medicalInsuranceEntry = [[PieChartDataEntry alloc] initWithValue:salary.medicalInsurancePersoalValue label:[NSString stringWithFormat:@"医疗保险:%.f",salary.medicalInsurancePersoalValue]];
    PieChartDataEntry *lostJob = [[PieChartDataEntry alloc] initWithValue:salary.unemploymentInsurancePersonalValue  label:[NSString stringWithFormat:@"失业保险:%.f",salary.unemploymentInsurancePersonalValue]];
    PieChartDataEntry *taxEntry = [[PieChartDataEntry alloc] initWithValue:salary.tax label:[NSString stringWithFormat:@"个人所得税:%.f",salary.tax]];
    PieChartDataEntry *salaryWitTaxEntry = [[PieChartDataEntry alloc] initWithValue:salary.salaryWithTax label:[NSString stringWithFormat:@"税后工资:%.f",salary.salaryWithTax]];
    PieChartDataEntry *houseFundEntry = [[PieChartDataEntry alloc] initWithValue:salary.housingFundPersonalValue  label:[NSString stringWithFormat:@"公积金:%.f",salary.housingFundPersonalValue]];
    
    NSArray *dataArray = @[endowmentInsuranceEntry,medicalInsuranceEntry,taxEntry,salaryWitTaxEntry,houseFundEntry,lostJob];
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithValues:dataArray label:@""];
    dataSet.sliceSpace = 2.0;
    // add a lot of colors
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    [colors addObjectsFromArray:ChartColorTemplates.vordiplom];
    [colors addObjectsFromArray:ChartColorTemplates.joyful];
    [colors addObjectsFromArray:ChartColorTemplates.colorful];
    [colors addObjectsFromArray:ChartColorTemplates.liberty];
    [colors addObjectsFromArray:ChartColorTemplates.pastel];
    [colors addObject:[UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f]];
    dataSet.colors = colors;
    dataSet.valueLinePart1OffsetPercentage = 0.5;
    dataSet.valueLinePart1Length = 0.2;
    dataSet.valueLinePart2Length = 0.4;
    dataSet.xValuePosition = PieChartValuePositionOutsideSlice;
    dataSet.yValuePosition = PieChartValuePositionOutsideSlice;
    
    PieChartData *data = [[PieChartData alloc] initWithDataSet:dataSet];
    NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
    pFormatter.numberStyle = NSNumberFormatterPercentStyle;
    pFormatter.maximumFractionDigits = 1;
    pFormatter.multiplier = @1.f;
    pFormatter.percentSymbol = @" %";
    [data setValueFormatter:[[ChartDefaultValueFormatter alloc] initWithFormatter:pFormatter]];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11.f]];
    [data setValueTextColor:UIColor.blackColor];
    pieCharView.data = data;
    [pieCharView highlightValues:nil];
    [pieCharView animateWithYAxisDuration:1.4 easingOption:ChartEasingOptionEaseOutBack];
}

- (void)setupPieChartView:(PieChartView *)chartView
{
    chartView.usePercentValuesEnabled = YES;
    chartView.drawSlicesUnderHoleEnabled = NO;
    chartView.holeRadiusPercent = 0.58;
    chartView.transparentCircleRadiusPercent = 0.61;
    chartView.chartDescription.enabled = NO;
    [chartView setExtraOffsetsWithLeft:5.f top:10.f right:5.f bottom:5.f];
    chartView.drawCenterTextEnabled = YES;
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    chartView.drawHoleEnabled = YES;
    chartView.rotationAngle = 0.0;
    chartView.rotationEnabled = YES;
    chartView.highlightPerTapEnabled = YES;
    ChartLegend *l = chartView.legend;
    l.horizontalAlignment = ChartLegendHorizontalAlignmentRight;
    l.verticalAlignment = ChartLegendVerticalAlignmentTop;
    l.orientation = ChartLegendOrientationVertical;
    l.drawInside = NO;
    l.xEntrySpace = 7.0;
    l.yEntrySpace = 0.0;
    l.yOffset = 0.0;
}

#pragma mark - ChartViewDelegate
- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight
{
    NSLog(@"chartValueSelected");
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    NSLog(@"chartValueNothingSelected");
}

-(void) slidersValueChanged:(id)sender {
//    [self setDataCount:4 range:100];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *title = [userDefault valueForKey:kSelectedCityKey];
    if (title.length == 0) {
        title = @"北京";
    }
    left.title = title;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark change city
-(void) changeCity:(id) sender {
    [self performSegueWithIdentifier:@"Location" sender:nil];
}

#pragma mark change setting
-(void) changeSetting:(id) sender {
    [self performSegueWithIdentifier:@"Setting" sender:nil];
}

#pragma mark text field delegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self calc:[textField.text doubleValue]];
}

#pragma mark alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == kInsuranceTag) {
        selfDefineInsuranceBase = [[alertView textFieldAtIndex:0].text integerValue];
        if (buttonIndex == 0) {//社保取消按钮点击
            if (insuranceBaseIsHighBase) {
                self.insuranceSeg.selectedSegmentIndex = 0;
            } else {
                self.insuranceSeg.selectedSegmentIndex = 1;
            }
        }
    } else if (alertView.tag == kHouseFundTag) {
        selfDefineHouseFundBase = [[alertView textFieldAtIndex:0].text integerValue];
        if (buttonIndex == 0) {//取消按钮点击
            if (houseFundBaseIsHighBase) {
                 self.houseSeg.selectedSegmentIndex = 0;
            } else {
                self.houseSeg.selectedSegmentIndex = 1;
            }
        }
    }
    if (buttonIndex == 1) {
        [self calc:[self.salaryValue.text doubleValue]];
    }
}
@end
