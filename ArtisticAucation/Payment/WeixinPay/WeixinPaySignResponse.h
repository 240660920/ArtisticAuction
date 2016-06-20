//
//  WeixinPaySignResponse.h
//  ArtisticAucation
//
//  Created by xieran on 15/10/21.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "AABaseJSONModelResponse.h"

@interface WeixinPaySignResponse : AABaseJSONModelResponse

@property(nonatomic,copy)NSString *message;
@property(nonatomic,copy)NSString *prepayid;

@end
