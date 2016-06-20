//
//  UploadItemViewController.h
//  ArtisticAucation
//
//  Created by xieran on 15/11/6.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "BaseViewController.h"
#import "UploadItem.h"

typedef void(^UploadItemBlock)(UploadItem *item);

@interface UploadItemViewController : BaseViewController

@property(nonatomic,retain)UploadItem *item;
@property(nonatomic,copy)UploadItemBlock didSelectItemBlock;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)UITableView *table;

-(void)setDidSelectItemBlock:(UploadItemBlock)didSelectItemBlock;

@end
