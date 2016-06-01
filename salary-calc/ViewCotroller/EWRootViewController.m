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
@end
