//
//  AucationDetailViewController.h
//  ArtisticAucation
//
//  Created by xieran on 15/10/21.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "BaseViewController.h"
#import "AucationItemsListResponse.h"

@interface AucationItemDetailViewController : BaseViewController

@property(nonatomic,copy)NSString *cid;
@property(nonatomic,assign)BOOL shouldHideBottomView;

@end
