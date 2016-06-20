//
//  JSONModelResponse.h
//  ArtisticAucation
//
//  Created by xieran on 15/9/21.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "JSONModel.h"

@interface AAJSONModelResponseResultModel : JSONModel

@property(nonatomic,copy)NSString *resultCode;
@property(nonatomic,copy)NSString *msg;

@end

@interface AABaseJSONModelResponse : JSONModel

@property(nonatomic,retain)AAJSONModelResponseResultModel *result;
@property(nonatomic,assign)ItemType itemType;

@end
