//
//  AuctionHallViewController+MessageManager.m
//  ArtisticAuction
//
//  Created by xie ran on 2017/6/2.
//  Copyright © 2017年 xieran. All rights reserved.
//

#import "AuctionHallViewController+MessageManager.h"

@implementation AuctionHallViewController (MessageManager)

-(void)handleMessageString:(NSString *)str
{
    MQTTMessageBaseModel *model = [[MQTTMessageBaseModel alloc]initWithString:str error:nil];
    
    switch (model.typeEnum) {
            //拍品信息
        case kMQTTMessageTypeItem:{
            AuctionHallCurrentItemModel *itemModel = [[AuctionHallCurrentItemModel alloc]initWithString:str error:nil];
            
            self.itemModel = itemModel;
            
            //图片
            [self.imgScrollView setImageUrls:itemModel.data.image];
            
            //名称
            self.stateView.nameLabel.text = itemModel.data.cname;
            
            //开始推拍品介绍
            self.itemIntroTimer.model = itemModel;
            
            if ([itemModel.data.phone isEqualToString:[BidManager sharedInstance].phone]) {
                self.stateView.priceLabel.text = [NSString stringWithFormat:@"¥%.0f(自己)",itemModel.data.endprice.floatValue];
            }
            else{
                self.stateView.priceLabel.text = [NSString stringWithFormat:@"¥%.0f",itemModel.data.endprice.floatValue];
            }
            self.bottomView.startPrice = [itemModel.data.endprice copy];
            
            
            [self.table scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
        }
            break;
            //出价
        case kMQTTMessageTypeBid:{
            AuctionHallBidModel *bidModel = [[AuctionHallBidModel alloc]initWithString:str error:nil];
            
            AuctionHallBidViewModel *bidViewModel = [[AuctionHallBidViewModel alloc]init];
            bidViewModel.dataModel = bidModel;
            [self.viewModels addViewModel:bidViewModel];
            
            [self.table reloadData];
            [self.table scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
            
            if ([bidModel.phone isEqualToString:[BidManager sharedInstance].phone]) {
                self.stateView.priceLabel.text = [NSString stringWithFormat:@"¥%.0f(自己)",bidModel.price.floatValue];
            }
            else{
                self.stateView.priceLabel.text = [NSString stringWithFormat:@"¥%.0f",bidModel.price.floatValue];
            }
            self.bottomView.startPrice = bidModel.price;
            
            
            self.itemModel.data.phone = bidModel.phone;
            
            [self.countDownView stop];
            
        }
            break;
            //成交
        case kMQTTMessageTypeDeal:{
            AuctionHallSystemModel *sysModel = [[AuctionHallSystemModel alloc]initWithString:str error:nil];
            
            AuctionHallSystemViewModel *viewModel = [[AuctionHallSystemViewModel alloc]init];
            viewModel.dataModel = sysModel;
            [self.viewModels addViewModel:viewModel];
            
            [self.table reloadData];
            [self.table scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
            
            
            //中断倒计时
            [self.countDownView stop];
            
        }
            break;
            //聊天
        case kMQTTMessageTypeChat:{
            AuctionHallChatModel *chatModel = [[AuctionHallChatModel alloc]initWithString:str error:nil];
            
            AuctionHallChatViewModel *viewModel = [[AuctionHallChatViewModel alloc]init];
            viewModel.dataModel = chatModel;
            [self.viewModels addViewModel:viewModel];
            
            [self.table reloadData];
            [self.table scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
            
        }
            break;
            //倒计时
        case kMQTTMessageTypeCountDown:
            //开始倒计时
            [self.countDownView showWithSecond:10];
            break;
        default:
            break;
    }
}

@end
