//
//  UIView+FLLayer.h
//  FLLiveShow
//
//  Created by 冯里 on 2017/7/25.
//  Copyright © 2017年 冯里. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FLLayer)

@property (nonatomic, assign) CGFloat layerCornerRadius;

@property (nonatomic, assign) CGFloat layerBorderWidth;

@property (nonatomic, strong) UIColor *layerBorderColor;

@end
