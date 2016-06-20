//
//  EditImageViewController.h
//  ArtisticAucation
//
//  Created by xieran on 15/12/1.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^EditImageBlock)(UIImage *editedImage);

@interface EditImageViewController : UIViewController

@property(nonatomic,retain)UIImage *image;
@property(nonatomic,copy)EditImageBlock editImageBlock;

-(void)setEditImageBlock:(EditImageBlock)editImageBlock;

@end
