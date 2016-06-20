//
//  AATextView.h
//  ArtisticAucation
//
//  Created by xieran on 15/11/12.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AATextView : UITextView

@property(nonatomic,copy)NSString *placeholder;

-(void)addTarget:(id)target action:(nonnull SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end
