//
//  WeixinPayModule.h
//  ArtisticAucation
//
//  Created by xieran on 15/11/28.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeixinPayModule : NSObject

@property(nonatomic,copy)NSString *body;
@property(nonatomic,copy)NSString *caseId;
@property(nonatomic,copy)NSString *totalFee;
@property(nonatomic,copy)NSString *username;
@property(nonatomic,copy)NSString *phoneNum;
@property(nonatomic,copy)NSString *address;

@end
