//
//  UploadItemManager.m
//  ArtisticAucation
//
//  Created by xieran on 15/11/8.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "UploadItemManager.h"

#define UploadItemFolderPath     [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"UploadItems_%@",[UserInfo sharedInstance].userId]]

UploadItemManager *uploadManager;
dispatch_queue_t uploadQueue;

@implementation UploadItemManager

+(UploadItemManager *)sharedInstance
{
    @synchronized(uploadManager) {
        if (!uploadManager) {
            uploadManager = [[UploadItemManager alloc]init];
        }
        return uploadManager;
    }
}


-(void)insertItem:(UploadItem *)item
{
    if (!uploadQueue) {
        uploadQueue = dispatch_get_global_queue(0, 0);
    }
    
    if (![[NSFileManager defaultManager]fileExistsAtPath:UploadItemFolderPath]) {
        [[NSFileManager defaultManager]createDirectoryAtPath:UploadItemFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *destPath = [UploadItemFolderPath stringByAppendingPathComponent:item.timestamp];

    dispatch_async(uploadQueue, ^{
        [NSKeyedArchiver archiveRootObject:item toFile:destPath];
    });
}

+(void)removeItem:(UploadItem *)item
{
    NSString *sourcePath = [UploadItemFolderPath stringByAppendingPathComponent:item.timestamp];
    [[NSFileManager defaultManager]removeItemAtPath:sourcePath error:nil];
}

+(void)removeAllItems
{
    [[NSFileManager defaultManager]removeItemAtPath:UploadItemFolderPath error:nil];
}

+(NSMutableArray *)localItems
{
    NSMutableArray *items = [[NSMutableArray alloc]init];
    NSArray *localItemNames = [[NSFileManager defaultManager]contentsOfDirectoryAtPath:UploadItemFolderPath error:nil];
    NSArray *_names = [localItemNames sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 intValue] > [obj2 intValue];
    }];
    [_names enumerateObjectsUsingBlock:^(NSString *fileName, NSUInteger idx, BOOL * _Nonnull stop) {
        UploadItem *item = [NSKeyedUnarchiver unarchiveObjectWithFile:[UploadItemFolderPath stringByAppendingPathComponent:fileName]];
        [items addObject:item];
    }];
    
    return items;
}

@end
