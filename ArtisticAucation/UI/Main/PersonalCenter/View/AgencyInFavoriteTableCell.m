//
//  AgencyInFavoriteTableCell.m
//  ArtisticAucation
//
//  Created by xieran on 15/10/9.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "AgencyInFavoriteTableCell.h"

@implementation AgencyInFavoriteTableCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)like:(id)sender {
    self.likeRequestBlock();
}

- (IBAction)collect:(id)sender {
    self.collectRequestBlock();
}
@end
