//
//  AdScrollView.h
//  ArtisticAucation
//
//  Created by xieran on 16/4/25.
//  Copyright © 2016年 xieran. All rights reserved.
//

#import "AucationItemImagesScrollView.h"
#import "AdResponse.h"

@interface AdScrollView : AucationItemImagesScrollView

@property(nonatomic,strong)AdResponse *responseModule;

@property(nonatomic,copy)void(^tapBlock)(AdModel *adModel);

-(void)setTapBlock:(void (^)(AdModel *))tapBlock;

@end
