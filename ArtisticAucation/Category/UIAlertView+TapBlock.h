//
//  UIAlertView+TapBlock.h
//  ArtisticAucation
//
//  Created by xieran on 15/9/30.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TapBlock)(NSInteger buttonIndex);

@interface UIAlertView (TapBlock)<UIAlertViewDelegate>

-(void)handleClickedButton:(TapBlock )tapBlock;

@end
