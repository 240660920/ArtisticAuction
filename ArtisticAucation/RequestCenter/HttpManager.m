//
//  HttpManager.h
//  ArtisticAucation
//
//  Created by Haley on 15/9/8.
//  Copyright (c) 2015年 xieran. All rights reserved.
//

#import "HttpManager.h"
static HttpManager *instance = nil;
	
@implementation HttpManager

+ (HttpManager *)sharedInstance {
    @synchronized(self) {
        if (instance == nil) {
            instance = [[HttpManager alloc] init];
        }
    }
    return instance;
}

- (id)init {
    if (self = [super init]) {
        _operationQueue = [[NSOperationQueue alloc] init];
        _operationQueue.maxConcurrentOperationCount = 2;
        
        _apiDictionary = [[NSDictionary alloc] init];
    }
    return self;
}

+ (NSString *)urlForAPI:(NSString *)api {
    if (api.length == 0) {
        return nil;
    }else{
        NSString *urlString = [NSString stringWithFormat:@"%@%@", ServerUrl, api];
        return urlString;
    }
}

+ (ASIFormDataRequest *)requestWithAPI:(NSString *)api
                                params:(NSDictionary *)params 
                         requestMethod:(NSString *)requestMethod 
                            completion:(RequestCompletionBlock)aCompletionBlock
                                failed:(RequestFailedBlock)aFailedBlock {
    
    NSString *url = [self urlForAPI:api];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    __weak ASIFormDataRequest *weakRequest = request;
    for (NSString *key in [params allKeys]) {
        [request addPostValue:[params objectForKey:key] forKey:key];
    }
	[request setRequestMethod:requestMethod];
	[request setTimeOutSeconds:15];
	[request setCompletionBlock:^{
        aCompletionBlock(weakRequest);
    }];
	[request setFailedBlock:^{
        aFailedBlock(weakRequest);
    }];

	[request startAsynchronous];

    NBLog(@"\nRequestURL:\n%@\nParams:\n%@\n", url, params);
    return request;
}

+ (ASIFormDataRequest *)sslRequestWithAPI:(NSString *)api
                                   params:(NSDictionary *)params 
                            requestMethod:(NSString *)requestMethod 
                               completion:(RequestCompletionBlock)aCompletionBlock
                                   failed:(RequestFailedBlock)aFailedBlock {
    
    NSURL *url = [NSURL URLWithString:[self urlForAPI:api]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    __weak ASIFormDataRequest *weakRequest = request;
    [request setRequestMethod:requestMethod];
    [request setTimeOutSeconds:30];
    [request setCompletionBlock:^{
        aCompletionBlock(weakRequest);
    }];
    [request setFailedBlock:^{
        aFailedBlock(weakRequest);
    }];
    [request setValidatesSecureCertificate:NO];
    
    for (NSString *key in [params allKeys]) {
        [request addPostValue:[params objectForKey:key] forKey:key];
    }
    [request startAsynchronous];
    return request;
}

+ (ASIFormDataRequest *)syncRequestWithAPI:(NSString *)api
                                    params:(NSDictionary *)params
                             requestMethod:(NSString *)requestMethod {
    
    NSURL *url = [NSURL URLWithString:[self urlForAPI:api]];
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:requestMethod];
    [request setTimeOutSeconds:60];

    for (NSString *key in [params allKeys]) {
        id obj = [params objectForKey:key];
        if ([obj isKindOfClass:[NSData class]]) {
            [request addData:obj forKey:key];
			NBLog(@"%@=%@", key, obj);
        }
		else if ([obj isKindOfClass:[NSArray class]]) {
			__block NSMutableString *string = [NSMutableString string];
			NSArray *array = (NSArray *)obj;
			[array enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
				if ([string length] == 0) {
					[string appendString:object];
				}
				else{
					[string appendFormat:@",%@", object];
				}
			}];
			NBLog(@"%@=%@",key,string);
			[request addPostValue:string forKey:key];
		}
        else {
			NBLog(@"%@=%@", key, obj);
            [request addPostValue:obj forKey:key];
        }
    }
    
    [request startSynchronous];
    
    NBLog(@"\n%@\nresponse status:%d", url, request.responseStatusCode);
    NBLog(@"\n%@", request.requestHeaders);
	NBLog(@"\n%@", request.responseString);
    return request;
}

@end
