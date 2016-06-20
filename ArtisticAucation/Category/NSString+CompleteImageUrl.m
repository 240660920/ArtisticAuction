//
//  NSString+CompleteImageUrl.m
//  ArtisticAucation
//
//  Created by xieran on 15/10/22.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "NSString+CompleteImageUrl.h"

//把imageUrl（后缀）和服务器url拼在一起
@implementation NSString (CompleteImageUrl)

-(NSString *)completeImageUrlString
{
    return [NSString stringWithFormat:@"%@%@",[ServerUrl stringByReplacingOccurrencesOfString:@"auction/" withString:@""],self];
}

@end
