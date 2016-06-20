//
//  UploadItemImageView.m
//  ArtisticAucation
//
//  Created by xieran on 15/12/8.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "UploadItemImageView.h"

@interface UploadItemImageView ()

@end

@implementation UploadItemImageView

+(CGFloat)imageWidth
{
    return (Screen_Width - ImageGap * (ImagesPerRow + 1)) / ImagesPerRow;
}

+(CGFloat)viewWitdh
{
    return [self imageWidth] + ImageGap;
}

+(CGRect )itemFrameAtIndex:(NSInteger)index
{
    NSInteger row = index / ImagesPerRow;
    NSInteger column = index % ImagesPerRow;
    
    CGFloat originX = ImageGap / 2 + column * [self viewWitdh];
    CGFloat originY = row * [self viewWitdh];
    return CGRectMake(originX, originY, [self viewWitdh], [self viewWitdh]);
}

-(id)init
{
    if (self = [super init]) {
//        [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress)]];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageItem)]];
        self.deleteButton.hidden = NO;
    }
    return self;
}

//-(void)longPress
//{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(longPressImageItem)]) {
//        [self.delegate longPressImageItem];
//    }
//}

-(void)tapImageItem
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapImageItem:)]) {
        [self.delegate tapImageItem:self];
    }
}

-(void)deleteButtonClicked
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickDeleteImageViewItem:)]) {
        [self.delegate didClickDeleteImageViewItem:self];
    }
}

-(void)setImage:(UIImage *)image
{
    _image = image;
    self.imageView.image = image;
}



-(UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.frame = CGRectMake(ImageGap / 2, ImageGap, [[self class] imageWidth], [[self class]imageWidth]);
        _imageView.backgroundColor = [UIColor blueColor];
        [self addSubview:_imageView];
    }
    return _imageView;
}

-(UIButton *)deleteButton
{
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setBackgroundImage:[UIImage imageNamed:@"del_btn"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self insertSubview:_deleteButton aboveSubview:self.imageView];
        
        [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.top.equalTo(self).offset(3);
        }];
    }
    return _deleteButton;
}

@end
