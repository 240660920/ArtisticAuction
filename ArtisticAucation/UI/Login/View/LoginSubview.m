//
//  LoginSubview.m
//  ArtisticAucation
//
//  Created by xieran on 15/9/12.
//  Copyright (c) 2015年 xieran. All rights reserved.
//

#import "LoginSubview.h"
#import "WXApi.h"

@interface LoginSubview ()<UITextFieldDelegate>

@property(nonatomic,retain)UIView *blackRoundedView;

@end

@implementation LoginSubview


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    self.layer.masksToBounds = YES;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextMoveToPoint(context, 0, 44);
    CGContextAddLineToPoint(context, rect.size.width, 44);
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        CGContextMoveToPoint(context, rect.size.width / 2, rect.size.height);
        CGContextAddLineToPoint(context, rect.size.width / 2, rect.size.height - 44);
    }
    CGContextStrokePath(context);

    

    
    [self.usernameTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.equalTo(@44);
    }];
    
    [self.passwordTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.usernameTf.mas_bottom);
        make.height.equalTo(@44);
    }];
    
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppInstalled]) {
        
        [self.weixinLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(self);
            make.height.equalTo(@44);
            make.right.equalTo(self.mas_centerX);
        }];
        
        [self.blackRoundedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.equalTo(@44);
        }];
        
        [self.travelerLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(self);
            make.height.equalTo(@44);
            make.left.equalTo(self.mas_centerX);
        }];
    }
    else{
        [self.blackRoundedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.bottom.equalTo(self);
            make.width.equalTo(self).multipliedBy(0.5);
            make.height.equalTo(@44);
        }];
        
        [self.travelerLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.bottom.equalTo(self);
            make.height.equalTo(@44);
        }];
    }
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.bottom.equalTo(self.travelerLoginButton.mas_top).offset(-25);
        make.right.equalTo(self.mas_centerX).offset(-5);
        make.height.equalTo(@44);
    }];
    
    [self.registButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.loginButton.mas_right).offset(10);
        make.bottom.equalTo(self.travelerLoginButton.mas_top).offset(-25);
        make.right.equalTo(self);
        make.height.equalTo(@44);
    }];
    
}

#pragma mark Delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.usernameTf && range.length == 1) {
        self.passwordTf.text = nil;
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
        [self.delegate textFieldShouldReturn:textField];
    }
    
    return YES;
}

#pragma mark Private Methods
-(void)login
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(loginWithUsername:password:)]) {
        [self.delegate loginWithUsername:self.usernameTf.text password:self.passwordTf.text];
    }
}

#pragma mark Properties
-(UITextField *)usernameTf
{
    if (!_usernameTf) {
        _usernameTf = [[UITextField alloc]init];
        UIImageView *leftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"username_left_icon"]];
        leftView.contentMode = UIViewContentModeCenter;
        leftView.frame = CGRectMake(0, 0, 30, 44);
        _usernameTf.delegate = (id)self;
        _usernameTf.leftView = leftView;
        _usernameTf.leftViewMode = UITextFieldViewModeAlways;
        _usernameTf.font = [UIFont systemFontOfSize:14];
        _usernameTf.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
        _usernameTf.placeholder = @"手机号";
        [_usernameTf setValue:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
        [_usernameTf setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
        if ([[NSUserDefaults standardUserDefaults]stringForKey:@"username"].length > 0) {
            [_usernameTf setText:[[NSUserDefaults standardUserDefaults] stringForKey:@"username"]];
        }
        _usernameTf.returnKeyType = UIReturnKeyDone;
        _usernameTf.keyboardType = UIKeyboardTypeNumberPad;
        _usernameTf.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self addSubview:_usernameTf];
    }
    return _usernameTf;
}

-(UITextField *)passwordTf
{
    if (!_passwordTf) {
        _passwordTf = [[UITextField alloc]init];
        UIImageView *leftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"password_left_icon"]];
        leftView.contentMode = UIViewContentModeCenter;
        leftView.frame = CGRectMake(0, 0, 30, 44);
        _passwordTf.delegate = (id)self;
        _passwordTf.secureTextEntry = YES;
        _passwordTf.leftView = leftView;
        _passwordTf.leftViewMode = UITextFieldViewModeAlways;
        _passwordTf.font = [UIFont systemFontOfSize:14];
        _passwordTf.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
        _passwordTf.placeholder = @"密码";
        [_passwordTf setValue:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
        [_passwordTf setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
        _passwordTf.returnKeyType = UIReturnKeyDone;
        _passwordTf.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self addSubview:_passwordTf];
    }
    return _passwordTf;
}

-(UIButton *)loginButton
{
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginButton setBackgroundImage:[[UIImage imageNamed:@"red_button_nor"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
        [_loginButton setBackgroundImage:[[UIImage imageNamed:@"red_button_sel"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateHighlighted];
        [_loginButton setBackgroundImage:[[UIImage imageNamed:@"red_button_disable"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateDisabled];
        
        _loginButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        
        [_loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_loginButton];
    }
    return _loginButton;
}

-(UIButton *)registButton
{
    if (!_registButton) {
        _registButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _registButton.backgroundColor = [UIColor blackColor];
        
        [_registButton setTitle:@"注册" forState:UIControlStateNormal];
        _registButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        _registButton.layer.masksToBounds = YES;
        _registButton.layer.cornerRadius = 3;
        [_registButton addTarget:self.delegate action:@selector(regist) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_registButton];
    }
    return _registButton;
}

-(UIButton *)weixinLoginButton
{
    if (!_weixinLoginButton) {
        _weixinLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _weixinLoginButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_weixinLoginButton setTitleColor:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1] forState:UIControlStateNormal];
        [_weixinLoginButton setTitle:@"微信登录" forState:UIControlStateNormal];
        [_weixinLoginButton addTarget:self.delegate action:@selector(weixinLogin) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_weixinLoginButton];
    }
    return _weixinLoginButton;
}

-(UIButton *)travelerLoginButton
{
    if (!_travelerLoginButton) {
        _travelerLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _travelerLoginButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_travelerLoginButton setTitleColor:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1] forState:UIControlStateNormal];
        [_travelerLoginButton setTitle:@"游客登录" forState:UIControlStateNormal];
        [_travelerLoginButton addTarget:self.delegate action:@selector(travelerLogin) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_travelerLoginButton];
    }
    return _travelerLoginButton;
}

-(UIView *)blackRoundedView
{
    if (!_blackRoundedView) {
        _blackRoundedView = [[UIView alloc]init];
        _blackRoundedView.backgroundColor = [UIColor clearColor];
        _blackRoundedView.layer.masksToBounds = YES;
        _blackRoundedView.layer.cornerRadius = 3;
        _blackRoundedView.layer.borderWidth = 1;
        _blackRoundedView.layer.borderColor = [UIColor blackColor].CGColor;
        _blackRoundedView.userInteractionEnabled = NO;
        [self addSubview:_blackRoundedView];
    }
    return _blackRoundedView;
}

@end
