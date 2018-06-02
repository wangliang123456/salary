//
//  InsuranceCinfigViewController.m
//  salary-calc
//
//  Created by wang liang on 2018/5/22.
//  Copyright © 2018年 Eric Wang. All rights reserved.
//

#import "InsuranceConfigViewController.h"
#import "InsuranceBase.h"
#import "InsuranceDao.h"

@interface InsuranceConfigViewController ()

@end

@implementation InsuranceConfigViewController
{
    InsuranceBase *insuranceBase;
    int currentCityId;
    UIBarButtonItem *left;
    UIBarButtonItem *right;
}

-(void) save {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentView.dataSource = self;
    [self.contentView registerNib:[UINib nibWithNibName:@"InsuranceConfigCellTableViewCell" bundle:nil] forCellReuseIdentifier:@"baseCell"];
    left = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    left.tintColor = [UIColor colorWithRed:0 green:0.74902 blue:1 alpha:1];
    
    right = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    right.tintColor = [UIColor colorWithRed:0 green:0.74902 blue:1 alpha:1];
    self.navigationItem.leftBarButtonItem = left;
    self.navigationItem.rightBarButtonItem = right;
    self.title = @"基数";
    [self loadViewData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGRect keyboardBounds = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.contentView.contentInset = UIEdgeInsetsMake(self.contentView.contentInset.top, 0, keyboardBounds.size.height, 0);
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.contentView.contentInset = UIEdgeInsetsMake(self.contentView.contentInset.top, 0, 0, 0);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) loadViewData {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    currentCityId = [[userDefault valueForKey:kSelectedCityId] intValue];
    NSString *cityName =[userDefault valueForKey:kSelectedCityKey];
    insuranceBase = [[InsuranceDao sharedInstance] queryBaseByCityName:cityName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        if (section == 2) {
            return 5;
        }
        return 4;
    }
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title = @"";
    if (section == 0) {
        title = @"当前城市";
    } else if (section == 1) {
        title = @"养老保险";
    } else if (section == 2) {
        title = @"医疗保险";
    } else if (section == 3) {
        title = @"失业保险";
    } else if (section == 4) {
        title = @"工伤保险";
    } else if (section == 5) {
        title = @"生育保险";
    } else if (section == 6) {
        title = @"公积金";
    }
    return title;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"baseCell";
    InsuranceConfigCellTableViewCell *configCell = (InsuranceConfigCellTableViewCell *) [tableView dequeueReusableCellWithIdentifier:identifier];
    NSString *title = @"";
    if (indexPath.section == 0) {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        configCell.indexLabel.text = @"当前城市";
        configCell.baseValue.text = [userDefault valueForKey:kSelectedCityKey];
        configCell.unitLabel.hidden = YES;
    } else if (indexPath.section == 1) {
        NSData *data = [insuranceBase.endowmentInsurance dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *dict = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        switch (indexPath.row) {
            case 0:
                title = @"最高基数";
                configCell.baseValue.text = [[dict valueForKey:kHighBase] stringValue];
                configCell.unitLabel.text = @"元";
                break;
            case 1:
                title = @"最低基数";
                configCell.baseValue.text = [[dict valueForKey:kLowBase] stringValue];
                configCell.unitLabel.text = @"元";
                break;
            case 2:
                title = @"个人比例";
                configCell.baseValue.text = [NSString stringWithFormat:@"%.1f",[[dict valueForKey:kPersonalRate] doubleValue] * 100];
                configCell.unitLabel.text = @"%";
                break;
            case 3:
                title = @"公司比例";
                configCell.baseValue.text = [NSString stringWithFormat:@"%.1f",[[dict valueForKey:kCompanyRate] doubleValue] * 100];
                configCell.unitLabel.text = @"%";
                break;
            default:
                break;
        }
        configCell.indexLabel.text = title;
        configCell.unitLabel.hidden = NO;
    } else if (indexPath.section == 2) {
        NSData *data = [insuranceBase.medicalInsurance dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *dict = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSString *rate = [[dict valueForKey:kPersonalRate] componentsSeparatedByString:@"+"][0];
        configCell.baseValue.text = [NSString stringWithFormat:@"%.1f",[rate doubleValue] * 100];
        switch (indexPath.row) {
            case 0:
                title = @"最高基数";
                configCell.baseValue.text = [[dict valueForKey:kHighBase] stringValue];
                configCell.unitLabel.text = @"元";
                break;
            case 1:
                title = @"最低基数";
                configCell.baseValue.text = [[dict valueForKey:kLowBase] stringValue];
                configCell.unitLabel.text = @"元";
                break;
            case 2:
                title = @"个人比例";
                configCell.indexLabel.text = rate;
                configCell.unitLabel.text = @"%";
                break;
            case 3:
                title = @"补充费用";
                configCell.baseValue.text = [[dict valueForKey:kPersonalRate] componentsSeparatedByString:@"+"][1];
                configCell.unitLabel.text = @"元";
                break;
            case 4:
                title = @"公司比例";
                configCell.baseValue.text = [NSString stringWithFormat:@"%.1f",[[dict valueForKey:kCompanyRate] doubleValue] * 100];
                configCell.unitLabel.text = @"%";
                break;
            default:
                break;
        }
        configCell.indexLabel.text = title;
        configCell.unitLabel.hidden = NO;
    } else if (indexPath.section == 3) {
        NSData *data = [insuranceBase.unemploymentInsurance dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *dict = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        switch (indexPath.row) {
            case 0:
                title = @"最高基数";
                configCell.baseValue.text = [[dict valueForKey:kHighBase] stringValue];
                configCell.unitLabel.text = @"元";
                break;
            case 1:
                title = @"最低基数";
                configCell.baseValue.text = [[dict valueForKey:kLowBase] stringValue];
                configCell.unitLabel.text = @"元";
                break;
            case 2:
                title = @"个人比例";
                configCell.baseValue.text = [NSString stringWithFormat:@"%.1f",[[dict valueForKey:kPersonalRate] doubleValue] * 100];
                configCell.unitLabel.text = @"%";
                break;
            case 3:
                title = @"公司比例";
                configCell.baseValue.text = [NSString stringWithFormat:@"%.1f",[[dict valueForKey:kCompanyRate] doubleValue] * 100];
                configCell.unitLabel.text = @"%";
                break;
            default:
                break;
        }
        configCell.indexLabel.text = title;
        configCell.unitLabel.hidden = NO;
    } else if (indexPath.section == 4) {
        NSData *data = [insuranceBase.employmentInjuryInsurance dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *dict = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        switch (indexPath.row) {
            case 0:
                title = @"最高基数";
                configCell.baseValue.text = [[dict valueForKey:kHighBase] stringValue];
                configCell.unitLabel.text = @"元";
                break;
            case 1:
                title = @"最低基数";
                configCell.baseValue.text = [[dict valueForKey:kLowBase] stringValue];
                configCell.unitLabel.text = @"元";
                break;
            case 2:
                title = @"个人比例";
               configCell.baseValue.text = [NSString stringWithFormat:@"%.1f",[[dict valueForKey:kPersonalRate] doubleValue] * 100];
                configCell.unitLabel.text = @"%";
                break;
            case 3:
                title = @"公司比例";
                configCell.baseValue.text = [NSString stringWithFormat:@"%.1f",[[dict valueForKey:kCompanyRate] doubleValue] * 100];
                configCell.unitLabel.text = @"%";
                break;
            default:
                break;
        }
        configCell.indexLabel.text = title;
        configCell.unitLabel.hidden = NO;
    } else if (indexPath.section == 5) {
        NSData *data = [insuranceBase.maternityInsurance dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *dict = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        switch (indexPath.row) {
            case 0:
                title = @"最高基数";
                configCell.baseValue.text = [[dict valueForKey:kHighBase] stringValue];
                configCell.unitLabel.text = @"元";
                break;
            case 1:
                title = @"最低基数";
                configCell.baseValue.text = [[dict valueForKey:kLowBase] stringValue];
                configCell.unitLabel.text = @"元";
                break;
            case 2:
                title = @"个人比例";
                configCell.baseValue.text = [NSString stringWithFormat:@"%.1f",[[dict valueForKey:kPersonalRate] doubleValue] * 100];
                configCell.unitLabel.text = @"%";
                break;
            case 3:
                title = @"公司比例";
                configCell.baseValue.text = [NSString stringWithFormat:@"%.1f",[[dict valueForKey:kCompanyRate] doubleValue] * 100];
                configCell.unitLabel.text = @"%";
                break;
            default:
                break;
        }
        configCell.indexLabel.text = title;
        configCell.unitLabel.hidden = NO;
    } else if (indexPath.section == 6) {
        NSData *data = [insuranceBase.houseFund dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *dict = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        switch (indexPath.row) {
            case 0:
                title = @"最高基数";
                configCell.baseValue.text = [[dict valueForKey:kHighBase] stringValue];
                configCell.unitLabel.text = @"元";
                break;
            case 1:
                title = @"最低基数";
                configCell.baseValue.text = [[dict valueForKey:kLowBase] stringValue];
                configCell.unitLabel.text = @"元";
                break;
            case 2:
                title = @"个人比例";
                configCell.baseValue.text = [NSString stringWithFormat:@"%.1f",[[dict valueForKey:kPersonalRate] doubleValue] * 100];
                configCell.unitLabel.text = @"%";
                break;
            case 3:
                title = @"公司比例";
                configCell.baseValue.text = [NSString stringWithFormat:@"%.1f",[[dict valueForKey:kCompanyRate] doubleValue] * 100];
                configCell.unitLabel.text = @"%";
                break;
            default:
                break;
        }
        configCell.indexLabel.text = title;
        configCell.unitLabel.hidden = NO;
    }
    configCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return configCell;
}

@end
