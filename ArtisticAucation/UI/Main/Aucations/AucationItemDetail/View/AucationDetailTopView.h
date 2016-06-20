//
//  AucationDetailTopView.h
//  ArtisticAucation
//
//  Created by xieran on 15/10/21.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AucationDetailTopViewSubview.h"
#import "AucationItemsListResponse.h"
#import "AucationItemImagesScrollView.h"

@interface AucationDetailTopView : UIView

@property(nonatomic,strong)AucationItemImagesScrollView *imageScrollView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *promptLabel;
@property(nonatomic,strong)UILabel *priceLabel;
@property(nonatomic,strong)AucationDetailTopViewSubview *subview;
@property(nonatomic,strong)LotResponse *item;

+(CGFloat )heightForRowWithTitle:(NSString *)title;

@end
