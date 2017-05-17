//
//  NSMutableArray+AddHallViewModel.m
//  ArtisticAuction
//
//  Created by xieran on 2017/5/17.
//  Copyright © 2017年 xieran. All rights reserved.
//

#import "NSMutableArray+AddHallViewModel.h"

@implementation NSMutableArray (AddHallViewModel)

-(void)addViewModel:(id)data
{
    [self insertObject:data atIndex:0];
}

@end
