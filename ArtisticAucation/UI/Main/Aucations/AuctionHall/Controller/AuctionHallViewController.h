//
//  AuctionHallViewController.h
//  ArtisticAuction
//
//  Created by xieran on 2017/4/25.
//  Copyright © 2017年 xieran. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    kMQTTMessageTypeItem = 1,
    kMQTTMessageTypeChat = 2,
    kMQTTMessageTypeCountDown = 3,
} MQTTMessageType;

@interface AuctionHallViewController : UIViewController

@property(nonatomic,copy)NSString *oid;
@property(nonatomic,copy)NSString *agencyName;
@property(nonatomic,copy)NSString *occasionName;

@end
