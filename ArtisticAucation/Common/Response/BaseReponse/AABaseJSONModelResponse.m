//
//  JSONModelResponse.m
//  ArtisticAucation
//
//  Created by xieran on 15/9/21.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "AABaseJSONModelResponse.h"

@implementation AAJSONModelResponseResultModel

+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end

@implementation AABaseJSONModelResponse

+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
