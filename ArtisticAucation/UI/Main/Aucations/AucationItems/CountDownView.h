//
//  CountDownView.h
//  ArtisticAucation
//
//  Created by xieran on 15/12/24.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountDownView : UIView

@property(nonatomic,copy)NSString *startTime;
@property(nonatomic,assign)DisplayState aucationState;
@property(nonatomic,assign)DealState itemState;

-(void)refresh;

@end
