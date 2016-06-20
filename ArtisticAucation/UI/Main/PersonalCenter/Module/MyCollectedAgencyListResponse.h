//
//  MyFavoritesResponse.h
//  ArtisticAucation
//
//  Created by xieran on 15/10/20.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "AgencyBaseResponse.h"

@protocol MyCollectedAgencyDataModel <NSObject>

@end

@interface MyCollectedAgencyDetailItem : AgencyBaseResponse

@property(nonatomic,copy)NSString *aname;
@property(nonatomic,copy)NSString *likeTotals;
@property(nonatomic,copy)NSString *likeType;
@property(nonatomic,copy)NSString *collectTotals;
@property(nonatomic,copy)NSString *collectType;
@property(nonatomic,copy)NSString *aid;

@end


@interface MyCollectedAgencyDataModel : AgencyBaseResponse

@property(nonatomic,copy)NSString *imageUrl; //后缀
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *startprice;
@property(nonatomic,copy)NSString *endprice;
@property(nonatomic,retain)NSNumber *lookcount;
@property(nonatomic,retain)NSNumber *collectcount;
@property(nonatomic,retain)MyCollectedAgencyDetailItem *company;

@end

@interface MyCollectedAgencyListResponse : AgencyBaseResponse

@property(nonatomic,retain)NSArray<MyCollectedAgencyDataModel> *data;

@end
