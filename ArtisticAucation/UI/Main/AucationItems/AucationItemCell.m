//
//  AucationItemCell.m
//  ArtisticAucation
//
//  Created by Haley on 15/10/21.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "AucationItemCell.h"

@implementation AucationItemCell

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
