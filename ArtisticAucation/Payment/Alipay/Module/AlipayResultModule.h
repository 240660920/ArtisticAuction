//
//  AlipayResultModule.h
//  ArtisticAucation
//
//  Created by xieran on 15/10/15.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlipayResultModule : NSObject

@property(nonatomic,assign)NSInteger resultCode;
@property(nonatomic,copy)NSString *sign;
@property(nonatomic,copy)NSString *orderInfo;

-(id)initWithDictionary:(NSDictionary *)dic;

@end
