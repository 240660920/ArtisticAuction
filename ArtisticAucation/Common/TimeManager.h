//
//  Time.h
//  ArtisticAucation
//
//  Created by xieran on 16/4/7.
//  Copyright © 2016年 xieran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeManager : NSObject

@property(nonatomic,assign)double timeIntervalSince1970;
@property(nonatomic,copy)NSString *serverTimeString;
@property(nonatomic,strong)NSTimer *timer;

+(TimeManager *)sharedInstance;

+(NSTimeInterval )timeIntervalBetweenServerTimeAndTime:(NSString *)time;

@end
