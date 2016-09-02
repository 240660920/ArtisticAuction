//
//  RegistViewController.m
//  ArtisticAucation
//
//  Created by xieran on 15/9/18.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "RegistViewController.h"
#import "RegistTextField.h"
#import "RegistResponse.h"
#import "VerificationCodeButton.h"
#import "VerificationCodeManager.h"
#import <MD5Digest/NSString+MD5.h>
#import <SMS_SDK/SMSSDK.h>

#define RegistButtonDisableBackgroundColor [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:204.0/255.0]
#define RegistTableRowHeight 45

@interface RegistViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)RegistTextField *phoneNumTf;
@property(nonatomic,strong)RegistTextField *passwordTf;
@property(nonatomic,strong)RegistTextField *confirmPasswordTf;
@property(nonatomic,strong)RegistTextField *verifyCodeTf;
@property(nonatomic,strong)VerificationCodeButton *verifyCodeButton;
@property(nonatomic,strong)UIButton *registButton;
@property(nonatomic,strong)UITableView *table;

@end

@implementation RegistViewController

-(void)willMoveToParentViewController:(UIViewController *)parent
{
    //pop
    if (!parent) {
        [self.verifyCodeButton.timer invalidate];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"注册";
    
    self.navigationController.navigationBarHidden = NO;

    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.registButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(@(RegistTableRowHeight * 4 + 20 + 20));
        make.height.equalTo(@44);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Delegate
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void)textDidChange:(NSNotification *)notice
{
    UITextField *textField = [notice object];
    
    if (textField == self.phoneNumTf || textField == self.passwordTf || textField == self.confirmPasswordTf || textField == self.verifyCodeTf) {
        if (self.phoneNumTf.text.length == 0 || self.passwordTf.text.length == 0 || self.confirmPasswordTf.text.length == 0 || self.verifyCodeTf.text.length == 0) {
            self.registButton.enabled = NO;
            self.registButton.backgroundColor = RegistButtonDisableBackgroundColor;
        }
        else{
            self.registButton.enabled = YES;
            self.registButton.backgroundColor = RedColor;
        }
    }
}

#pragma mark TableView 
-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    for (UITextField *tf in cell.contentView.subviews) {
        if ([tf isKindOfClass:[UITextField class]]) {
            [tf removeFromSuperview];
        }
    }
    
    switch (indexPath.row) {
        case 0:
            [cell.contentView addSubview:self.phoneNumTf];
            break;
        case 1:
            [cell.contentView addSubview:self.passwordTf];
            break;
        case 2:
            [cell.contentView addSubview:self.confirmPasswordTf];
            break;
        case 3:{
            [cell.contentView addSubview:self.verifyCodeTf];
            [cell.contentView addSubview:self.verifyCodeButton];
            
            UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.verifyCodeButton.frame), 4, 1, RegistTableRowHeight - 8)];
            line.backgroundColor = TableViewSeparateColor;
            [cell.contentView addSubview:line];
        }
            break;
        default:
            break;
    }
    
    return cell;
}

-(CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}


#pragma mark Private Methods
-(void)regist
{
    [self.view endEditing:YES];
    
    //验证两次输入的密码
    if (![self.passwordTf.text isEqual:self.confirmPasswordTf.text]) {
        [self.view showHudAndAutoDismiss:@"两次输入的密码不一致"];
        return;
    }
    
    //校验手机号格式
    NSString *regex = @"^[1][3578][0-9]{9}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if (![predicate evaluateWithObject:[self.phoneNumTf.text stringByReplacingOccurrencesOfString:@"-" withString:@""]]) {
        [self.view showHudAndAutoDismiss:@"请输入正确的手机号码"];
        return;
    }
    
    
    //验证码校验
    [SMSSDK commitVerificationCode:self.verifyCodeTf.text phoneNumber:self.phoneNumTf.text zone:@"86" result:^(NSError *error) {
        if (!error) {
            NSLog(@"验证码校验成功");
            [self.view showLoadingHud];
            
            [HttpManager requestWithAPI:@"user/register" params:@{@"phoneNum" : self.phoneNumTf.text , @"password" : [self.passwordTf.text MD5Digest]} requestMethod:@"POST" completion:^(ASIFormDataRequest *request) {
                
                [self.view hideAllHud];
                
                RegistResponse *respose = [[RegistResponse alloc]initWithString:request.responseString error:nil];
                if (respose && respose.result.resultCode.intValue == 0) {
                    [self.view showHudAndAutoDismiss:@"注册成功"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }
                else{
                    [self.view showHudAndAutoDismiss:respose.result.msg];
                }
                
            } failed:^(ASIFormDataRequest *request) {
                [self.view hideAllHud];
                [self.view showHudAndAutoDismiss:NetworkErrorPrompt];
            }];
        }
        else{
            NSLog(@"验证码校验失败");
            [self.view showHudAndAutoDismiss:@"验证码错误"];
        }
    }];
}

