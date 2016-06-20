//
//  ModifyInfoCell.h
//  ArtisticAucation
//
//  Created by xieran on 15/10/12.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModifyInfoCell : UITableViewCell

@property(nonatomic,copy)NSString *labelText;
@property(nonatomic,copy)NSString *placeHolder;

@property(nonatomic,strong)UILabel *leftLabel;
@property(nonatomic,strong)UILabel *placeHolderLabel;
@property(nonatomic,strong)UITextView *rightTextView;

@end
