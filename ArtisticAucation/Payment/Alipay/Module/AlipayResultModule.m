//
//  AlipayResultModule.m
//  ArtisticAucation
//
//  Created by xieran on 15/10/15.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "AlipayResultModule.h"
#import "base64.h"
@implementation AlipayResultModule

-(id)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init]) {
        NSInteger resultCode = [dic[@"resultStatus"] intValue];
        self.resultCode = resultCode;
        
        __block NSString *successString;
        __block NSString *sign;
        
        NSArray *params = [dic[@"result"] componentsSeparatedByString:@"&"];
        [params enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *key = [obj componentsSeparatedByString:@"="][0];
            NSString *value = [obj stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@=",key] withString:@""];
            
            if ([key isEqualToString:@"success"]) {
                successString = [value stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            }
            else if ([key isEqualToString:@"sign"]){
                sign = [value stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            }
        }];
        
        self.sign = sign;
        
        self.orderInfo = [dic[@"result"] componentsSeparatedByString:@"&sign_type"][0];
    }
    return self;
}

@end
