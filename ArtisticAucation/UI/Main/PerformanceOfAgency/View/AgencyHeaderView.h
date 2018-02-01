//
//  AgencyHeaderView.h
//  ArtisticAucation
//
//  Created by xieran on 16/1/7.
//  Copyright © 2016年 xieran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LikeButton.h"
#import "CollectButton.h"

@interface AgencyHeaderView : UIView

@property(nonatomic,retain)UIImage *image;
@property(nonatomic,retain)LikeButton *likeButton;
@property(nonatomic,retain)CollectButton *collectButton;

+(CGFloat)heightForImage:(UIImage *)image;

@end
