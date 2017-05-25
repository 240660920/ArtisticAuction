//
//  AuctionHallInputView.h
//  ArtisticAuction
//
//  Created by xieran on 2017/4/25.
//  Copyright © 2017年 xieran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuctionHallInputView : UIView
@property (weak, nonatomic) IBOutlet UIButton *switchBtn;
@property (weak, nonatomic) IBOutlet UITextField *chatTf;
@property (weak, nonatomic) IBOutlet UIView *priceView;
@property (weak, nonatomic) IBOutlet UIButton *bidButton;
@property (weak, nonatomic) IBOutlet UITextField *priceTf;

@property(nonatomic,copy)NSString *startPrice;

@property(nonatomic,copy)void(^bidBlock)(NSString *price);
@property(nonatomic,copy)void(^sendChatBlock)(NSString *chatContent);
@property(nonatomic,copy)BOOL(^shouldBeginEditingBlock)();


- (IBAction)priceMinus:(id)sender;
- (IBAction)pricePlus:(id)sender;
- (IBAction)switchMode:(id)sender;
- (IBAction)bid:(id)sender;


@end
