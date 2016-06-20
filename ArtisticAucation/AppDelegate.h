//
//  AppDelegate.h
//  ArtisticAucation
//
//  Created by xieran on 15/8/27.
//  Copyright (c) 2015年 xieran. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WeixinLoginSuccessBlock)(NSString *);

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,copy)NSString *code; //微信登陆使用的code

@property(nonatomic,copy)WeixinLoginSuccessBlock weixinLoginSuccessBlock;

@end

