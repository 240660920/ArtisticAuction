//
//  AucationDetailMoreView.h
//  ArtisticAucation
//
//  Created by xieran on 15/10/21.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AucationItemDescriptionCell : UITableViewCell

@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)UILabel *titlelabel;

+(CGFloat)heightForText:(NSString *)text;

@end
