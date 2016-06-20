//
//  OpenupSessionViewController.h
//  ArtisticAucation
//
//  Created by Haley on 15/11/2.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "BaseViewController.h"

@interface OpenupSessionViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) IBOutlet UIButton *AddNewBut;

@end
