//
//  LoginViewController.m
//  ArtisticAucation
//
//  Created by xieran on 15/8/27.
//  Copyright (c) 2015年 xieran. All rights reserved.
//

#import "LoginViewController.h"
#import <ASIHTTPRequest/ASIHTTPRequest.h>
#import "WXApi.h"
#import "AppDelegate.h"
#import "MainViewController.h"
#import "LoginSubview.h"
#import "RegistViewController.h"
#import "LoginResponse.h"
#import <MD5Digest/NSString+MD5.h>
#import "WeixinLoginResponse.h"
#import "LoginManager.h"
#import "BidManager.h"
#import "ForgetPwdViewController.h"

@interface LoginViewController ()<WXApiDelegate,LoginViewDelegate,UITextFieldDelegate>

@property(nonatomic,strong)LoginSubview *subview;
@property(nonatomic,strong)UIImageView *backgroundImageView;
@property(nonatomic,strong)UIButton *forgetPwdBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
    [self resumeLoginSubviewLayout];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self beginAnimation];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.subview removeFromSuperview];
}

-(void)beginAnimation
{
    [self.view addSubview:self.subview];
    [self.subview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(Screen_Height * 0.35));
        make.height.equalTo(@(Screen_Height * 0.51));
        make.width.equalTo(@(Screen_Width * 0.8));
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    for (UIView *v in self.subview.subviews) {
        v.alpha = 0;
    }
    
    self.forgetPwdBtn.alpha = 0;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:2];
        [self.subview beginAnimation];
        self.forgetPwdBtn.alpha = 1;
        self.backgroundImageView.layer.affineTransform = CGAffineTransformScale(self.backgroundImageView.layer.affineTransform, 1.05, 1.05);
        [UIView commitAnimations];
    });
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
    
    [self.forgetPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-10);
    }];
}

-(void)keyboardWillShow:(NSNotification *)notice
{
    NSDictionary *info = [notice userInfo];
    CGSize kbSize=[[info objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue].size;
    
    CGRect pwdTfFrame = [self.subview convertRect:self.subview.passwordTf.frame toView:self.view];
    CGFloat offset = CGRectGetMaxY(pwdTfFrame) - (Screen_Height - kbSize.height);
    if (offset > 0) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:7];
        [UIView setAnimationDuration:0.25];
        self.view.frame = CGRectMake(0, self.view.frame.origin.y - offset, self.view.bounds.size.width, self.view.bounds.size.height);
        [UIView commitAnimations];
    }
}


#pragma KVO


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark UITextField delegate
-(void)textFieldShouldReturn:(UITextField *)textField
{
    [self resumeLoginSubviewLayout];
    
    if (textField == self.subview.passwordTf) {
        [self loginWithUsername:self.subview.usernameTf.text password:textField.text];
    }
}

#pragma mark Delegate
- (void)loginWithUsername:(NSString *)username password:(NSString *)password{
    if (username.length == 0) {
        [self.view showHudAndAutoDismiss:@"用户名不能为空"];
        return;
    }
    else if (password.length == 0){
        [self.view showHudAndAutoDismiss:@"密码不能为空"];
        return;
    }
    
    [self.view showLoadingHud];
    
    [LoginManager login:kLoginTypePhone autoLogin:NO params:[[NSMutableDictionary alloc]initWithDictionary:@{@"phoneNum" : username , @"password" : [password MD5Digest] , @"type" : @"0"}] successBlock:^{
        
        [self.view hideAllHud];
        
        self.subview.passwordTf.text = nil;
        
        [self pushToTabbarController];
                
    } failedBlock:^(NSString *errorMsg) {
        [self.view showHudAndAutoDismiss:errorMsg];
    }];
}


#pragma mark Private Methods
-(void)pushToTabbarController
{
    MainViewController *tabbarController = [[MainViewController alloc]init];
    [self.navigationController pushViewController:tabbarController animated:YES];
}

- (IBAction)regist{    
    RegistViewController *vc = [[RegistViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)weixinLogin{
    
    SendAuthReq* req =[[SendAuthReq alloc ] init ];
    req.scope = @"snsapi_userinfo";
    req.state = @"123" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    
    /*先设置回调*/
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate setWeixinLoginSuccessBlock:^(NSString *uniqueId){
        
        [self.view hideAllHud];
        
        [UserInfo sharedInstance].weixinUniqueId = [uniqueId copy];
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        params[@"type"] = @"1";
        params[@"username"] = [uniqueId copy];
        
        [LoginManager login:kLoginTypeWeixin autoLogin:NO params:params successBlock:^{
                        
            [self pushToTabbarController];

        } failedBlock:^(NSString *errorMsg) {
            [self.view showHudAndAutoDismiss:@"微信登录失败"];
        }];
        
        
        
    }];
    [appDelegate setWeixinLoginFailureBlock:^(){
        [self.view hideAllHud];
    }];
    /**/

    
    //向微信发请求
    if (![WXApi sendAuthReq:req viewController:self delegate:self]) {
        [self.view showHudAndAutoDismiss:@"微信登录失败"];
    }

}

- (IBAction)travelerLogin{
    
    [LoginManager login:kLoginTypeTraveller autoLogin:NO params:nil successBlock:^{
        
        [self pushToTabbarController];
                
    } failedBlock:^(NSString *errorMsg) {
        
    }];
}

-(void)resumeLoginSubviewLayout
{
    if (!CGRectEqualToRect(self.view.frame, [UIApplication sharedApplication].keyWindow.bounds)) {
        [UIView beginAnimations:nil context:nil];
        self.view.frame = [UIApplication sharedApplication].keyWindow.bounds;
        [UIView commitAnimations];
    }
}

-(void)forgetPassword
{
    ForgetPwdViewController *vc = [[ForgetPwdViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark Properties
-(UIView *)subview
{
    if (!_subview) {
        _subview = [[LoginSubview alloc]init];
        _subview.backgroundColor = [UIColor clearColor];
        _subview.delegate = (id)self;
    }
    return _subview;
}

-(UIImageView *)backgroundImageView
{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc]init];
        [self.view insertSubview:_backgroundImageView atIndex:0];
        
        NSString *imageName;
        if (iPhone4Screen) {
            imageName = @"iPhone4_login_bg";
        }
        else if (iPhone5Screen){
            imageName = @"iPhone5_login_bg";
        }
        else if (iPhone6Screen || iPhone6PlusScreen){
            imageName = @"iPhone6_login_bg";
        }
        _backgroundImageView.image = [UIImage imageNamed:imageName];
    }
    return _backgroundImageView;
}

-(UIButton *)forgetPwdBtn
{
    if (!_forgetPwdBtn) {
        _forgetPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_forgetPwdBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
        [_forgetPwdBtn setTitleColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1] forState:UIControlStateNormal];
        _forgetPwdBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_forgetPwdBtn addTarget:self action:@selector(forgetPassword) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_forgetPwdBtn];
    }
    return _forgetPwdBtn;
}

@end
