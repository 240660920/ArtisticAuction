//
//  RemindCell.h
//  ArtisticAucation
//
//  Created by Haley on 15/10/14.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^RemindBlock) (void);

@interface RemindCell : UITableViewCell
@property (nonatomic, copy) RemindBlock myRemindBlock;

@property (nonatomic, strong) IBOutlet UIImageView *headIV;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *people;
@property (nonatomic, strong) IBOutlet UILabel *favite;
@property (nonatomic, strong) IBOutlet UIButton *deleteBut;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;

@end
