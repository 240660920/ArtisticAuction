//
//  AgencyItemResponse.h
//  ArtisticAucation
//
//  Created by xieran on 15/10/23.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "AgencyBaseResponse.h"
#import "AucationListResponse.h"

@interface AgencyItem : AgencyBaseResponse

@property(nonatomic,copy)NSString *adescription;
@property(nonatomic,copy)NSString *count;
@property(nonatomic,copy)NSString *collectType;
@property(nonatomic,copy)NSString *likeType;
@property(nonatomic,copy)NSString *collectTotals;
@property(nonatomic,copy)NSString *likeTotals;
@property(nonatomic,copy)NSString *aid;
@property(nonatomic,copy)NSString *imgurl;
@property(nonatomic,retain)NSArray<AucationDataModel> *listOccasion;

@end

@interface AgencyItemResponse : AgencyBaseResponse

@property(nonatomic,retain)AgencyItem *data;

@end
