//
//  NSString+Regex.m
//  ArtisticAuction
//
//  Created by xieran on 2018/2/4.
//  Copyright © 2018年 xieran. All rights reserved.
//

#import "NSString+Regex.h"

@implementation NSString (Regex)

-(BOOL)isValidPhoneNum{
    NSString *regex = @"^[1][3578][0-9]{9}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if (![predicate evaluateWithObject:[self stringByReplacingOccurrencesOfString:@"-" withString:@""]]) {
        return NO;
    }
    return YES;
}

@end
