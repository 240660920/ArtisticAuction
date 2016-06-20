//
//  WeixinLoginResponse.h
//  ArtisticAucation
//
//  Created by xieran on 15/10/16.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "AABaseJSONModelResponse.h"

@interface WeixinLoginResponse : AABaseJSONModelResponse

@property(nonatomic,copy)NSString *nickname;
@property(nonatomic,copy)NSString *openid;

@end
