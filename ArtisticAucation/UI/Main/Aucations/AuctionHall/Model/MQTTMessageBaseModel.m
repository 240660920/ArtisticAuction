//
//  MQTTMessageBaseModel.m
//  ArtisticAuction
//
//  Created by xieran on 2017/5/20.
//  Copyright © 2017年 xieran. All rights reserved.
//

#import "MQTTMessageBaseModel.h"

@implementation MQTTMessageBaseModel

-(MQTTMessageType)typeEnum
{
    if (self.type.intValue == 1) {
        if (self.number > 0) {
            return kMQTTMessageTypeItem;
        }
        else{
            return kMQTTMessageTypeBid;
        }
    }
    else if (self.type.intValue == 2){
        if (self.tel.length == 0 && self.message.length > 0) {
            return kMQTTMessageTypeDeal;
        }
        else if (self.tel.length > 0 && self.message.length > 0){
            return kMQTTMessageTypeChat;
        }
        else{
            return kMQTTMessageTypeCountDown;
        }
    }
    else{
        return kMQTTMessageTypeNone;
    }
}

@end
