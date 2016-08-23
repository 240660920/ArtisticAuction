//
//  LaunchAdArchieveModule.m
//  ArtisticAuction
//
//  Created by xieran on 16/8/23.
//  Copyright © 2016年 xieran. All rights reserved.
//

#import "LaunchAdArchieveModule.h"

@implementation LaunchAdArchieveModule

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.img_4inch = [aDecoder decodeObjectForKey:@"img_4inch"];
        self.img_47inch = [aDecoder decodeObjectForKey:@"img_47inch"];
        self.img_55inch = [aDecoder decodeObjectForKey:@"img_55inch"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.img_4inch forKey:@"img_4inch"];
    [aCoder encodeObject:self.img_47inch forKey:@"img_47inch"];
    [aCoder encodeObject:self.img_55inch forKey:@"img_55inch"];
}

@end
