//
//  AdScrollView.m
//  ArtisticAucation
//
//  Created by xieran on 16/4/25.
//  Copyright © 2016年 xieran. All rights reserved.
//

#import "AdScrollView.h"

@implementation AdScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setResponseModule:(AdResponse *)responseModule
{
    _responseModule = responseModule;
    
    NSMutableArray *imageUrls = [[NSMutableArray alloc]init];
    [responseModule.data enumerateObjectsUsingBlock:^(AdModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [imageUrls addObject:obj.imageUrl];
    }];
    
    self.imageUrls = imageUrls;
}

-(void)tap
{
    AdModel *model = self.responseModule.data[self.currentIndex];
    
    if (self.tapBlock) {
        self.tapBlock(model);
    }
}

@end
