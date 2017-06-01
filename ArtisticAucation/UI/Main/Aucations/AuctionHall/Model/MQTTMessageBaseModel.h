//
//  MQTTMessageBaseModel.h
//  ArtisticAuction
//
//  Created by xieran on 2017/5/20.
//  Copyright © 2017年 xieran. All rights reserved.
//

#import <JSONModel/JSONModel.h>

typedef enum : NSUInteger {
    kMQTTMessageTypeNone = 0,
    kMQTTMessageTypeItem = 1,
    kMQTTMessageTypeChat = 2,
    kMQTTMessageTypeBid = 3,
    kMQTTMessageTypeDeal = 4,
    kMQTTMessageTypeCountDown = 5,
} MQTTMessageType;

@interface MQTTMessageBaseModel : AABaseJSONModelResponse

@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *tel;
@property(nonatomic,copy)NSString *message;
@property(nonatomic,assign)NSInteger number;
@property(nonatomic,assign)MQTTMessageType typeEnum;

@end
