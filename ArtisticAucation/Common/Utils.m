//
//  Utils.m
//  ArtisticAucation
//
//  Created by xieran on 15/9/6.
//  Copyright (c) 2015年 xieran. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+(UIBarButtonItem *)rightItemWithTitle:(NSString *)title target:(id)target selector:(SEL)selector
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 55, 40);
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:RedColor forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:179.0/255.0 green:18.0/255.0 blue:45.0/255.0 alpha:1] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor colorWithRed:153.0/255.0 green:15.0/255.0 blue:38.0/255.0 alpha:0.4] forState:UIControlStateDisabled];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    return item;
}

+(NSString *)translateArabNumberToChinese:(NSString *)arebic

{
    NSString *str = arebic;
    NSArray *arabic_numerals = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    NSArray *chinese_numerals = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"零"];
    NSArray *digits = @[@"个",@"十",@"百",@"千",@"万",@"十",@"百",@"千",@"亿",@"十",@"百",@"千",@"兆"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:chinese_numerals forKeys:arabic_numerals];
    
    NSMutableArray *sums = [NSMutableArray array];
    for (int i = 0; i < str.length; i ++) {
        NSString *substr = [str substringWithRange:NSMakeRange(i, 1)];
        NSString *a = [dictionary objectForKey:substr];
        NSString *b = digits[str.length -i-1];
        NSString *sum = [a stringByAppendingString:b];
        if ([a isEqualToString:chinese_numerals[9]])
        {
            if([b isEqualToString:digits[4]] || [b isEqualToString:digits[8]])
            {
                sum = b;
                if ([[sums lastObject] isEqualToString:chinese_numerals[9]])
                {
                    [sums removeLastObject];
                }
            }else
            {
                sum = chinese_numerals[9];
            }
            
            if ([[sums lastObject] isEqualToString:sum])
            {
                continue;
            }
        }
        
        [sums addObject:sum];
    }
    
    NSString *sumStr = [sums  componentsJoinedByString:@""];
    NSString *chinese = [sumStr substringToIndex:sumStr.length-1];
    if (arebic.intValue >= 10 && arebic.intValue <= 19) {
        chinese = [chinese substringFromIndex:1];
    }
    return chinese;
}

+(BOOL)isPhoneValue:(NSString *)phone
{
    NSString *regex = @"^[1][3578][0-9]{9}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if (![predicate evaluateWithObject:[phone stringByReplacingOccurrencesOfString:@"-" withString:@""]]) {
        return NO;
    }
    return YES;
}


@end
