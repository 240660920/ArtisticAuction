//
//  UploadItemImageView.h
//  ArtisticAucation
//
//  Created by xieran on 15/12/8.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ImagesCount 8
#define ImageGap 15.0f
#define ImagesPerRow 4

@protocol UploadItemImageViewDelegate <NSObject>

-(void)tapImageItem:(UIView *)itemView;

-(void)didClickDeleteImageViewItem:(UIView *)itemView;

@optional

-(void)longPressImageItem;

@end

@interface UploadItemImageView : UIView

@property(nonatomic,retain)UIImageView *imageView;
@property(nonatomic,retain)UIImage *image;
@property(nonatomic,retain)UIImage *thumbnailImage;
@property(nonatomic,retain)UIButton *deleteButton;

@property(nonatomic,assign)id<UploadItemImageViewDelegate>delegate;

+(CGFloat)imageWidth;
+(CGRect)itemFrameAtIndex:(NSInteger )index;
@end
