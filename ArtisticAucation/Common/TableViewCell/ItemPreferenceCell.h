//
//  ItemPreferenceCell.h
//  ArtisticAucation
//
//  Created by xieran on 15/10/23.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LikeButton.h"
#import "CollectButton.h"

typedef void(^LikeRequestBlock)(void);
typedef void(^CollectRequestBlock)(void);

@interface ItemPreferenceCell : UITableViewCell

@property(nonatomic,copy)LikeRequestBlock likeRequestBlock;
@property(nonatomic,copy)CollectRequestBlock collectRequestBlock;

-(void)setLikeRequestBlock:(LikeRequestBlock)likeRequestBlock;
-(void)setCollectRequestBlock:(CollectRequestBlock)collectRequestBlock;

@end
