//
//  AucationDetailTopViewSubview.m
//  ArtisticAucation
//
//  Created by xieran on 15/10/31.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "AucationDetailTopViewSubview.h"

@implementation AucationDetailTopViewSubview

-(void)awakeFromNib
{
    [self.bidButton setBackgroundColor:RedColor];
    self.bidButton.layer.masksToBounds = YES;
    self.bidButton.layer.cornerRadius = 3;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)bid:(id)sender {
    self.bidBlock();
}
@end
