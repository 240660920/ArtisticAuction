//
//  AucationDetailTopViewSubview.h
//  ArtisticAucation
//
//  Created by xieran on 15/10/31.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AucationDetailTopViewSubview : UIView
@property (weak, nonatomic) IBOutlet UILabel *startPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *myBidLabel; //我的委托价
@property (weak, nonatomic) IBOutlet UIButton *bidButton;

@property (nonatomic,copy)void(^bidBlock)(void);
- (IBAction)bid:(id)sender;

@end
