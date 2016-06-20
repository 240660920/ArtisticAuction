//
//  AlipayManager.h
//  ArtisticAucation
//
//  Created by xieran on 15/10/15.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlipayResultModule.h"
#import "AlipayOrder.h"
#import <AlipaySDK/AlipaySDK.h>

@interface AlipayManager : NSObject

@property(nonatomic,copy)NSString *sign;

+(id)sharedInstance;

-(void)payOrder:(AlipayOrder *)order completionBlock:(CompletionBlock)completionBlock controller:(UIViewController *)controller;
@end
