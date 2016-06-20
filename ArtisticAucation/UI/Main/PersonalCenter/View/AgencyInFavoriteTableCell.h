//
//  AgencyInFavoriteTableCell.h
//  ArtisticAucation
//
//  Created by xieran on 15/10/9.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "ItemPreferenceCell.h"

@interface AgencyInFavoriteTableCell : ItemPreferenceCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIButton *collectButton;
@property (weak, nonatomic) IBOutlet LikeButton *likeButton;
- (IBAction)like:(id)sender;
- (IBAction)collect:(id)sender;

@end
