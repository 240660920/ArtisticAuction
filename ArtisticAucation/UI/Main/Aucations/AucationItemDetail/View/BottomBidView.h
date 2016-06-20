//
//  BottomBidView.h
//  ArtisticAucation
//
//  Created by xieran on 16/1/28.
//  Copyright © 2016年 xieran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "QuickPricePickerView.h"

#define BottomBidViewHeight 49

typedef void(^BidBlock)(NSString *price);

@protocol BottomBidViewDelegate <NSObject>

@end

@interface BottomBidView : UIView

@property(nonatomic,copy)BidBlock bidBlock;
@property(nonatomic,weak)id<BottomBidViewDelegate> delegate;
@property(nonatomic,assign)NSInteger itemCurrentPrice;

-(void)setBidBlock:(BidBlock)bidBlock;

@end
