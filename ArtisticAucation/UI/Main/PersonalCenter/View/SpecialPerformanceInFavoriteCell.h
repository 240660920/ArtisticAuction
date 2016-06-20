//
//  AucationsInFavoriteCell.h
//  ArtisticAucation
//
//  Created by xieran on 15/10/9.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "ItemPreferenceCell.h"

@interface SpecialPerformanceInFavoriteCell : ItemPreferenceCell
@property(nonatomic, retain)UIImageView *performanceImageView;
@property(nonatomic, retain)UILabel *nameLabel;
@property(nonatomic, retain)LikeButton *likeButton;
@property(nonatomic, retain)CollectButton *collectButton;
@property(nonatomic, retain)UIButton *aucationButton;
@property(nonatomic, retain)UIImageView *stateImageView;
@property(nonatomic, retain)UILabel *stateLabel;

+(CGFloat )heightForRow;

@end
