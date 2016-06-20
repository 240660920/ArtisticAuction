//
//  UploadItem.h
//  ArtisticAucation
//
//  Created by xieran on 15/11/6.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UploadItem : NSObject

@property(nonatomic,strong)NSArray *images;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *property;
@property(nonatomic,copy)NSString *price;
@property(nonatomic,copy)NSString *desc;
@property(nonatomic,copy)NSString *features;
@property(nonatomic,copy)NSString *timestamp; //以添加的时间为文件名

@end
