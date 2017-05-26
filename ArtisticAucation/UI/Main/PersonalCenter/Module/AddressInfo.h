//
//  PersonalInfo.h
//  ArtisticAucation
//
//  Created by xieran on 15/11/28.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressInfo : NSObject<NSCoding>

@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *phoneNum;
@property(nonatomic,copy)NSString *address;

@end