-(void)sendVerifyCode
{
    //校验手机号格式
    NSString *regex = @"^[1][3578][0-9]{9}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if (![predicate evaluateWithObject:[self.phoneNumTf.text stringByReplacingOccurrencesOfString:@"-" withString:@""]]) {
        [self.view showHudAndAutoDismiss:@"请输入正确的手机号码"];
        return;
    }
    
    [self.view showLoadingHud];
    
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.phoneNumTf.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
        if (!error)
        {
            NSLog(@"验证码发送成功");
            
            [self.view showHudAndAutoDismiss:@"发送成功"];
            
            [[VerificationCodeManager sharedInstance]startRegistTimeCountDown];
            
            self.verifyCodeButton.enabled = NO;
        }
        else
        {
            [self.view showHudAndAutoDismiss:@"发送失败"];
        }
    }];
}

#pragma mark Properties
-(RegistTextField *)phoneNumTf
{
    if (!_phoneNumTf) {
        _phoneNumTf = [[RegistTextField alloc]initWithFrame:CGRectMake(15, 0, Screen_Width - 30, RegistTableRowHeight)];
        _phoneNumTf.placeholder = @"手机号";
        _phoneNumTf.keyboardType = UIKeyboardTypeNumberPad;
        _phoneNumTf.delegate = (id)self;
    }
    return _phoneNumTf;
}

-(RegistTextField *)passwordTf
{
    if (!_passwordTf) {
        _passwordTf = [[RegistTextField alloc]initWithFrame:CGRectMake(15, 0, Screen_Width - 30, RegistTableRowHeight)];
        _passwordTf.placeholder = @"密码";
        _passwordTf.delegate = (id)self;
        _passwordTf.secureTextEntry = YES;
    }
    return _passwordTf;
}

-(RegistTextField *)confirmPasswordTf
{
    if (!_confirmPasswordTf) {
        _confirmPasswordTf = [[RegistTextField alloc]initWithFrame:CGRectMake(15, 0, Screen_Width - 30, RegistTableRowHeight)];
        _confirmPasswordTf.placeholder = @"确认密码";
        _confirmPasswordTf.delegate = (id)self;
        _confirmPasswordTf.secureTextEntry = YES;
    }
    return _confirmPasswordTf;
}

-(RegistTextField *)verifyCodeTf
{
    if (!_verifyCodeTf) {
        _verifyCodeTf = [[RegistTextField alloc]initWithFrame:CGRectMake(15, 0, 150, RegistTableRowHeight)];
        _verifyCodeTf.placeholder = @"请输入验证码";
        _verifyCodeTf.delegate = self;
        [self.view addSubview:_verifyCodeTf];
    }
    return _verifyCodeTf;
}

-(VerificationCodeButton *)verifyCodeButton
{
    if (!_verifyCodeButton) {
        _verifyCodeButton = [[VerificationCodeButton alloc]initWithFrame:CGRectMake(Screen_Width - 135, 0, 135, RegistTableRowHeight)];
        [_verifyCodeButton addTarget:self action:@selector(sendVerifyCode) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_verifyCodeButton];
    }
    return _verifyCodeButton;
}

-(UIButton *)registButton
{
    if (!_registButton) {
        _registButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _registButton.enabled = NO;
        [_registButton setTitle:@"注册" forState:UIControlStateNormal];
        [_registButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _registButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_registButton setBackgroundImage:[[UIImage imageNamed:@"red_button_nor"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
        [_registButton setBackgroundImage:[[UIImage imageNamed:@"red_button_sel"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateHighlighted];
        [_registButton setBackgroundImage:[[UIImage imageNamed:@"red_button_disable"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateDisabled];
        [_registButton addTarget:self action:@selector(regist) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_registButton];
    }
    return _registButton;
}

-(UITableView *)table
{
    if (!_table) {
        _table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _table.delegate = self;
        _table.dataSource = self;
        _table.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
        _table.separatorColor = TableViewSeparateColor;
        _table.backgroundView = [UIView backgroundView];
        _table.scrollEnabled = NO;
        [self.view addSubview:_table];
    }
    return _table;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
