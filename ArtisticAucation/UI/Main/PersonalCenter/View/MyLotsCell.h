//
//  MyLotsCell.h
//  ArtisticAucation
//
//  Created by xieran on 15/10/16.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MyLotTableRowHeiht 182

@interface MyLotsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *checkbox;
@property (weak, nonatomic) IBOutlet UILabel *aucationNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *closingPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *commissionPriceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *lotImageView;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;

@end
