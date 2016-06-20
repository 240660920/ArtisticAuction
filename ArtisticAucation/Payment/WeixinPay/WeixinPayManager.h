//
//  WeixinPayManager.h
//  ArtisticAucation
//
//  Created by xieran on 15/10/20.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeixinPayModule.h"

@interface WeixinPayManager : NSObject

+(void)payWithModule:(WeixinPayModule *)module controller:(UIViewController *)controller;

@end
