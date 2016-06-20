//
//  PayViewController.h
//  ArtisticAucation
//
//  Created by xieran on 15/10/19.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "BaseViewController.h"
#import "SettlementModule.h"

typedef void(^PayResultBlock)(NSArray *ids);

@interface PayViewController : BaseViewController

@property(nonatomic,retain)SettlementModule *settlementModule;

@end
