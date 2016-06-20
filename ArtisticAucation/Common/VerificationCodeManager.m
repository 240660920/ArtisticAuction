//
//  VerificationCodeManager.m
//  ArtisticAucation
//
//  Created by xieran on 15/9/29.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "VerificationCodeManager.h"

VerificationCodeManager *manager;

@interface VerificationCodeManager ()

@property(nonatomic,retain)NSTimer *timerForRegist;
@property(nonatomic,retain)NSTimer *timerForModInfo;

@end

@implementation VerificationCodeManager

+(VerificationCodeManager *)sharedInstance
{
    if (!manager) {
        manager = [[VerificationCodeManager alloc]init];
        manager.timeForRegist = VerificationCodeColdDurarion;
        manager.timeForModInfo = VerificationCodeColdDurarion;
    }
    return manager;
}

-(void)startRegistTimeCountDown
{    
    self.timeForRegist = VerificationCodeColdDurarion;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        if (self.timeForRegist < 0) {
            dispatch_source_cancel(timer);
        }
        else{

            
        }
        
        self.timeForRegist--;
    });
    dispatch_resume(timer);
}

-(void)startModInfoTimeCountDown
{
    self.timeForModInfo = VerificationCodeColdDurarion;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        if (self.timeForModInfo < 0) {
            dispatch_source_cancel(timer);
        }
        else{
            
            
        }
        
        self.timeForModInfo--;
    });
    dispatch_resume(timer);
}

@end
