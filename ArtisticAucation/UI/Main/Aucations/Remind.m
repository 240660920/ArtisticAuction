//
//  Remind.m
//  ArtisticAucation
//
//  Created by xieran on 15/11/19.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "Remind.h"

#define SecondsBeforeRemind1 1800
#define SecondsBeforeRemind2 600

@implementation Remind

+(NSString *)getAlertStringWithLeftTimeInterval:(NSTimeInterval )leftTimeInterval
{
    if (leftTimeInterval < 60) {
        return [NSString stringWithFormat:@"距开始还有\n%d秒",(int)leftTimeInterval];
    }
    else if (leftTimeInterval >= 60 && leftTimeInterval < 3600){
        int minutes = leftTimeInterval / 60;
        int seconds = leftTimeInterval - minutes * 60;
        return [NSString stringWithFormat:@"距开始还有\n%d分%d秒",minutes,seconds];
    }
    else if (leftTimeInterval >= 3600 && leftTimeInterval < 24 * 3600){
        int hours = leftTimeInterval / 3600;
        int minutes = (leftTimeInterval - hours * 3600) / 60;
        int seconds = leftTimeInterval - hours * 3600 - minutes * 60;
        return [NSString stringWithFormat:@"距开始还有\n%d小时%d分%d秒",hours,minutes,seconds];
    }
    else{
        int days = leftTimeInterval / (24 * 3600);
        int hours = (leftTimeInterval - days * 24 * 3600) / 3600;
        int minutes = (leftTimeInterval - days * 24 * 3600 - hours * 3600) / 60;
        int seconds = leftTimeInterval - days * 24 * 3600 - hours * 3600 - minutes * 60;
        return [NSString stringWithFormat:@"距开始还有\n%d天%d小时%d分%d秒",days,hours,minutes,seconds];
    }
}

+(void)setRemindWithSessionId:(NSString *)sessionId startTime:(NSString *)startTime andOccasionName:(NSString *)occasionName remindButton:(RemindButton *)remindButton
{
    if (!remindButton.selected) {
        NSTimeInterval leftTime = [TimeManager timeIntervalBetweenServerTimeAndTime:startTime];
        
        
        [HttpManager requestWithAPI:@"company/addMyRemind" params:@{@"userid" : [UserInfo sharedInstance].userId , @"oid" : sessionId} requestMethod:@"GET" completion:^(ASIFormDataRequest *request) {
            NSDictionary *rstDic = [request.responseString objectFromJSONString];
            
            if ([rstDic[@"result"][@"resultCode"]intValue] == 0) {
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"设置提醒成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                
                //开始时提醒
                [self setRemindWithTime:leftTime key:[NSString stringWithFormat:@"%@0",sessionId] occasionName:occasionName timeCountDown:0];

                //开始前10分钟提醒
                if (leftTime > SecondsBeforeRemind2) {
                    [self setRemindWithTime:leftTime key:[NSString stringWithFormat:@"%@1",sessionId] occasionName:occasionName timeCountDown:SecondsBeforeRemind2];
                }
                //开始前30分钟提醒
                if (leftTime > SecondsBeforeRemind1) {
                    [self setRemindWithTime:leftTime  key:[NSString stringWithFormat:@"%@2",sessionId] occasionName:occasionName timeCountDown:SecondsBeforeRemind1];
                }
                
                remindButton.selected = YES;
            }
            else{
                [[UIApplication sharedApplication].keyWindow showHudAndAutoDismiss:@"请求失败"];
            }
            
        } failed:^(ASIFormDataRequest *request) {
            [[UIApplication sharedApplication].keyWindow showHudAndAutoDismiss:NetworkErrorPrompt];
        }];
        
    }
    else{
        [self deleteRemindWithOid:sessionId successBlock:^{
            
            remindButton.selected = NO;
            
            [[UIApplication sharedApplication].keyWindow showHudAndAutoDismiss:@"已取消提醒"];

        } failedBlock:^{
            
        }];
    }
}

+(void)setRemindWithTime:(NSTimeInterval )leftTime key:(NSString *)key occasionName:(NSString *)occasionName timeCountDown:(NSInteger )timeCountDown
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    if (notification != nil) {
        NSDate *now = [NSDate new];
        notification.userInfo = @{@"LocalNotificationKey" : key , @"occasionName" : occasionName};
        notification.fireDate = [now dateByAddingTimeInterval:leftTime - timeCountDown];//
        notification.timeZone = [NSTimeZone defaultTimeZone];
        if (timeCountDown / 60 > 0) {
            notification.alertBody = [NSString stringWithFormat:@"%@\n还有%ld分钟就要开始了!",occasionName,timeCountDown / 60];
        }
        else{
            notification.alertBody = [NSString stringWithFormat:@"%@\n已经开始了",occasionName];
        }
        notification.soundName = @"default";
        [notification setApplicationIconBadgeNumber:1];
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

+(void)deleteRemindWithOid:(NSString *)oid successBlock:(void (^)(void))successBlock failedBlock:(void (^)(void))failedBlock
{
    [HttpManager requestWithAPI:@"company/removeMyRemind" params:@{@"oid" : oid , @"userid" : [UserInfo sharedInstance].userId} requestMethod:@"GET" completion:^(ASIFormDataRequest *request) {
        
        NSDictionary *rstDic = [request.responseString objectFromJSONString];
        if ([rstDic[@"result"][@"resultCode"]intValue] == 0) {
            [Remind removeLocalRemindWithSessionID:oid];
            
            successBlock();
        }
        else{
            [[UIApplication sharedApplication].keyWindow showHudAndAutoDismiss:@"请求失败"];
            
            failedBlock();
        }

        
    } failed:^(ASIFormDataRequest *request) {
        [[UIApplication sharedApplication].keyWindow showHudAndAutoDismiss:NetworkErrorPrompt];
        
        failedBlock();
    }];
}

+(void)removeLocalRemindWithSessionID:(NSString *)sessionID
{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *localArr = [app scheduledLocalNotifications];
    
    if (localArr)
    {
        for (UILocalNotification *noti in localArr)
        {
            NSDictionary *dict = noti.userInfo;
            if (dict)
            {
                NSString *inKey = [dict objectForKey:@"LocalNotificationKey"];
                if ([inKey rangeOfString:sessionID].length > 0)
                {
                    [app cancelLocalNotification:noti];
                    break;
                }
            }
        }
    }
}

@end
