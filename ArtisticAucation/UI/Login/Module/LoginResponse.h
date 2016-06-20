//
//  LoginResponse.h
//  ArtisticAucation
//
//  Created by xieran on 15/9/21.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "AABaseJSONModelResponse.h"
#import "AucationListResponse.h"

@interface LoginResponseDataModel : JSONModel

@property(nonatomic,copy)NSString *phone;  //登录的手机号码
@property(nonatomic,copy)NSString *userid;
@property(nonatomic,copy)NSString *realname;
@property(nonatomic,copy)NSString *realtype;
@property(nonatomic,copy)NSString *password;
@property(nonatomic,retain)NSMutableArray *contactAddresses;
@property(nonatomic,retain)NSMutableArray *contactPhoneNums; //资料里面的号码
@property(nonatomic,retain)NSMutableArray *contactNames;
@property(nonatomic,copy)NSString *occasionName;

@end

@interface LoginResponse : AABaseJSONModelResponse

@property(nonatomic,retain)LoginResponseDataModel *data;

@end
