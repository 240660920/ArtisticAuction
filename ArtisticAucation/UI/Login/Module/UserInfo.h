//
//  UserInfo.h
//  ArtisticAucation
//
//  Created by xieran on 15/9/6.
//  Copyright (c) 2015年 xieran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Define.h"
#import "LoginResponse.h"

@interface UserInfo : NSObject

+(UserInfo *)sharedInstance;

+(void)clearUserInfo;

+(void)saveUserId:(NSString *)userid username:(NSString *)username passwordMd5:(NSString *)passwordMd5;

-(void)initContactInfo:(LoginResponse *)loginResponse;

@property(nonatomic,copy)NSString *userId;
@property(nonatomic,copy)NSString *password;
@property(nonatomic,copy)NSString *realName;
@property(nonatomic,copy)NSString *phone;    //登录的手机号码
@property(nonatomic,copy)NSString *performanceName; //开设的专场的名字
@property(nonatomic,retain)NSMutableArray *contactInfos;
@property(nonatomic,retain)NSMutableArray *occasionList;
@property(nonatomic,copy)NSString *agencyName;
@property(nonatomic,copy)NSString *aid;
@property(nonatomic,retain)UIImage *agencyImage;
@property(nonatomic,assign)IdentityCertifyState identifyCertifyState; //实名认证

@property(nonatomic,assign)LoginType loginType;

@end
