//
//  ERRefreshSVGAHeader.h
//  ERSVGARefresh
//
//  Created by 詹瞻 on 2017/9/6.
//  Copyright © 2017年 developZHAN. All rights reserved.
//

#import "MJRefresh.h"
#import "SVGA.h"

@class SVGAVideoEntity;
@interface ERRefreshSVGAHeader : MJRefreshStateHeader

@property (weak, nonatomic, readonly) SVGAPlayer * _Nullable aPlayer;

- (void)setAnimationWithURL:(nonnull NSURL *)svgaURL
                   forState:(MJRefreshState)state;

- (void)setAnimationWithData:(nonnull NSData *)data
                   forState:(MJRefreshState)state;

@end
