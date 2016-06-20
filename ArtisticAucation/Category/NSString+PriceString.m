//
//  NSString+PriceString.m
//  ArtisticAucation
//
//  Created by xieran on 15/10/23.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "NSString+PriceString.h"

@implementation NSString (PriceString)

//+(NSString *)floatPriceString:(NSString *)priceValue
//{
//    NSString *_priceValue = [priceValue mutableCopy];
//    if ([priceValue rangeOfString:@"."].length == 0) {
//        _priceValue = [NSString stringWithFormat:@"%@.00",priceValue];
//    }
//    if (_priceValue.length == 0 || _priceValue.floatValue == 0) {
//        _priceValue = @"0.00";
//    }
//    
//    return _priceValue;
//}

+(NSMutableAttributedString *)redPriceOfValue:(NSString *)priceValue
{
    NSString *_priceValue = [NSString stringWithFormat:@"%d",priceValue.intValue];
    
    UIFont *normalFont = [UIFont systemFontOfSize:16];
    UIColor *redColor = [UIColor colorWithRed:1 green:51.0/255.0 blue:51.0/255.0 alpha:1];
    

    
    NSMutableAttributedString *priceString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥ %@",_priceValue] attributes:@{NSFontAttributeName : normalFont , NSForegroundColorAttributeName : redColor}];
    
    
    return priceString;
}

+(NSMutableAttributedString *)redPriceOfValue:(NSString *)priceValue WithPromptString:(NSString *)prompt
{
    NSString *_priceValue = [NSString stringWithFormat:@"%d",priceValue.intValue];
    
    UIFont *normalFont = [UIFont systemFontOfSize:16];
    UIColor *redColor = [UIColor colorWithRed:1 green:51.0/255.0 blue:51.0/255.0 alpha:1];
        
    NSMutableAttributedString *promptAttrStr = [[NSMutableAttributedString alloc]initWithString:prompt attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14] , NSForegroundColorAttributeName : BlackColor}];
    
    NSMutableAttributedString *priceString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥ %@",_priceValue] attributes:@{NSFontAttributeName : normalFont , NSForegroundColorAttributeName : redColor}];
    
    [promptAttrStr appendAttributedString:priceString];
    
    return promptAttrStr;
}

+(NSMutableAttributedString *)blackPriceOfValue:(NSString *)priceValue
{
    NSString *_priceValue = [NSString stringWithFormat:@"%d",priceValue.intValue];
    
    UIFont *normalFont = [UIFont systemFontOfSize:16];
    UIColor *color = BlackColor;
    
    
    
    NSMutableAttributedString *priceString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥ %@",_priceValue] attributes:@{NSFontAttributeName : normalFont , NSForegroundColorAttributeName : color}];
    
    return priceString;
}

@end
