//
//  AAWebViewController.h
//  ArtisticAucation
//
//  Created by xieran on 16/1/22.
//  Copyright © 2016年 xieran. All rights reserved.
//

#import "BaseViewController.h"

@interface AAWebViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property(nonatomic,copy)NSString *url;

@end
