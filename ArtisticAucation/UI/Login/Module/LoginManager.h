//
//  LoginManager.h
//  ArtisticAucation
//
//  Created by xieran on 15/11/8.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeixinLoginResponse.h"

@interface LoginManager : NSObject

+(void)login:(LoginType)loginType autoLogin:(BOOL)autoLogin params:(NSMutableDictionary *)params successBlock:(void(^)(void))successBlock failedBlock:(void(^)(NSString *errorMsg))failedBlock;

@end
