//
//  PersonalInfo.m
//  ArtisticAucation
//
//  Created by xieran on 15/11/28.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "AddressInfo.h"

@implementation AddressInfo

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.phoneNum = [aDecoder decodeObjectForKey:@"phoneNum"];
        self.address = [aDecoder decodeObjectForKey:@"address"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_phoneNum forKey:@"phoneNum"];
    [aCoder encodeObject:_address forKey:@"address"];
}

@end
