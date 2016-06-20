//
//  VerificationCodeManager.h
//  ArtisticAucation
//
//  Created by xieran on 15/9/29.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VerificationCodeManager : NSObject

+(VerificationCodeManager *)sharedInstance;

@property(nonatomic,assign)__block NSInteger timeForRegist;
@property(nonatomic,assign)__block NSInteger timeForModInfo;

-(void)startRegistTimeCountDown;
-(void)startModInfoTimeCountDown;

@end
