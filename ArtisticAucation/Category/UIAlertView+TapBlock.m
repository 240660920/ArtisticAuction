//
//  UIAlertView+TapBlock.m
//  ArtisticAucation
//
//  Created by xieran on 15/9/30.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "UIAlertView+TapBlock.h"
#import <objc/runtime.h>

@implementation UIAlertView (TapBlock)

-(void)handleClickedButton:(TapBlock)tapBlock
{
    self.delegate = self;
    if (tapBlock) {
        objc_setAssociatedObject(self, "UIAlertViewTapBlock", tapBlock, OBJC_ASSOCIATION_COPY);
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    TapBlock tapBlock = objc_getAssociatedObject(self, "UIAlertViewTapBlock");
    tapBlock(buttonIndex);
}

@end
