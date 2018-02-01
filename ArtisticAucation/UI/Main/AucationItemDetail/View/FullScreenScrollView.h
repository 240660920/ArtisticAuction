//
//  FullScreenScrollView.h
//  ArtisticAucation
//
//  Created by xieran on 15/12/7.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FullScreenScrollView : UIScrollView

@property(nonatomic,retain)NSArray *imageUrls;
@property(nonatomic,assign)NSInteger currentIndex;

-(void)show;

@end
