//
//  UploadItemManager.h
//  ArtisticAucation
//
//  Created by xieran on 15/11/8.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UploadItem.h"

@interface UploadItemManager : NSObject

+(UploadItemManager *)sharedInstance;


+(NSMutableArray *)localItems;

-(void)insertItem:(UploadItem *)item;

+(void)removeItem:(UploadItem *)item;

+(void)removeAllItems;

-(void)saveOccasionImage:(UIImage *)image;

-(UIImage *)occasionImage;

-(void)deleteOccasionImage;

@end
