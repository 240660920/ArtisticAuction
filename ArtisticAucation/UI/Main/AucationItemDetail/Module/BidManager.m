//
//  BidManager.m
//  ArtisticAucation
//
//  Created by xieran on 16/1/28.
//  Copyright © 2016年 xieran. All rights reserved.
//

#import "BidManager.h"

BidManager *bidManager;

@interface BidManager ()

@property(nonatomic,copy)NSString *price;
@property(nonatomic,copy)NSString *oid;
@property(nonatomic,copy)NSString *cid;

@end

@implementation BidManager

+(BidManager *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bidManager = [[BidManager alloc]init];
    });
    return bidManager;
}

-(void)preDisplayBid:(NSString *)price oid:(NSString *)oid cid:(NSString *)cid
{
    self.price = price;
    self.oid = oid;
    self.cid = cid;
    
    if ([self showAlertIfNeeded]) {
        return;
    }
    
    
    NSString *phone = [[NSUserDefaults standardUserDefaults]objectForKey:BidPhoneKey];
    NSString *username = [[NSUserDefaults standardUserDefaults]objectForKey:BidUsernameKey];
    
    if ([UserInfo sharedInstance].loginType == kLoginTypePhone) {
        phone = [UserInfo sharedInstance].phone;
    }

    [self bidWithPhone:phone userName:username];
}

-(BOOL)showAlertIfNeeded
{
    BOOL shouldShow = NO;
    

    if (self.phone.length == 0 || self.userName.length == 0){
        shouldShow = YES;
        [self showInputNameAndPhoneAlert];
    }
    else{
        [self bidWithPhone:self.phone userName:self.userName];
    }
    
    return shouldShow;
}

-(void)showInputNameAndPhoneAlert
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"领取号牌" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    
    UITextField *tf0 = [alert textFieldAtIndex:0];
    tf0.keyboardType = UIKeyboardTypeNamePhonePad;
    tf0.placeholder = @"请输入姓名";
    tf0.text = self.userName;
    
    UITextField *tf1 = [alert textFieldAtIndex:1];
    tf1.keyboardType = UIKeyboardTypeNumberPad;
    tf1.placeholder = @"请输入手机号码";
    tf1.secureTextEntry = NO;
    tf1.text = self.phone;
    
    [alert show];
    [alert handleClickedButton:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            if (![Utils isPhoneValue:tf1.text]) {
                [[UIApplication sharedApplication].keyWindow showHudAndAutoDismiss:@"手机号格式不正确"];
            }
            else if (tf1.text.length == 0){
                [[UIApplication sharedApplication].keyWindow showHudAndAutoDismiss:@"请输入手机号码"];
            }
            else if (tf0.text.length == 0){
                [[UIApplication sharedApplication].keyWindow showHudAndAutoDismiss:@"请输入姓名"];
            }
            else{
                self.userName = tf0.text;
                self.phone    = tf1.text;
                
                [[NSUserDefaults standardUserDefaults]setObject:tf0.text forKey:BidUsernameKey];
                [[NSUserDefaults standardUserDefaults]setObject:tf1.text forKey:BidPhoneKey];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                [[UIApplication sharedApplication].keyWindow showHudAndAutoDismiss:@"领取成功"];
            }
        }
    }];
}

-(void)bidWithPhone:(NSString *)phone userName:(NSString *)userName
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"cid"] = self.cid;
    params[@"phone"] = phone;
    params[@"username"] = userName;
    params[@"price"] = self.price;
    if ([UserInfo sharedInstance].userId.length > 0) {
        params[@"userid"] = [UserInfo sharedInstance].userId;
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:phone forKey:BidPhoneKey];
    [[NSUserDefaults standardUserDefaults]setObject:userName forKey:BidUsernameKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    
    [HttpManager requestWithAPI:@"company/userBeforeBid" params:params requestMethod:@"POST" completion:^(ASIFormDataRequest *request) {
        
        AABaseJSONModelResponse *response = [[AABaseJSONModelResponse alloc]initWithString:request.responseString error:nil];
        if (response.result.resultCode.intValue == 0) {
            [[UIApplication sharedApplication].keyWindow showHudAndAutoDismiss:@"出价成功"];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"predisplayBidSuccess" object:@{@"cid" : self.cid , @"price" : self.price}];
        }
        else{
            [[UIApplication sharedApplication].keyWindow showHudAndAutoDismiss:response.result.msg];
        }
        
    } failed:^(ASIFormDataRequest *request) {
        [[UIApplication sharedApplication].keyWindow showHudAndAutoDismiss:NetworkRequestErrorDomain];
    }];
}


-(NSString *)userName
{
    if (!_userName) {
        _userName = [[NSUserDefaults standardUserDefaults]objectForKey:BidUsernameKey];
    }
    return _userName;
}

-(NSString *)phone
{
    if ([UserInfo sharedInstance].phone) {
        _phone = [[UserInfo sharedInstance].phone copy];
    }
    else{
        _phone = [[NSUserDefaults standardUserDefaults]objectForKey:BidPhoneKey];
    }
    return _phone;
}

@end
