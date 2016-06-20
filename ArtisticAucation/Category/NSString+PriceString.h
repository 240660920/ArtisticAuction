//
//  NSString+PriceString.h
//  ArtisticAucation
//
//  Created by xieran on 15/10/23.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (PriceString)

+(NSMutableAttributedString *)redPriceOfValue:(NSString *)priceValue;

+(NSMutableAttributedString *)redPriceOfValue:(NSString *)priceValue WithPromptString:(NSString *)prompt;
+(NSMutableAttributedString *)blackPriceOfValue:(NSString *)priceValue;

//+(NSString *)floatPriceString:(NSString *)priceValue;

@end
