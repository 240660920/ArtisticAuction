//
//  MyRemindResponse.h
//  ArtisticAucation
//
//  Created by Haley on 15/10/23.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "AABaseJSONModelResponse.h"

@protocol MyRemindDataModel <NSObject>

@end

@interface MyRemindDataModel : AABaseJSONModelResponse

@property(nonatomic,copy)NSString *endtime;
@property(nonatomic,copy)NSString *starttime;
@property(nonatomic,copy)NSString *count;
@property(nonatomic,copy)NSString *status;
@property(nonatomic,copy)NSString *collectTotals;
@property(nonatomic,copy)NSString *odescription;
@property(nonatomic,copy)NSString *oid;
@property(nonatomic,copy)NSString *aid;
@property(nonatomic,copy)NSString *enterTotals;
@property(nonatomic,copy)NSString *imgurl;

@end

@protocol RemindDataModel <NSObject>

@end

@interface RemindDataModel : AABaseJSONModelResponse

@property(nonatomic,copy)NSString *createtime;
@property(nonatomic,copy)NSString *sid;
@property(nonatomic,retain)NSMutableDictionary *commodity;
@property(nonatomic,copy)NSString *payment;
@property(nonatomic,retain)NSMutableDictionary *company;
@property(nonatomic,retain)MyRemindDataModel *occasion;
@property(nonatomic,copy)NSString *userid;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *caseid;

@end


@interface MyRemindResponse : AABaseJSONModelResponse
@property(nonatomic,retain)NSArray<RemindDataModel> *data;
@end
