//
//  AuctionHallInputView.m
//  ArtisticAuction
//
//  Created by xieran on 2017/4/25.
//  Copyright © 2017年 xieran. All rights reserved.
//

#import "AuctionHallInputView.h"

@interface AuctionHallInputView ()<UITextFieldDelegate>
{

}

@end

@implementation AuctionHallInputView

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if ([self.priceTf isFirstResponder] || [self.chatTf isFirstResponder]) {
        if (!CGRectContainsPoint(self.bounds, point)) {
            if ([self.priceTf isFirstResponder]) {
                [self.priceTf resignFirstResponder];
            }
            else if ([self.chatTf isFirstResponder]){
                [self.chatTf resignFirstResponder];
            }
        }
        return YES;
    }
    
    return [super pointInside:point withEvent:event];
}

-(void)awakeFromNib
{
    [super awakeFromNib];
        
    self.chatTf.delegate = self;
    
    self.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.9];
    
    UILabel *line = [[UILabel alloc]init];
    line.backgroundColor = [UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1];
    [self addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@0.5);
    }];
}

-(BOOL)isFirstResponder
{
    return [self.chatTf isFirstResponder] || [self.priceTf isFirstResponder];
}

-(BOOL)resignFirstResponder
{
    [super resignFirstResponder];
    
    [self.chatTf resignFirstResponder];
    [self.priceTf resignFirstResponder];
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return self.shouldBeginEditingBlock();
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if (textField == self.chatTf) {
        
        if (self.sendChatBlock && [self.chatTf.text stringByReplacingOccurrencesOfString:@" " withString:@""].length > 0) {
            self.sendChatBlock(self.chatTf.text);
        }
        
        self.chatTf.text = nil;
    }
    
    return YES;
}

-(void)setStartPrice:(NSString *)startPrice
{
    _startPrice = [startPrice copy];
    
    NSString *newPrice = [NSString stringWithFormat:@"%d",_startPrice.intValue / 100  * 100 + 100];
    self.priceTf.text = newPrice;
}

- (IBAction)priceMinus:(id)sender {
    NSString *price = self.priceTf.text;
    if ([FMUString isNumberVaild:price]) {
        NSInteger _price = (price.integerValue / 100 - 1) * 100;
        if (_price < 0) {
            _price = 0;
        }
        
        self.priceTf.text = [NSString stringWithFormat:@"%ld",(long)_price];
    }
}

- (IBAction)pricePlus:(id)sender {
    NSString *price = self.priceTf.text;
    if ([FMUString isNumberVaild:price]) {
        NSInteger _price = (price.integerValue / 100 + 1) * 100;
        
        self.priceTf.text = [NSString stringWithFormat:@"%ld",(long)_price];
    }
}

- (IBAction)switchMode:(id)sender {
    if ([self.chatTf isFirstResponder]) {
        [self.chatTf resignFirstResponder];
        
        self.chatTf.hidden = YES;
        self.priceView.hidden = NO;

        [self.switchBtn setImage:[UIImage imageNamed:@"hall_keyboard"] forState:UIControlStateNormal];
    }
    else if ([self.priceTf isFirstResponder]){
        [self.chatTf becomeFirstResponder];
        
        self.chatTf.hidden = NO;
        self.priceView.hidden = YES;
        
        [self.switchBtn setImage:[UIImage imageNamed:@"hall_bid"] forState:UIControlStateNormal];
    }
    else{
        if (self.chatTf.hidden) {
            BOOL shouldBid = self.shouldBeginEditingBlock();
            if (!shouldBid) {
                return;
            }
            
            [self.chatTf becomeFirstResponder];
            
            self.chatTf.hidden = NO;
            self.priceView.hidden = YES;
            
            [self.switchBtn setImage:[UIImage imageNamed:@"hall_bid"] forState:UIControlStateNormal];
        }
        else{
            self.chatTf.hidden = YES;
            self.priceView.hidden = NO;
            
            [self.switchBtn setImage:[UIImage imageNamed:@"hall_keyboard"] forState:UIControlStateNormal];
        }
    }
}

- (IBAction)bid:(id)sender {
    if (![FMUString isNumberVaild:self.priceTf.text] || self.priceTf.text.intValue % 100 != 0) {
        [[UIApplication sharedApplication].keyWindow showHudAndAutoDismiss:@"出价必须是100的倍数"];
        return;
    }
    if (self.priceTf.text.intValue <= self.startPrice.intValue) {
        [[UIApplication sharedApplication].keyWindow showHudAndAutoDismiss:@"出价不得低于当前价格"];
        return;
    }
    
    BOOL shouldBid = self.shouldBeginEditingBlock();
    if (!shouldBid) {
        return;
    }
    
    [self.priceTf resignFirstResponder];
    
    self.bidBlock(self.priceTf.text);
}
@end
