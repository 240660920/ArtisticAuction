//
//  AuctionHallItemIntroTimer.m
//  ArtisticAuction
//
//  Created by xieran on 2017/5/19.
//  Copyright © 2017年 xieran. All rights reserved.
//

#import "AuctionHallItemIntroTimer.h"

@interface AuctionHallItemIntroTimer ()

@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,strong)NSThread *thread;
@property(nonatomic,strong)NSMutableArray *taskArray;

@property(nonatomic,assign)NSInteger currentIndex;
@property(nonatomic,assign)NSTimeInterval timeInterval;

@end

@implementation AuctionHallItemIntroTimer

-(void)dealloc
{

}

-(id)init
{
    if (self = [super init]) {
        self.currentIndex = 0;
        
        _taskArray = [[NSMutableArray alloc]init];
        
        self.timeInterval = 5; //执行间隔
    }
    return self;
}

-(void)createTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSString *text = self.taskArray[self.currentIndex];
        [self performSelectorOnMainThread:@selector(excuteInsertBlock:) withObject:text waitUntilDone:NO];

        self.currentIndex++;
        
        if (self.currentIndex == self.taskArray.count) {
            [self stop];
        }
    }];
    [self.timer setFireDate:[NSDate date]];
    
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
    CFRunLoopRun();
    
}

-(void)setModel:(AuctionHallCurrentItemModel *)model
{
    if (_model != model) {
        _model = model;
    }
    
    if (self.thread) {
        [self stop];
    }
    
    /************拍品介绍***********/
    AuctionHallCurrentItemDataModel *dataModel = model.data;
    
    //编号
    NSString *index = [NSString stringWithFormat:@"本件拍品编号：LOT%ld",(long)model.index];
    [self.taskArray addObject:index];
    
    //名称
    NSString *name = [NSString stringWithFormat:@"品名：%@",dataModel.cname ? dataModel.cname : @""];
    [self.taskArray addObject:name];
    
    NSArray *features = [dataModel.features componentsSeparatedByString:@";&"];
    if (features.count == 3) {
        //尺寸
        NSString *_size = [dataModel.features componentsSeparatedByString:@";&"][0];
        NSString *size = [NSString stringWithFormat:@"尺寸：%@",_size];
        [self.taskArray addObject:size];
        
        //材质
        NSString *_texure = [dataModel.features componentsSeparatedByString:@";&"][1];
        NSString *texure = [NSString stringWithFormat:@"材质：%@",_texure];
        [self.taskArray addObject:texure];
        
        
        //作者及简介
        NSString *_authorAndIntro = [dataModel.features componentsSeparatedByString:@";&"][2];
        NSString *authorAndIntro = [NSString stringWithFormat:@"作者及简介：%@",_authorAndIntro];
        [self.taskArray addObject:authorAndIntro];
    }
    
    NSString *analyse = [NSString stringWithFormat:@"拍品赏析：%@",dataModel.analyse ? dataModel.analyse : @"暂无"];
    [self.taskArray addObject:analyse];
    /************拍品介绍***********/

    
    self.thread = [[NSThread alloc]initWithTarget:self selector:@selector(createTimer) object:nil];
    [self.thread start];
}

-(void)excuteInsertBlock:(NSString *)text
{
    if (self.insertModelBlock) {
        self.insertModelBlock(text);
    }
}

-(void)stop
{
    [self.timer invalidate];
    self.timer = nil;
    
    [self.taskArray removeAllObjects];
    
    [[NSThread currentThread] cancel];
    
    CFRunLoopStop(CFRunLoopGetCurrent());
}

@end
