//
//  AuctionHallCurrentItemModel.h
//  ArtisticAuction
//
//  Created by xieran on 2017/5/18.
//  Copyright © 2017年 xieran. All rights reserved.
//

#import "MQTTMessageBaseModel.h"

@interface AuctionHallCurrentItemOccasionModel : JSONModel

@property(nonatomic,copy)NSString *oid;

@end


@interface AuctionHallCurrentItemDataModel : JSONModel

@property(nonatomic,copy)NSString *cname;
@property(nonatomic,copy)NSString *endprice;
@property(nonatomic,copy)NSString *cid;
@property(nonatomic,copy)NSString *features;
@property(nonatomic,copy)NSString *analyse; //拍品赏析
@property(nonatomic,strong)NSArray *image;
@property(nonatomic,strong)AuctionHallCurrentItemOccasionModel *occasion;

@end

@interface AuctionHallCurrentItemModel : JSONModel

@property(nonatomic,strong)AuctionHallCurrentItemDataModel *data;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,copy)NSString *type;

@end
