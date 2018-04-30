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

static const NSUInteger kBaseHighSocialInsuranceValue = 23118;//五险最高基数

static NSString *kCenterText = @"税后";


@interface EWRootViewController ()
{
    UIBarButtonItem* left;
    UIBarButtonItem* right;
    PieChartView *pieCharView;
    NSArray *parties;
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
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    int currentCityId = [[userDefault valueForKey:kSelectedCityId] intValue];
    InsuranceBase *insuranceBase= [[InsuranceDao sharedInstance] queryBaseByCityId:currentCityId];
    pieCharView.centerText = [NSString stringWithFormat:@"税后:%.2f",finalSalary];
    PieChartDataEntry *endowmentInsuranceEntry = [[PieChartDataEntry alloc] initWithValue:endowmentInsurancePersonalValue / originSalary label:@"养老保险"];
    PieChartDataEntry *unemploymentInjuryInsuranceEntry = [[PieChartDataEntry alloc] initWithValue:unemploymentInsurancePersonalValue / originSalary label:@""];
    PieChartDataEntry *medicalInsuranceEntry = [[PieChartDataEntry alloc] initWithValue:medicalInsurancePersoalValue / originSalary label:@""];
    PieChartDataEntry *childbirthInsuranceEntry = [[PieChartDataEntry alloc] initWithValue:childbirthInsurancePersonalValue / originSalary label:@""];
    PieChartDataEntry *employmentInjuryInsuranceEntry = [[PieChartDataEntry alloc] initWithValue:employmentInjuryInsurancePersonalValue / originSalary label:@""];
    NSArray *dataArray = @[endowmentInsuranceEntry,unemploymentInjuryInsuranceEntry,medicalInsuranceEntry,childbirthInsuranceEntry,employmentInjuryInsuranceEntry];
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
    self.salaryValue.layer.borderColor = [UIColor orangeColor].CGColor;
    //set the pie chart view
    pieCharView = [[PieChartView alloc] initWithFrame:CGRectZero];
    pieCharView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:pieCharView];
    NSLayoutConstraint *pieChartHeight = [NSLayoutConstraint constraintWithItem:pieCharView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:230];
    NSLayoutConstraint *pieChartWidth = [NSLayoutConstraint constraintWithItem:pieCharView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
    NSLayoutConstraint *pieChartLeading = [NSLayoutConstraint constraintWithItem:pieCharView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    NSLayoutConstraint *pieChartBottom = [NSLayoutConstraint constraintWithItem:pieCharView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-50];
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
