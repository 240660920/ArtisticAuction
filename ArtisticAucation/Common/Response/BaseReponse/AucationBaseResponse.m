//
//  AucationBaseResponse.m
//  ArtisticAucation
//
//  Created by xieran on 15/11/1.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "AucationBaseResponse.h"

@implementation AucationBaseResponse

-(ItemType )itemType
{
    return kItemSpecialPerformance;
}

+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
