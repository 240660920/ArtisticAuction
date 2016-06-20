//
//  MyCollectedLotsListResponse.h
//  ArtisticAucation
//
//  Created by xieran on 15/10/26.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "AucationItemBaseResponse.h"

@class AucationDataModel;

@protocol MyCollectedLotItem <NSObject>
@end

@interface MyCollcetedLotDetailItem : AucationItemBaseResponse

@property(nonatomic,copy)NSString *holdprice;
@property(nonatomic,copy)NSString *partakecount;
@property(nonatomic,copy)NSString *status;
@property(nonatomic,copy)NSString *endprice;
@property(nonatomic,copy)NSString *aid;
@property(nonatomic,copy)NSString *agencyName;
@property(nonatomic,copy)NSString *cid;
@property(nonatomic,copy)NSString *delaytime;
@property(nonatomic,copy)NSString *descString;
@property(nonatomic,copy)NSString *oid;
@property(nonatomic,copy)NSString *collectType;
@property(nonatomic,copy)NSString *likeTotals;
@property(nonatomic,copy)NSString *likeType;
@property(nonatomic,copy)NSString *collectTotals;
@property(nonatomic,copy)NSString *startprice;
@property(nonatomic,copy)NSString *upprice;
@property(nonatomic,copy)NSString *features;
@property(nonatomic,copy)NSString *starttime;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,retain)NSMutableArray *images;
@property(nonatomic,retain)AucationDataModel *occasion;

@end


@interface MyCollectedLotItem : AucationItemBaseResponse

@property(nonatomic,copy)NSString *createtime;
@property(nonatomic,copy)NSString *sid;
@property(nonatomic,retain)MyCollcetedLotDetailItem *commodity;
@property(nonatomic,copy)NSString *payment;
@property(nonatomic,retain)NSDictionary *company;
@property(nonatomic,copy)NSString *userid;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *caseid;

@property(nonatomic,assign)BOOL selected;  //table点击需要、多选

@end

@interface MyCollectedLotsListResponse : AucationItemBaseResponse

@property(nonatomic,strong)NSArray<MyCollectedLotItem> *data;

@end
