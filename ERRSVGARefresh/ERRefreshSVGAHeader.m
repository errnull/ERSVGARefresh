//
//  ERRefreshSVGAHeader.m
//  ERSVGARefresh
//
//  Created by 詹瞻 on 2017/9/6.
//  Copyright © 2017年 developZHAN. All rights reserved.
//

#import "ERRefreshSVGAHeader.h"
#import "SVGAVideoEntity.h"
#import <AudioToolbox/AudioToolbox.h>

@interface ERRefreshSVGAHeader()
{
    __unsafe_unretained SVGAPlayer * _aPlayer;
}
@property (nonatomic, strong) NSDictionary *stateCache;
@end

@implementation ERRefreshSVGAHeader

static SVGAParser *_parser;

#pragma 懒加载
- (SVGAPlayer *)aPlayer {
    if (!_aPlayer) {
        SVGAPlayer *player = [[SVGAPlayer alloc] init];
        [self addSubview:_aPlayer = player];
    }
    return _aPlayer;
}

- (SVGAParser *)parser {
    if (!_parser) {
        _parser = [[SVGAParser alloc] init];
    }
    return _parser;
}

- (NSDictionary *)stateCache{
    if (!_stateCache) {
        _stateCache = @{
                        @(MJRefreshStateIdle) : @"MJRefreshStateIdle",
                        
                        @(MJRefreshStatePulling) : @"MJRefreshStatePulling",
                        
                        @(MJRefreshStateRefreshing) : @"MJRefreshStateRefreshing",
                        
                        @(MJRefreshStateWillRefresh) : @"MJRefreshStateWillRefresh",
                        
                        @(MJRefreshStateNoMoreData) : @"MJRefreshStateNoMoreData"
                        };
    }
    return _stateCache;
}
#pragma Public Method

- (void)setAnimationWithURL:(nonnull NSURL *)svgaURL
                   forState:(MJRefreshState)state
{
    [[self parser] parseWithURL:svgaURL
                completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
                    
                } failureBlock:nil];
}

- (void)setAnimationWithData:(NSData *)data
                    forState:(MJRefreshState)state {

        [[self parser] parseWithData:data
                            cacheKey:self.stateCache[@(state)]
                     completionBlock:nil
                        failureBlock:nil];
}

#pragma 父类方法
- (void)prepare{
    [super prepare];
    
    // 初始化间距
    self.labelLeftInset = 20;
}

- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    
    if (self.state != MJRefreshStateIdle || !self.aPlayer || pullingPercent > 1) return;
    
    if (self.aPlayer.videoItem != [SVGAVideoEntity readCache:self.stateCache[@(MJRefreshStateIdle)]]){
        self.aPlayer.videoItem = [SVGAVideoEntity readCache:self.stateCache[@(MJRefreshStateIdle)]];
    }
    
    [self.aPlayer stepToPercentage:pullingPercent andPlay:NO];
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    self.mj_h = 60;
    
    self.stateLabel.hidden = YES;
    self.lastUpdatedTimeLabel.hidden = YES;
    
    self.aPlayer.stopWhenTracking = NO;
//    self.aPlayer.mj_size = self.aPlayer.videoItem.videoSize;
    self.aPlayer.mj_size = CGSizeMake(80, 60);
    self.aPlayer.mj_x = self.center.x - 30;
    
    
//    self.aPlayer.frame = self.bounds;
//    if (self.stateLabel.hidden && self.lastUpdatedTimeLabel.hidden) {
//    self.aPlayer.contentMode = UIViewContentModeCenter;
//    } else {
//        self.aPlayer.contentMode = UIViewContentModeRight;
//        
//        CGFloat stateWidth = self.stateLabel.mj_textWith;
//        CGFloat timeWidth = 0.0;
//        if (!self.lastUpdatedTimeLabel.hidden) {
//            timeWidth = self.lastUpdatedTimeLabel.mj_textWith;
//        }
//        CGFloat textWidth = MAX(stateWidth, timeWidth);
//        self.aPlayer.mj_w = self.mj_w * 0.5 - textWidth * 0.5 - self.labelLeftInset;
//    }
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    // 根据状态做事情
    if (state == MJRefreshStatePulling || state == MJRefreshStateRefreshing) {
        self.aPlayer.videoItem = [SVGAVideoEntity readCache:self.stateCache[@(state)]];
        [self.aPlayer stepToFrame:0 andPlay:YES];
        
    } else if (state == MJRefreshStateIdle) {
        [self.aPlayer stopAnimation];
    }
}

@end
