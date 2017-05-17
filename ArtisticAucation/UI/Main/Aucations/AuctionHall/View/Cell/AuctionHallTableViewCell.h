//
//  AuctionHallTableViewCell.h
//  ArtisticAuction
//
//  Created by xieran on 2017/5/15.
//  Copyright © 2017年 xieran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuctionHallCellViewModel.h"

@interface AuctionHallTableViewCell : UITableViewCell

@property(nonatomic,strong)AuctionHallCellViewModel *viewModel;

@property(nonatomic,assign)CGFloat verticalMargin;
@property(nonatomic,assign)CGFloat horizonalMargin;

@end
