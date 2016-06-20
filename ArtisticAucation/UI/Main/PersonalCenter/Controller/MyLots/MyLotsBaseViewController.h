//
//  MyLotsBaseViewController.h
//  ArtisticAucation
//
//  Created by xieran on 15/10/16.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "BaseViewController.h"
#import "MyLotsCell.h"
#import "MyCollectedLotsListResponse.h"

@interface MyLotsBaseViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,retain)UITableView *table;

@property(nonatomic,retain)NSMutableArray *dataSource;

@end
