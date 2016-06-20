//
//  UserInfo.m
//  ArtisticAucation
//
//  Created by xieran on 15/9/6.
//  Copyright (c) 2015年 xieran. All rights reserved.
//

#import "UserInfo.h"
#import <objc/runtime.h>
#import "AddressInfo.h"

UserInfo *userInfo;

@implementation UserInfo

+(UserInfo *)sharedInstance
{
    if (!userInfo) {
        userInfo = [[UserInfo alloc]init];
        userInfo.userId = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
        userInfo.occasionList = [[NSMutableArray alloc]init];
    }
    return userInfo;
}

+(void)clearUserInfo
{
    [UserInfo sharedInstance].userId = nil;
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userid"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+(void)saveUserId:(NSString *)userid username:(NSString *)username passwordMd5:(NSString *)passwordMd5
{
    [[NSUserDefaults standardUserDefaults]setObject:userid forKey:@"userid"];
    [[NSUserDefaults standardUserDefaults]setObject:username forKey:@"username"];
    [[NSUserDefaults standardUserDefaults]setObject:passwordMd5 forKey:@"password"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(void)initContactInfo:(LoginResponse *)loginResponse
{
    NSArray *names = loginResponse.data.contactNames;
    NSArray *phoneNums = loginResponse.data.contactPhoneNums;
    NSArray *addresses = loginResponse.data.contactAddresses;
    
    _contactInfos = [[NSMutableArray alloc]init];
    for (int i = 0; i < names.count; i++) {
        AddressInfo *info = [[AddressInfo alloc]init];
        info.name = names[i];
        info.phoneNum = phoneNums[i];
        info.address = addresses[i];
        
        [_contactInfos addObject:info];
    }
}

-(void)setLoginType:(LoginType)loginType
{
    [[NSUserDefaults standardUserDefaults]setObject:@(loginType) forKey:@"LoginType"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(LoginType )loginType
{
    return [[NSUserDefaults standardUserDefaults]integerForKey:@"LoginType"];
}

@end
