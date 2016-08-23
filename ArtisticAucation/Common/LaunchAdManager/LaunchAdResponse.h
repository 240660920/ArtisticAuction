//
//  LaunchAdResponse.h
//  ArtisticAuction
//
//  Created by xieran on 16/8/23.
//  Copyright © 2016年 xieran. All rights reserved.
//

#import "AABaseJSONModelResponse.h"

@interface LaunchAdDataModel : AABaseJSONModelResponse

@property(nonatomic,copy)NSString *img_4inch;
@property(nonatomic,copy)NSString *img_47inch;
@property(nonatomic,copy)NSString *img_55inch;

@end


@interface LaunchAdResponse : AABaseJSONModelResponse

@property(nonatomic,strong)LaunchAdDataModel *data;

@end
