//
//  UIView+FLLayer.m
//  FLLiveShow
//
//  Created by 冯里 on 2017/7/25.
//  Copyright © 2017年 冯里. All rights reserved.
//

#import "UIView+FLLayer.h"

@implementation UIView (FLLayer)

- (void)setLayerBorderWidth:(CGFloat)layerBorderWidth
{
    self.layer.borderWidth = layerBorderWidth;
    [self _config];
}

- (CGFloat)layerBorderWidth
{
    return self.layer.borderWidth;
}

- (void)setLayerCornerRadius:(CGFloat)layerCornerRadius
{
    self.layer.cornerRadius = layerCornerRadius;
    [self _config];
}

- (CGFloat)layerCornerRadius
{
    return self.layer.cornerRadius;
}

- (void)setLayerBorderColor:(UIColor *)layerBorderColor
{
    self.layer.borderColor = layerBorderColor.CGColor;
    [self _config];
}

- (UIColor *)layerBorderColor
{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)_config
{
    self.layer.masksToBounds = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.layer.shouldRasterize = YES;
}


@end
