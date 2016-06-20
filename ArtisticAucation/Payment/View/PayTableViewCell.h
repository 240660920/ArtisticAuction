//
//  PayTableViewCell.h
//  ArtisticAucation
//
//  Created by xieran on 15/10/19.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PayTableViewCellTypeCheckbox,
    PayTableViewCellTypeWithBlackLabel,
    PayTableViewCellTypeWithRedLabel,
} PayTableViewCellType;

@interface PayTableViewCell : UITableViewCell

@property(nonatomic,assign)PayTableViewCellType cellType;
@property(nonatomic,copy)NSString *leftTitle;
@property(nonatomic,copy)NSString *rightTitle;
@property(nonatomic,strong)UIButton *checkBox;

@end
