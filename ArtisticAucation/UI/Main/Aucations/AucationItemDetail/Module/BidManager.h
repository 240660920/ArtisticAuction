//
//  BidManager.h
//  ArtisticAucation
//
//  Created by xieran on 16/1/28.
//  Copyright © 2016年 xieran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BidManager : NSObject

@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *phone;

+(BidManager *)sharedInstance;

-(void)preDisplayBid:(NSString *)price oid:(NSString *)oid cid:(NSString *)cid;

-(void)showInputNameAndPhoneAlert;

@end
