//
//  NSArray+StringSeparateByComma.m
//  ArtisticAucation
//
//  Created by xieran on 15/10/31.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "NSArray+StringSeparateByComma.h"

@implementation NSArray (StringSeparateByComma)

-(NSString *)stringSeparateBySymbol:(NSString *)separatorSymbol
{
    NSMutableString *appendStr = [[NSMutableString alloc]init];
    for (int i = 0; i < self.count; i++) {
        NSString *str = self[i];
        [appendStr appendString:str];
        [appendStr appendString:separatorSymbol];
    }
    return [appendStr substringToIndex:appendStr.length - 1];
}

@end
