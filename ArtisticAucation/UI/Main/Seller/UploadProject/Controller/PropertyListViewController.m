//
//  PropertyListViewController.m
//  ArtisticAucation
//
//  Created by xieran on 15/11/6.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "PropertyListViewController.h"
#import "UploadItemViewController.h"
#import <objc/runtime.h>

@interface PropertyListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain)NSArray *propertyArray;
@property(nonatomic,retain)NSMutableDictionary *propertyDic;

@end

@implementation PropertyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"请选择属性";
    
    
    self.propertyArray = [[NSArray alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"PropertyList" ofType:@"plist"]];
    
//    _propertyDic = [[NSMutableDictionary alloc]init];
//    _propertyDic[@"水墨纂刻"] = @[@"传统水墨",@"书法",@"金石纂刻"];
//    _propertyDic[@"西画雕塑"] = @[@"油画",@"版画",@"水彩",@"水粉",@"雕塑",@"素描",@"摄影",@"漫画",@"设计艺术"];
//    _propertyDic[@"玉器珠宝"] = @[@"和田玉",@"翡翠",@"琥珀",@"玛瑙",@"贵重玉石",@"水晶",@"碧玺",@"钻石",@"黄龙玉",@"珍珠",@"石榴石",@"青金石",@"首饰设计",@"黄金",@"其他玉石"];
//    _propertyDic[@"紫砂陶瓷"] = @[@"紫砂",@"瓷器",@"陶器"];
//    _propertyDic[@"文玩收藏"] = @[@"砚台",@"核雕",@"毛笔",@"烟具/鼻烟壶",@"老墨",@"宣纸",@"乐器",@"钱币",@"邮票",@"连环画/古籍"];
//    _propertyDic[@"手工艺品"] = @[@"印石",@"木雕",@"铜/铁/锡器",@"石雕",@"刺绣",@"金/银器",@"琉璃",@"漆器/雕漆",@"珐琅/花丝",@"竹雕",@"泥雕",@"剪纸",@"其他工艺品"];
//    _propertyDic[@"茶酒滋补"] = @[@"国产白酒",@"葡萄酒",@"普洱茶",@"传统滋补营养品",@"洋酒",@"白茶",@"其他酒",@"其他茶"];
    
    
    
    self.table.backgroundView = [UIView backgroundView];
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.propertyArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"PropertyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.backgroundColor  =[UIColor colorWithWhite:1 alpha:0.3];
    
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textColor = BlackColor;
    cell.textLabel.text = self.propertyArray[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *propertyString = self.propertyArray[indexPath.row];
    [[NSNotificationCenter defaultCenter]postNotificationName:DidSelectSecondLevelProperty object:propertyString];
    [self.navigationController popViewControllerAnimated:YES];
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
