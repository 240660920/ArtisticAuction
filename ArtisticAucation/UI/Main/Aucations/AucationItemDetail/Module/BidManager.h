//
//  BidManager.h
//  ArtisticAucation
//
//  Created by xieran on 16/1/28.
//  Copyright © 2016年 xieran. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BidPhoneKey [NSString stringWithFormat:@"preBidPhone&userid=%@",[UserInfo sharedInstance].userId]
#define BidUsernameKey [NSString stringWithFormat:@"preBidUsername&userid=%@",[UserInfo sharedInstance].userId]

@interface BidManager : NSObject


+(BidManager *)sharedInstance;

-(void)preDisplayBid:(NSString *)price oid:(NSString *)oid cid:(NSString *)cid;

@end
