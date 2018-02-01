//
//  AucationsHeaader.h
//  ArtisticAucation
//
//  Created by Haley on 15/10/21.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SegmentControl.h"
#import "AdScrollView.h"

@interface AucationsHeader : UIView
@property (nonatomic, assign) id delegate;

@property(nonatomic,retain)SegmentControl *segmentControl;

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) IBOutlet UILabel *nian;
@property (nonatomic, strong) IBOutlet UILabel *place;
@property (nonatomic, strong) IBOutlet UILabel *nname;
@property (nonatomic, strong) IBOutlet UILabel *destion;

@property (nonatomic, strong) IBOutlet UIButton *leftBut;
@property (nonatomic, strong) IBOutlet UIButton *rightBut;
@property (weak, nonatomic) IBOutlet AdScrollView *scrollView;

@property (nonatomic, assign) BOOL isRight;

-(void)setSegmentSelectedIndex:(NSInteger )index;

@end
