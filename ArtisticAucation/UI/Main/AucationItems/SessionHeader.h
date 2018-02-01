//
//  SessionHeader.h
//  ArtisticAucation
//
//  Created by Haley on 15/10/21.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LikeButton.h"
#import "CollectButton.h"
#import "RemindButton.h"

@interface SessionHeader : UIView
@property (nonatomic, copy) dispatch_block_t remindBlock;

@property (nonatomic, strong) IBOutlet UILabel *statusLabel;
@property (nonatomic, strong) IBOutlet UIImageView *backImageV;

@property (nonatomic, strong) IBOutlet UILabel *mainLabel;
@property (nonatomic, strong) IBOutlet RemindButton *remindBtn;
@property (weak, nonatomic) IBOutlet LikeButton *likeBtn;
@property (weak, nonatomic) IBOutlet CollectButton *collectBtn;
@property (weak, nonatomic) IBOutlet CollectButton *amountBtn;

@property(nonatomic,copy)void(^likeBlock)(UIButton *sender);
@property(nonatomic,copy)void(^collectBlock)(UIButton *sender);

- (IBAction)likeBtnClicked:(id)sender;
- (IBAction)collectBtnClicked:(id)sender;

-(void)setStatus:(DisplayState)displayStatus;
@end
