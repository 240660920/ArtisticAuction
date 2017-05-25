//
//  MQTTMessageBaseModel.h
//  ArtisticAuction
//
//  Created by xieran on 2017/5/20.
//  Copyright © 2017年 xieran. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface MQTTMessageBaseModel : AABaseJSONModelResponse

@property(nonatomic,copy)NSString *type;

@property(nonatomic,assign)NSInteger number;

@property(nonatomic,copy)NSString *message;
@property(nonatomic,copy)NSString *tel;
@property(nonatomic,copy)NSString *date;

@end
