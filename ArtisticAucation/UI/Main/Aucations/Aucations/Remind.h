//
//  Remind.h
//  ArtisticAucation
//
//  Created by xieran on 15/11/19.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RemindButton.h"

@interface Remind : NSObject

+(void)setRemindWithSessionId:(NSString *)sessionId startTime:(NSString *)startTime andOccasionName:(NSString *)occasionName remindButton:(RemindButton *)remindButton;

+(void)deleteRemindWithOid:(NSString *)oid successBlock:(void(^)(void))successBlock failedBlock:(void(^)(void))failedBlock;

+(void)removeLocalRemindWithSessionID:(NSString *)sessionID;

+(NSString *)getAlertStringWithLeftTimeInterval:(NSTimeInterval )leftTimeInterval;

@end
