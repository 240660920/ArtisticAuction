//
//  Utils.h
//  ArtisticAucation
//
//  Created by xieran on 15/9/6.
//  Copyright (c) 2015年 xieran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIBarButtonItem+CustomButton.h"
@interface Utils : NSObject

+(UIBarButtonItem *)rightItemWithTitle:(NSString *)title target:(id)target selector:(SEL)selector;

+(NSString *)translateArabNumberToChinese:(NSString *)arebic;

+(BOOL)isPhoneValue:(NSString *)phone;

@end
