//
//  CommonRequests.m
//  ArtisticAucation
//
//  Created by xieran on 15/10/23.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "CommonRequests.h"
#import "AABaseJSONModelResponse.h"

@implementation CommonRequests

+(void)itemPreferenceRequestWithModel:(id)model
                              itemType:(ItemType )itemType
                        preferenceType:(PreferenceType)preferenceType
                        viewController:(UIViewController *)controller
                                button:(UIButton *)button
{
    if ([UserInfo sharedInstance].loginType == kLoginTypeTraveller) {
        [controller showLoginAlert];
        return;
    }
    
    
    
    
    
    NSString *api;
    __block NSInteger titleCount;
    NSString *itemId;
    NSString *idKey;
    NSString *type;
    NSString *countKey;
    
    switch (itemType) {
        case kItemAgency:
            api = @"company/modifyCompany";
            idKey = @"aid";
            break;
        case kItemSpecialPerformance:
            api = @"company/modifyOccasion";
            idKey = @"oid";
            break;
        case kItemAucationItem:
            api = @"company/modifyCommodity";
            idKey = @"cid";
            break;
        default:
            break;
    }
    
    if (preferenceType == kPreferenceTypeLike) {
        type = @"5";
        countKey = @"likeTotals";
    }
    else if (preferenceType == kPreferenceTypeCollect){
        type = @"3";
        countKey = @"collectTotals";
    }
    
    /*count*/
    titleCount = [[model valueForKeyPath:countKey] intValue];
    if (!button.selected) {
        titleCount++;
    }
    else{
        titleCount--;
    }
    [model setValue:[NSString stringWithFormat:@"%ld",(long)titleCount] forKeyPath:countKey];
    /**/
    
    itemId = [model valueForKeyPath:idKey];
    

    
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"userid"] = [UserInfo sharedInstance].userId;
    params[idKey] = itemId;
    params[@"type"] = type;
    params[@"append"] = button.selected ? @"false" : @"true";
    
    [HttpManager requestWithAPI:api params:params requestMethod:@"POST" completion:^(ASIFormDataRequest *request) {
        
        NSLog(@"%@",request.responseString);
        
    } failed:^(ASIFormDataRequest *request) {

    }];
    

    [[NSNotificationCenter defaultCenter]postNotificationName:ItemPreferenceStateChanged object:@{@"itemType" : [NSString stringWithFormat:@"%ld",(long)itemType] , @"state" : [NSString stringWithFormat:@"%ld",(long)!button.selected] , @"itemId" : itemId , @"preferenceType" : [NSString stringWithFormat:@"%ld",(long)preferenceType] , @"count" : [NSString stringWithFormat:@"%ld",(long)titleCount]}];
}


@end
