//
//  AuctionHallCurrentItemModel.m
//  ArtisticAuction
//
//  Created by xieran on 2017/5/18.
//  Copyright © 2017年 xieran. All rights reserved.
//

#import "AuctionHallCurrentItemModel.h"

@implementation AuctionHallItemIntrolModel

@end







@implementation AuctionHallCurrentItemOccasionModel

@end

@implementation AuctionHallCurrentItemDataModel

+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{@"analyse" : @"description" ,
                                                                 @"occasion" : @"occname",
                                                                 @"userInfo" : @"phoneNum"}];
}

-(NSString *)phone
{
    if (_phone) {
        return _phone;
    }
    else if ([self.userInfo componentsSeparatedByString:@"&"].count > 0) {
        NSString *ph = [self.userInfo componentsSeparatedByString:@"&"][0];
        _phone = [ph copy];
    }
    return _phone ? _phone : @"";
}

@end

@implementation AuctionHallCurrentItemModel

+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{@"data" : @"msg" , @"index" : @"number"}];
}

@end
