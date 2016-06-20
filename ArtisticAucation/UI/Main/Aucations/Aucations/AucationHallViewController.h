//
//  AucationHallViewController.h
//  ArtisticAucation
//
//  Created by xieran on 15/11/20.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "BaseViewController.h"

@interface AucationHallViewController : BaseViewController

@property(nonatomic,copy)NSString *oid;
@property(nonatomic,copy)NSString *agencyName;
@property(nonatomic,copy)NSString *occasionName;

-(id)initWithOid:(NSString *)oid agencyName:(NSString *)agencyName occasionName:(NSString *)occasionName;

@end
