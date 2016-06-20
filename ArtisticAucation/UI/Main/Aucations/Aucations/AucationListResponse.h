//
//  AucationListResponse.h
//  ArtisticAucation
//
//  Created by xieran on 15/10/22.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "AucationBaseResponse.h"
#import "AucationItemBaseResponse.h"
#import "MyCollectedLotsListResponse.h"

@protocol AucationDataModel <NSObject>

@end


/*拍品model*/
@protocol LotResponse <NSObject>

@end

@interface LotResponse : AucationItemBaseResponse

@property(nonatomic,copy)NSString *holdprice;
@property(nonatomic,copy)NSString *partakecount;
@property(nonatomic,copy)NSString *status;          //状态（进行中， 已结束，未开始）
@property(nonatomic,copy)NSString *endprice;
@property(nonatomic,copy)NSString *aid;
@property(nonatomic,copy)NSString *cid;
@property(nonatomic,copy)NSString *delaytime;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *desc;
@property(nonatomic,copy)NSString *oid;
@property(nonatomic,copy)NSString *type;             //大类
@property(nonatomic,copy)NSString *startprice;
@property(nonatomic,copy)NSString *starttime;
@property(nonatomic,copy)NSString *agencyName;
@property(nonatomic,copy)NSString *features;
@property(nonatomic,copy)NSString *likeType;
@property(nonatomic,copy)NSString *collectType;
@property(nonatomic,copy)NSString *likeTotals;
@property(nonatomic,copy)NSString *collectTotals;
@property(nonatomic,copy)NSString *phoneNum;
@property(nonatomic,strong)AucationDataModel *occasion;

@property(nonatomic,copy)NSString *aucationStatus;  //专场状态

@property(nonatomic,retain)NSArray *images;

@property(nonatomic,assign)BOOL selected;

-(id)initWithMyAucationDetailItem:(MyCollcetedLotDetailItem *)myCollectedDetailItem;

@end
/*拍品model*/


@interface AucationDataModel : AucationBaseResponse

@property(nonatomic,copy)NSString *predisplayStartTime;
@property(nonatomic,copy)NSString *starttime;
@property(nonatomic,copy)NSString *count;
@property(nonatomic,copy)NSString *status;   
@property(nonatomic,copy)NSString *collectTotals;
@property(nonatomic,copy)NSString *likeTotals;
@property(nonatomic,copy)NSString *occasionName;   //转换index的阿拉伯数字为中文
@property(nonatomic,copy)NSString *oid;
@property(nonatomic,copy)NSString *aid;
@property(nonatomic,copy)NSString *imgurl;
@property(nonatomic,copy)NSString *collectType;
@property(nonatomic,copy)NSString *likeType;
@property(nonatomic,copy)NSString *agencyName;
@property(nonatomic,copy)NSString *remindType;
@property(nonatomic,copy)NSString *verifystatus;
@property(nonatomic,copy)NSArray<LotResponse,Optional> *commodity;

@end

@interface AucationListResponse : AucationBaseResponse

@property(nonatomic,retain)NSArray<AucationDataModel> *data;
@property(nonatomic,copy)NSString *nowtime;
@property(nonatomic,copy)NSString *online; //在线人数

@end
