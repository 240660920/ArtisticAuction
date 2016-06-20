//
//  SettlementModule.h
//  ArtisticAucation
//
//  Created by xieran on 15/10/19.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    kSettlementTypeWeixin,
    kSettlementTypeAlipay,
    kSettlementTypeBankCard,
} SettlementType;

@interface SettlementModule : NSObject

@property(nonatomic,assign)SettlementType settlementType;
@property(nonatomic,assign)NSInteger goodsCount;//商品数量
@property(nonatomic,copy)NSString *goodsAmount; //商品总价
@property(nonatomic,copy)NSString *totalAmount; //实际需要支付
@property(nonatomic,retain)NSMutableArray *goodsIdsArray;
@property(nonatomic,retain)NSMutableArray *itemsArray;

@end
