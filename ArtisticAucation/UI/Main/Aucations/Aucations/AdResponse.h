//
//  AdResponse.h
//  ArtisticAucation
//
//  Created by xieran on 16/1/22.
//  Copyright © 2016年 xieran. All rights reserved.
//

#import "JSONModel.h"

typedef enum : NSUInteger {
    kAdTypeOccasion = 1,
    kAdTypeCommodity = 2,
    kAdTypeURL = 3,
} kAdvertisementType;

@protocol AdModel <NSObject>

@end

@interface AdModel : JSONModel

@property(nonatomic,copy)NSString *imageUrl;
@property(nonatomic,copy)NSString *linkUrl;
@property(nonatomic,copy)NSString *paramId;
@property(nonatomic,assign)kAdvertisementType type;

@end

@interface AdResponse : JSONModel

@property(nonatomic,strong)NSArray <AdModel> *data;

@end
