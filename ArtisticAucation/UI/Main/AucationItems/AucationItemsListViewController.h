//
//  SessionViewController.h
//  ArtisticAucation
//
//  Created by Haley on 15/10/21.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "BaseViewController.h"
#import "AucationListResponse.h"

@interface AucationItemsListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)UITableView *tableView;

@property(nonatomic,copy)NSString *oid;
@property(nonatomic,copy)AucationDataModel *aucationModel;

@property(nonatomic,assign)BOOL shouldHideEnterHallBtn;

@end
