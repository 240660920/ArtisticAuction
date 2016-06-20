//
//  AucationItemDetailResponse.h
//  ArtisticAucation
//
//  Created by xieran on 15/12/3.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "AucationItemBaseResponse.h"
#import "AucationItemsListResponse.h"

@interface AucationItemDetailResponse : AucationItemBaseResponse

@property(nonatomic,retain)LotResponse *data;

@end
