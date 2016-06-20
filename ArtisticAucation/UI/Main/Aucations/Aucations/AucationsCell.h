//
//  AucationsCell.h
//  ArtisticAucation
//
//  Created by Haley on 15/10/21.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "ItemPreferenceCell.h"
#import "RemindButton.h"

#define AucationItemCellHeight 246

typedef void (^PushRemindBlock) (void);
typedef void (^AuctionHallBlock) (void);

@interface AucationsCell : ItemPreferenceCell
@property (nonatomic, copy) PushRemindBlock pushBlock;
@property (nonatomic, copy) AuctionHallBlock hallBlock;

@property (nonatomic, strong) IBOutlet UIImageView *backImageV;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *onGoingLabel;

@property (weak, nonatomic) IBOutlet LikeButton *likeBtn;
@property (weak, nonatomic) IBOutlet CollectButton *collectBtn;
@property (weak, nonatomic) IBOutlet UIButton *aucationAmountBtn;

@property (nonatomic, strong) IBOutlet UIButton *goAuction;      //预览模式需要隐藏
@property (nonatomic, strong) IBOutlet RemindButton *remindBtn;   //拍卖模式需要隐藏

@property(nonatomic,assign)DisplayState status;
@property(nonatomic,copy)NSString *startTime;

- (IBAction)likeBtnClicked:(id)sender;
- (IBAction)collectBtnClicked:(id)sender;

+(CGFloat)heightForRow;

@end
