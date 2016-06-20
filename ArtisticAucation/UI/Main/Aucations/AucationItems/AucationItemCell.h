//
//  AucationItemCell.h
//  ArtisticAucation
//
//  Created by Haley on 15/10/21.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "ItemPreferenceCell.h"
#import "ImageViewWithDealState.h"
#import "CountDownView.h"
#import "AucationItemsListResponse.h"

@interface AucationItemCell : ItemPreferenceCell

@property (nonatomic, strong) IBOutlet ImageViewWithDealState *picImageV;

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn; //点赞
@property (weak, nonatomic) IBOutlet UIButton *collectBtn; //收藏
@property (weak, nonatomic) IBOutlet CountDownView *countDownView;


- (IBAction)like:(id)sender;
- (IBAction)collect:(id)sender;

@end
