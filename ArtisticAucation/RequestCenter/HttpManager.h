//
//  HttpManager.h
//  ArtisticAucation
//
//  Created by Haley on 15/9/8.
//  Copyright (c) 2015年 xieran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

typedef void(^RequestCompletionBlock)(ASIFormDataRequest *request);
typedef void(^RequestFailedBlock)(ASIFormDataRequest *request);

@interface HttpManager : NSObject {
    @private
    NSOperationQueue   *_operationQueue;
    NSDictionary       *_apiDictionary;
}

/** 
 HttpManager的单例
 @return     HttpManager的静态实例
 */
+ (HttpManager *)sharedInstance;

/** 
 发起一个http请求，并返回该请求实例

 @param 	api 	请求接口
 @param 	params 	请求参数，key-value形式
 @param 	requestMethod 	http请求方法
 @param 	aCompletionBlock 	请求成功后的回调block
 @param 	aFailedBlock 	请求失败后的回调block
 @return     返回http请求对象
 @see        sslRequestWithAPI:params:requestMethod:completion:failed:
 */
+ (ASIFormDataRequest *)requestWithAPI:(NSString *)api
                                params:(NSDictionary *)params
                         requestMethod:(NSString *)requestMethod
                            completion:(RequestCompletionBlock)aCompletionBlock
                                failed:(RequestFailedBlock)aFailedBlock;

/** 
 发起一个https请求，并返回该请求实例
 
 @param 	api 	请求接口
 @param 	params 	请求参数，key-value形式
 @param 	requestMethod 	http请求方法
 @param 	aCompletionBlock 	请求成功后的回调block
 @param 	aFailedBlock 	请求失败后的回调block
 @return     返回http请求对象
 @see        requestWithAPI:params:requestMethod:completion:failed:
 */
+ (ASIFormDataRequest *)sslRequestWithAPI:(NSString *)api
                                   params:(NSDictionary *)params 
                            requestMethod:(NSString *)requestMethod 
                               completion:(RequestCompletionBlock)aCompletionBlock
                                   failed:(RequestFailedBlock)aFailedBlock;

// 同步方式请求
+ (ASIFormDataRequest *)syncRequestWithAPI:(NSString *)api
                                    params:(NSDictionary *)params
                             requestMethod:(NSString *)requestMethod;

@end
