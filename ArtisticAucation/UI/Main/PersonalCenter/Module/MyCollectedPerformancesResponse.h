//
//  MyCollectedPerformancesResponse.h
//  ArtisticAucation
//
//  Created by xieran on 15/10/26.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "AucationBaseResponse.h"

@protocol MyCollectedPerformanceItem <NSObject>
@end

@interface MyCollectedPerformancesDetail : AucationBaseResponse

@property(nonatomic,copy)NSString *endtime;
@property(nonatomic,copy)NSString *starttime;
@property(nonatomic,copy)NSString *count;
@property(nonatomic,copy)NSString *status;
@property(nonatomic,copy)NSString *collectTotals;
@property(nonatomic,copy)NSString *odescription;
@property(nonatomic,copy)NSString *aid;
@property(nonatomic,copy)NSString *likeTotals;
@property(nonatomic,copy)NSString *collectType;
@property(nonatomic,copy)NSString *oid;
@property(nonatomic,copy)NSString *likeType;
@property(nonatomic,copy)NSString *remindType;
@property(nonatomic,copy)NSString *imgurl;
@property(nonatomic,copy)NSString *state;

@end


@interface MyCollectedPerformanceItem : AucationBaseResponse

@property(nonatomic,copy)NSString *createtime;
@property(nonatomic,copy)NSString *sid;
@property(nonatomic,retain)NSDictionary *commodity;
@property(nonatomic,copy)NSString *payment;
@property(nonatomic,retain)NSDictionary *company;
@property(nonatomic,retain)MyCollectedPerformancesDetail *occasion;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *caseid;

@end


@interface MyCollectedPerformancesResponse : AucationBaseResponse

@property(nonatomic,retain)NSArray<MyCollectedPerformanceItem> *data;

@end
