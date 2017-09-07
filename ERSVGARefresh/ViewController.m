//
//  ViewController.m
//  ERSVGARefresh
//
//  Created by 詹瞻 on 2017/9/6.
//  Copyright © 2017年 developZHAN. All rights reserved.
//

#import "ViewController.h"
#import "ERRefreshSVGAHeader.h"
#import "YYFPSLabel.h"

@interface ViewController ()

@property (nonatomic, strong) YYFPSLabel *fpsLabel;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ERRefreshSVGAHeader *header = [ERRefreshSVGAHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];

    [header setAnimationWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"loading.svga" ofType:nil]] forState:MJRefreshStateIdle];
    
    // 设置普通状态的动画图片
//    [header setAnimationWithURL:[NSURL URLWithString:@"https://github.com/yyued/SVGA-Samples/blob/master/TwitterHeart.svga?raw=true"] forState:MJRefreshStateIdle];
    
    //    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    //    [header setAnimationWithURL:[NSURL URLWithString:@"https://github.com/yyued/SVGA-Samples/blob/master/TwitterHeart.svga?raw=true"] forState:MJRefreshStatePulling];
    //
    //    // 设置正在刷新状态的动画图片
    //    [header setAnimationWithURL:[NSURL URLWithString:@"https://github.com/yyued/SVGA-Samples/blob/master/TwitterHeart.svga?raw=true"] forState:MJRefreshStateRefreshing];
    
    self.tableView.mj_header = header;
    
    
    [self testFPSLabel];
}

- (void)loadNewData{
    
    NSLog(@"正在加载数据...");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"数据加载完毕...");
        [self.tableView.mj_header endRefreshing];
    });
}

- (void)testFPSLabel {
    _fpsLabel = [YYFPSLabel new];
    _fpsLabel.mj_size = CGSizeMake(50, 30);
    _fpsLabel.mj_x = self.view.mj_w - 54;
    _fpsLabel.mj_y = 10;
    
    [_fpsLabel sizeToFit];
    [self.navigationController.navigationBar addSubview:_fpsLabel];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [self.tableView.mj_header beginRefreshing];
    }
}

@end
