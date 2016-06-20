//
//  SearchResultModel.h
//  ArtisticAucation
//
//  Created by Haley on 15/10/20.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AucationItemBaseResponse.h"

@interface SearchResultModel : AucationItemBaseResponse

@property(nonatomic,retain)NSArray<LotResponse> *data;

@end