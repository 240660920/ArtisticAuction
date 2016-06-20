//
//  CommonRequests.h
//  ArtisticAucation
//
//  Created by xieran on 15/10/23.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    kPreferenceTypeLike,
    kPreferenceTypeCollect,
} PreferenceType;

@interface CommonRequests : NSObject

+(void)itemPreferenceRequestWithModel:(id)model
                             itemType:(ItemType )itemType
                       preferenceType:(PreferenceType)preferenceType
                       viewController:(UIViewController *)controller
                               button:(UIButton *)button;

@end
