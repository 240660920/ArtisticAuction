//
//  SearchCell.h
//  ArtisticAucation
//
//  Created by Haley on 15/10/10.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "ItemPreferenceCell.h"

@interface SearchResultCell : ItemPreferenceCell

@property (nonatomic, strong) IBOutlet UIImageView *picImageV;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet LikeButton *likeButton;
@property (weak, nonatomic) IBOutlet CollectButton *collectButton;
- (IBAction)like:(id)sender;
- (IBAction)collect:(id)sender;

@end
