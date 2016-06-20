//
//  ItemPreferenceCell.m
//  ArtisticAucation
//
//  Created by xieran on 15/10/23.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "ItemPreferenceCell.h"

@implementation ItemPreferenceCell

-(void)setLikeRequestBlock:(LikeRequestBlock)likeRequestBlock
{
    _likeRequestBlock = [likeRequestBlock copy];    
}

-(void)setCollectRequestBlock:(CollectRequestBlock)collectRequestBlock
{
    _collectRequestBlock = [collectRequestBlock copy];
}

@end
