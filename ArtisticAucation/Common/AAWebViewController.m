//
//  AAWebViewController.m
//  ArtisticAucation
//
//  Created by xieran on 16/1/22.
//  Copyright © 2016年 xieran. All rights reserved.
//

#import "AAWebViewController.h"

@interface AAWebViewController ()

@end

@implementation AAWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (![self.url hasPrefix:@"http://"]) {
        self.url = [NSString stringWithFormat:@"http://%@",self.url];
    }
    
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
