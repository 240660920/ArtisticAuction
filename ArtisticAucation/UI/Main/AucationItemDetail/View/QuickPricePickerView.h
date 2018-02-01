//
//  QuickPricePickerView.h
//  Area
//
//  Created by xieran on 16/1/28.
//  Copyright © 2016年 xieran. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^QuickPricePickerViewSelectBlock)(NSInteger index);

@interface QuickPricePickerView : UITableView

@property(nonatomic,assign)NSInteger currentIndex;
@property(nonatomic,strong)NSArray *priceArray;
@property(nonatomic,copy)QuickPricePickerViewSelectBlock selectPriceBlock;

-(void)setSelectPriceBlock:(QuickPricePickerViewSelectBlock)selectPriceBlock;

-(void)dismiss;

@end
