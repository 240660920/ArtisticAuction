//
//  UIImage+FixOrientation.h
//  ArtisticAucation
//
//  Created by xieran on 16/1/12.
//  Copyright © 2016年 xieran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface UIImage (FixOrientation)

- (UIImage *)fixOrientationOfOrientation:(ALAssetOrientation )originOrientation;

@end
