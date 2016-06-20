//
//  UploadProViewController.h
//  ArtisticAucation
//
//  Created by Haley on 15/11/2.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "BaseViewController.h"

@interface UploadListViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIImageView *addImageButton;
@property (weak, nonatomic) IBOutlet UIImageView *occasionImageView;

- (IBAction)add:(id)sender;

- (IBAction)addImage:(id)sender;

@end
