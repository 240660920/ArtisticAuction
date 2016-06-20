//
//  NSString+random32.m
//  ArtisticAucation
//
//  Created by xieran on 15/11/19.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "NSString+randomString.h"

@implementation NSString (randomString)

+(NSString *)ret32bitString

{
    
    char data[32];
    
    for (int x = 0 ;x < 32; data[x++] = (char)('0' + (arc4random_uniform(9))));
    
    return [[NSString alloc] initWithBytes:data length:32 encoding:NSUTF8StringEncoding];
    
}

+(NSString *)ret12bitStringAppendTimeIntervalSince1970
{
    char data[22];
    
    for (int x = 0; x < 22; data[x++] = (char)('0' + arc4random_uniform(9)));
        
    NSString *randomString = [[NSString alloc]initWithBytes:data length:22 encoding:NSUTF8StringEncoding];
    
    return [NSString stringWithFormat:@"%@%.0f",randomString,[[NSDate date]timeIntervalSince1970]];
        
}

@end
