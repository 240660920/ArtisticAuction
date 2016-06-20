//
//  ModfifyPasswordViewController.m
//  ArtisticAucation
//
//  Created by xieran on 15/12/8.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "ModifyPasswordViewController.h"
#import <MD5Digest/NSString+MD5.h>

@interface ModifyPasswordViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property(nonatomic,strong)AATextField *originPassTf;
@property(nonatomic,strong)AATextField *passTf1;
@property(nonatomic,strong)AATextField *passTf2;

@property(nonatomic,strong)UIButton *submitButton;

@end

@implementation ModifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"修改密码";
    
    self.table.backgroundView = [UIView backgroundView];
    self.table.separatorColor = TableViewSeparateColor;
    
    self.submitButton.frame = CGRectMake(15, 212, Screen_Width - 30, 44);
    [self.table addSubview:self.submitButton];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
    
    if (indexPath.section == 0) {
        [self.originPassTf removeFromSuperview];
        [cell.contentView addSubview:self.originPassTf];
    }
    else if (indexPath.section == 1){
        [self.passTf1 removeFromSuperview];
        [cell.contentView addSubview:self.passTf1];
    }
    else if (indexPath.section == 2){
        [self.passTf2 removeFromSuperview];
        [cell.contentView addSubview:self.passTf2];
    }
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITextField
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma Private
-(void)submit
{
    if (![[self.originPassTf.text MD5Digest] isEqualToString:[UserInfo sharedInstance].password]) {
        [self.view showHudAndAutoDismiss:@"原始密码不正确"];
        return;
    }
    if (![self.passTf1.text isEqualToString:self.passTf2.text]) {
        [self.view showHudAndAutoDismiss:@"两次输入的新密码不一致"];
        return;
    }
    
    [self.view endEditing:YES];
    
    [self.view showLoadingHud];
    
    [HttpManager requestWithAPI:@"user/modifyUser" params:@{@"userid" : [UserInfo sharedInstance].userId , @"password" : [self.passTf1.text MD5Digest]} requestMethod:@"POST" completion:^(ASIFormDataRequest *request) {
        
        [self.view showHudAndAutoDismiss:@"修改成功，请重新登录"];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tabBarController.navigationController popToRootViewControllerAnimated:YES];
        });
        
    } failed:^(ASIFormDataRequest *request) {
        [self.view showHudAndAutoDismiss:NetworkErrorPrompt];
    }];
}

-(void)textChanged
{
    if (self.originPassTf.text.length > 0 && self.passTf1.text.length > 0 && self.passTf2.text.length > 0) {
        self.submitButton.alpha = 1;
        self.submitButton.enabled = YES;
    }
    else{
        self.submitButton.alpha = 0.5;
        self.submitButton.enabled = NO;
    }
}

#pragma mark Properties
-(AATextField *)originPassTf
{
    if (!_originPassTf) {
        _originPassTf = [[AATextField alloc]initWithFrame:CGRectMake(15, 0, Screen_Width, 44)];
        _originPassTf.delegate = self;
        _originPassTf.returnKeyType = UIReturnKeyDone;
        _originPassTf.placeholder = @"原始密码";
        _originPassTf.secureTextEntry = YES;
        [_originPassTf addTarget:self action:@selector(textChanged) forControlEvents:UIControlEventEditingChanged];
    }
    return _originPassTf;
}

-(AATextField *)passTf1
{
    if (!_passTf1) {
        _passTf1 = [[AATextField alloc]initWithFrame:CGRectMake(15, 0, Screen_Width, 44)];
        _passTf1.delegate = self;
        _passTf1.returnKeyType = UIReturnKeyDone;
        _passTf1.placeholder = @"新密码";
        _passTf1.secureTextEntry = YES;
        [_passTf1 addTarget:self action:@selector(textChanged) forControlEvents:UIControlEventEditingChanged];
    }
    return _passTf1;
}

-(AATextField *)passTf2
{
    if (!_passTf2) {
        _passTf2 = [[AATextField alloc]initWithFrame:CGRectMake(15, 0, Screen_Width, 44)];
        _passTf2.delegate = self;
        _passTf2.returnKeyType = UIReturnKeyDone;
        _passTf2.placeholder = @"确认新密码";
        _passTf2.secureTextEntry = YES;
        [_passTf2 addTarget:self action:@selector(textChanged) forControlEvents:UIControlEventEditingChanged];
    }
    return _passTf2;
}

-(UIButton *)submitButton
{
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitButton setBackgroundImage:[[UIImage imageNamed:@"red_button_nor"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
        [_submitButton setBackgroundImage:[[UIImage imageNamed:@"red_button_sel"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateHighlighted];
        [_submitButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
        [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
        [_submitButton setAlpha:0.5];
        _submitButton.enabled = NO;
        [self.table addSubview:_submitButton];
    }
    return _submitButton;
}

@end
