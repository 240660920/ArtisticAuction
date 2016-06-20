//
//  AucationListResponse.m
//  ArtisticAucation
//
//  Created by xieran on 15/10/22.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "AucationListResponse.h"

@implementation AucationDataModel

+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"enterTotals" : @"likeTotals" , @"praiseType" : @"likeType" , @"odescription" : @"occasionName" , @"endtime" : @"predisplayStartTime"}];
}

+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

-(void)setOccasionName:(NSString *)occasionName
{
    if (occasionName.length > 0 && [occasionName rangeOfString:@"第"].length > 0 && [occasionName rangeOfString:@"场"].length > 0) {
        NSUInteger startLocation = 0;
        NSUInteger endLocation = occasionName.length -1;
        NSScanner *scanner = [NSScanner scannerWithString:occasionName];
        while (![scanner isAtEnd]) {
            if ([scanner scanString:@"第" intoString:nil]) {
                startLocation = scanner.scanLocation;
            }
            else{
                scanner.scanLocation++;
            }
        }
        NSString *indexString = [occasionName substringWithRange:NSMakeRange(startLocation, endLocation - startLocation)];
        NSString *regex = @"^\\d+$";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        if (![predicate evaluateWithObject:indexString]) {
            _occasionName = [occasionName copy];
            return;
        }
        _occasionName = [occasionName stringByReplacingOccurrencesOfString:indexString withString:[Utils translateArabNumberToChinese:indexString]];
    }
    else{
        _occasionName = [occasionName copy];
    }
}

@end


@implementation LotResponse

+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"description" : @"desc" , @"typeid" : @"type" , @"lookcount" : @"likeTotals" , @"collectcount" : @"collectTotals" , @"praiseType" : @"likeType" , @"image" : @"images" , @"cname" : @"name" , @"occname" : @"occasion"}];
}

+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

-(id)initWithMyAucationDetailItem:(MyCollcetedLotDetailItem *)myCollectedDetailItem
{
    if (self = [super init]) {
        self.endprice = myCollectedDetailItem.endprice;
        self.startprice = myCollectedDetailItem.startprice;
        //        self.upprice = myCollectedDetailItem.upprice;
        self.delaytime = myCollectedDetailItem.delaytime;
        self.agencyName = myCollectedDetailItem.agencyName;
        self.desc = myCollectedDetailItem.descString;
        self.features = myCollectedDetailItem.features;
        self.images = myCollectedDetailItem.images;
        self.status = myCollectedDetailItem.status;
        self.aid = myCollectedDetailItem.aid;
        self.cid = myCollectedDetailItem.cid;
        
    }
    return self;
}

@end



@implementation AucationListResponse

+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
