//
//  LoginSubview.h
//  ArtisticAucation
//
//  Created by xieran on 15/9/12.
//  Copyright (c) 2015年 xieran. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginViewDelegate <NSObject>

-(void)loginWithUsername:(NSString *)username password:(NSString *)password;
-(void)regist;
-(void)weixinLogin;
-(void)travelerLogin;

-(void)textFieldShouldReturn:(UITextField *)textField;

@end

@interface LoginSubview : UIView

@property(nonatomic,weak)id<LoginViewDelegate>delegate;
@property(nonatomic,strong)UITextField *passwordTf;
@property(nonatomic,strong)UITextField *usernameTf;
@property(nonatomic,strong)UIButton *loginButton;
@property(nonatomic,strong)UIButton *registButton;
@property(nonatomic,strong)UIButton *weixinLoginButton;
@property(nonatomic,strong)UIButton *travelerLoginButton;

@end
