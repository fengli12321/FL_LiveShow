//
//  FLLivePreview.h
//  FLLiveShow
//
//  Created by 冯里 on 2017/7/15.
//  Copyright © 2017年 冯里. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FLLivePreview : UIView

@property (nonatomic, copy) NSString *LiveUrl;

@property (nonatomic, copy) void(^exitLive)();

@end
