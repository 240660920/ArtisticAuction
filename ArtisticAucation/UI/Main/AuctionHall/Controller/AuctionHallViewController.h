//
//  AuctionHallViewController.h
//  ArtisticAuction
//
//  Created by xieran on 2017/4/25.
//  Copyright © 2017年 xieran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AucationItemDetailViewController.h"
#import "AucationItemsListViewController.h"
#import "AAImagesScrollView.h"
#import "AuctionHallStateView.h"
#import "AuctionHallTitleView.h"
#import "AuctionHallInputView.h"
#import "AuctionHallCurrentItemModel.h"
#import "AuctionHallCellViewModel.h"
#import "AuctionHallTableViewCell.h"
#import "NSMutableArray+AddHallViewModel.h"
#import "AuctionHallCountDownView.h"
#import "BidManager.h"
#import "AuctionHallItemIntroTimer.h"
#import <MQTTClient/MQTTClient.h>

@interface AuctionHallViewController : UIViewController

@property(nonatomic,copy)NSString *oid;
@property(nonatomic,copy)NSString *agencyName;
@property(nonatomic,copy)NSString *occasionName;

@property(nonatomic,strong)AuctionHallTitleView *titleView;
@property(nonatomic,strong)AuctionHallStateView *stateView;
@property(nonatomic,strong)AuctionHallInputView *bottomView;
@property(nonatomic,strong)AuctionHallCountDownView *countDownView;

@property(nonatomic,strong)AuctionHallItemIntroTimer *itemIntroTimer;

@property(nonatomic,strong)AuctionHallCurrentItemModel *itemModel;

@property(nonatomic,strong)MQTTSession *mqttSession;

@property(nonatomic,strong)AAImagesScrollView *imgScrollView;
@property(nonatomic,strong)UITableView *table;

@property(nonatomic,strong)NSMutableArray *viewModels;

@end
