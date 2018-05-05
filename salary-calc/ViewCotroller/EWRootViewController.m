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
}

@property (weak, nonatomic) IBOutlet DFPBannerView *bannerView;

@end

@implementation EWRootViewController
{
    Salary *salary;
    InsuranceBase *insuranceBase;
}

#pragma mark 社保基数变化
- (IBAction)insuranceBaseChange:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {//high base
        insuranceBaseIsHighBase = YES;
    } else if (sender.selectedSegmentIndex == 1) {//low base
        insuranceBaseIsHighBase = NO;
    } else {//self define
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请输入你的社保基数" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"完成", nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alertView textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
        [alertView show];
    }
}

#pragma mark 公积金基数变化
- (IBAction)houseFundBaseChange:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {//high base
        houseFundBaseIsHighBase = YES;
    } else if (sender.selectedSegmentIndex == 1) {//low base
        houseFundBaseIsHighBase = NO;
    } else {//self define
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请输入你的公积金基数" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"完成", nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alertView textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
        [alertView show];
    }
}

#pragma mark 计算详情变化
- (IBAction)resultDetailChange:(UISegmentedControl *)sender {
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
    salary = [[Salary alloc] init];
    salary.salaryWithoutTax = salaryParam;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    int currentCityId = [[userDefault valueForKey:kSelectedCityId] intValue];
    insuranceBase = [[InsuranceDao sharedInstance] queryBaseByCityId:currentCityId];
    //养老
    NSString *endowmentInsuranceData = [insuranceBase.endowmentInsurance dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *endowmentInsuranceDataDict = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:endowmentInsuranceData options:kNilOptions error:&error];
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
    //公积金
    NSString *houseFundData = [insuranceBase.houseFund dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *mhouseFundDict = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:houseFundData options:kNilOptions error:&error];
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
    
    pieCharView.centerText = [NSString stringWithFormat:@"税后:%.2f",salary.salaryWithTax];
    PieChartDataEntry *endowmentInsuranceEntry = [[PieChartDataEntry alloc] initWithValue:salary.endowmentInsurancePersonalValue / salary.salaryWithoutTax label:@"养老保险"];
    PieChartDataEntry *medicalInsuranceEntry = [[PieChartDataEntry alloc] initWithValue:salary.medicalInsurancePersoalValue / salary.salaryWithoutTax label:@"医疗保险"];
    PieChartDataEntry *taxEntry = [[PieChartDataEntry alloc] initWithValue:salary.tax / salary.salaryWithoutTax label:@"个人所得税"];
    PieChartDataEntry *salaryWitTaxEntry = [[PieChartDataEntry alloc] initWithValue:salary.salaryWithTax / salary.salaryWithoutTax label:@"税后工资"];
    PieChartDataEntry *houseFundEntry = [[PieChartDataEntry alloc] initWithValue:salary.housingFundPersonalValue / salary.salaryWithoutTax label:@"公积金"];
    NSArray *dataArray = @[endowmentInsuranceEntry,medicalInsuranceEntry,taxEntry,salaryWitTaxEntry,houseFundEntry];
    [self setDataSet:dataArray];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"薪资计算";
    [self initView];
    [self loadBanerAD];
}

-(void) loadBanerAD {
    self.bannerView.adUnitID = @"ca-app-pub-6212992129754905/3625975674";
    self.bannerView.rootViewController = self;
    GADRequest* request  = [GADRequest request];
    request.testDevices = @[@"584cf4beda1742fc9ab57b49fae2065553da4ff2"];
    [self.bannerView loadRequest:request];
}

-(void) initView {
    left = [[UIBarButtonItem alloc] initWithTitle:@"北京" style:UIBarButtonItemStylePlain target:self action:@selector(changeCity:)];
    right = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(changeSetting:)];
    self.navigationItem.leftBarButtonItem = left;
    self.navigationItem.rightBarButtonItem = right;
    self.salaryValue.delegate = self;
    self.salaryValue.layer.borderWidth = 0.5;
    self.salaryValue.layer.borderColor =[UIColor colorWithRed:0.59 green:0.89 blue:0.98 alpha:1.00].CGColor;
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
    [pieCharView animateWithYAxisDuration:1.4 easingOption:ChartEasingOptionEaseOutBack];
    parties = @[
                @"Party A", @"Party B", @"Party C", @"Party D", @"Party E", @"Party F",
                @"Party G", @"Party H", @"Party I", @"Party J", @"Party K", @"Party L",
                @"Party M", @"Party N", @"Party O", @"Party P", @"Party Q", @"Party R",
                @"Party S", @"Party T", @"Party U", @"Party V", @"Party W", @"Party X",
                @"Party Y", @"Party Z"
                ];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    NSArray *dataArray = @[[[PieChartDataEntry alloc] initWithValue:0 label:@""],[[PieChartDataEntry alloc] initWithValue:0 label:@"dsadsadsadsa"],[[PieChartDataEntry alloc] initWithValue:0 label:@"dsadsadsadsa"],[[PieChartDataEntry alloc] initWithValue:0 label:@"dsadsadsadsa"],[[PieChartDataEntry alloc] initWithValue:0 label:@"dsadsadsadsa"]];
    [self setDataSet:dataArray];
    [self setupPieChartView:pieCharView];
}

- (void)setDataSet:(NSArray *) dataArray
{
    
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithValues:dataArray label:@"Election Results"];
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
    pieCharView.centerText = kCenterText;
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
@end
