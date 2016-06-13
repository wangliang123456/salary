//
//  EWRootViewController.m
//  salary-calc
//
//  Created by Eric Wang on 16/5/24.
//  Copyright © 2016年 Eric Wang. All rights reserved.
//

#import "EWRootViewController.h"

static const NSUInteger kBaseHighSocialInsuranceValue = 19389;//五险最高基数
//养老保险
static const double kEndowmentInsuranceCompanyRate = 0.2;
static const double kEndowmentInsurancePersonalRate = 0.08;
static const double kEndowmentInsurancLowValue = 2585;
//失业保险
static const double kUnemploymentInsuranceCompanyRate = 0.01;
static const double kUnemploymentInsurancePersonalRate = 0.002;
static const double kUnemploymentInsuranceValie = 2585;
//工伤保险
static const double kEmploymentInjuryInsuranceCompanyRate = 0.005;
static const double kEmploymentInjuryInsuranceLowValue = 3878;
//生育保险
static const double kChildbirthInsuranceCompanyRate = 0.008;
static const double kChildbirthInsuranceLowValue = 3878;
//医疗保险
static const double kMedicalInsuranceCompanyRate = 0.1;
static const double kMedicalInsurancePersonalRate = 0.02;//别忘记加3元
static const double kMedicalInsuranceLowValue = 3878;
//住房公积金
static const double kHousingFundCompanyRate = 0.12;
static const double kHousingFundPersonalRate = 0.12;
static const double kHousingFundLowValue = 1720;


@interface EWRootViewController ()
{
    UIBarButtonItem* left;
    UIBarButtonItem* right;
}

@property (weak, nonatomic) IBOutlet DFPBannerView *bannerView;

@end

@implementation EWRootViewController
{
    double finalSalary;//税后工资
    double endowmentInsurancePersonalValue;//个人养老金
    double unemploymentInsurancePersonalValue;//个人失业金
    double employmentInjuryInsurancePersonalValue;//个人工伤
    double medicalInsurancePersoalValue;//个人医疗
    double housingFundPersonalValue;//个人公积金
    double childbirthInsurancePersonalValue;//个人生育
    
    double endowmentInsuranceCompanyValue;//公司养老金
    double unemploymentInsuranceCompanyValue;//公司失业金
    double employmentInjuryInsuranceCompanyValue;//公司工伤
    double medicalInsuranceCompanyValue;//公司医疗
    double housingFundCompanyValue;//公司公积金
    double childbirthInsuranceCompanyValue;//公司生育
}

#pragma mark text field resign first responder
- (IBAction)doTap:(id)sender {
    [self.salaryValue resignFirstResponder];
}

#pragma mark 社保发生变化
- (IBAction)socialInsuranceBaseValueChange:(id)sender {
    NSLog(@"socialInsuranceBaseValueChange");
}

#pragma mark 公积金发生变化
- (IBAction)providentFundValueChange:(id)sender {
    NSLog(@"providentFundValueChange");
}

#pragma mark 计算税后工资
-(void) calc:(double) salary {
    double originSalary = salary;
    if (salary > kBaseHighSocialInsuranceValue) {
        salary = kBaseHighSocialInsuranceValue;
    }
    endowmentInsurancePersonalValue = salary * kEndowmentInsurancePersonalRate;
    endowmentInsuranceCompanyValue = salary * kEndowmentInsuranceCompanyRate;
    
    unemploymentInsurancePersonalValue = salary * kUnemploymentInsurancePersonalRate;
    unemploymentInsuranceCompanyValue = salary * kUnemploymentInsuranceCompanyRate;
    
    employmentInjuryInsurancePersonalValue = 0;
    employmentInjuryInsuranceCompanyValue = salary * kEmploymentInjuryInsuranceCompanyRate;
    
    medicalInsurancePersoalValue = salary * kMedicalInsurancePersonalRate;
    medicalInsuranceCompanyValue = salary * kMedicalInsuranceCompanyRate;
    
    childbirthInsurancePersonalValue = 0;
    childbirthInsurancePersonalValue = salary * kChildbirthInsuranceCompanyRate;
    
    housingFundPersonalValue = salary * kHousingFundPersonalRate;
    housingFundCompanyValue = salary * kHousingFundCompanyRate;
    finalSalary = originSalary - endowmentInsurancePersonalValue - unemploymentInsurancePersonalValue - employmentInjuryInsurancePersonalValue - medicalInsurancePersoalValue - childbirthInsurancePersonalValue;
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
    [self setupPieChartView:self.salaryPieChart];
    //set the pie chart view
    self.salaryPieChart.legend.enabled = NO;
    self.salaryPieChart.delegate = self;
    
    [self.salaryPieChart setExtraOffsetsWithLeft:0.f top:50.f right:0.f bottom:50.f];
}

- (void)setupPieChartView:(PieChartView *)chartView
{
    chartView.usePercentValuesEnabled = YES;
    chartView.drawSlicesUnderHoleEnabled = NO;
    chartView.holeRadiusPercent = 0.58;
    chartView.transparentCircleRadiusPercent = 0.61;
    chartView.descriptionText = @"";
    [chartView setExtraOffsetsWithLeft:5.f top:10.f right:5.f bottom:5.f];
    
    chartView.drawCenterTextEnabled = YES;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSMutableAttributedString *centerText = [[NSMutableAttributedString alloc] initWithString:@"iOS Charts\nby Daniel Cohen Gindi"];
    [centerText setAttributes:@{
                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:12.f],
                                NSParagraphStyleAttributeName: paragraphStyle
                                } range:NSMakeRange(0, centerText.length)];
    [centerText addAttributes:@{
                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:10.f],
                                NSForegroundColorAttributeName: UIColor.grayColor
                                } range:NSMakeRange(10, centerText.length - 10)];
    [centerText addAttributes:@{
                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-LightItalic" size:10.f],
                                NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f]
                                } range:NSMakeRange(centerText.length - 19, 19)];
    chartView.centerAttributedText = centerText;
    
    chartView.drawHoleEnabled = YES;
    chartView.rotationAngle = 0.0;
    chartView.rotationEnabled = YES;
    chartView.highlightPerTapEnabled = YES;
    
    ChartLegend *l = chartView.legend;
    l.position = ChartLegendPositionRightOfChart;
    l.xEntrySpace = 7.0;
    l.yEntrySpace = 0.0;
    l.yOffset = 0.0;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    left.title = [userDefault valueForKey:kSelectedCityKey];
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
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self calc:[textField.text doubleValue]];
    return YES;
}
@end
