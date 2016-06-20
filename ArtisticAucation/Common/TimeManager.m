//
//  Time.m
//  ArtisticAucation
//
//  Created by xieran on 16/4/7.
//  Copyright © 2016年 xieran. All rights reserved.
//

#import "TimeManager.h"

TimeManager *timeManager;
dispatch_source_t serverTimer;

@implementation TimeManager

+(TimeManager *)sharedInstance
{
    if (!timeManager) {
        timeManager = [[TimeManager alloc]init];
    }
    return timeManager;
}

-(void)setTimeIntervalSince1970:(double)timeIntervalSince1970
{
    _timeIntervalSince1970 = timeIntervalSince1970 / 1000;
    
    [self initTimer];
}

-(void)initTimer
{
    if (serverTimer) {
        dispatch_source_cancel(serverTimer);
    }

    serverTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    dispatch_source_set_timer(serverTimer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(serverTimer, ^{
        
        if (self.timeIntervalSince1970 < 0) {
            dispatch_source_cancel(serverTimer);
        }
        else{
            _timeIntervalSince1970++;
            
//            NSLog(@"now:%@",[self serverTimeString]);
        }
    });
    dispatch_resume(serverTimer);
}

-(NSString *)serverTimeString
{
    return [FMUString timeIntervalSince1970:self.timeIntervalSince1970 Format:@"yyyy-MM-dd HH:mm:ss"];
}

+(NSTimeInterval )timeIntervalBetweenServerTimeAndTime:(NSString *)time
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *serverTimeString = [TimeManager sharedInstance].serverTimeString;
    NSDate *serverDate = [formatter dateFromString:serverTimeString];
    NSDate *parmaTimeDate = [formatter dateFromString:time];
    NSTimeInterval timeInterval = [parmaTimeDate timeIntervalSinceDate:serverDate];
    return timeInterval;
}

@end
