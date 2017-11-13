//
//  FLLiveViewController.m
//  FLLiveShow
//
//  Created by 冯里 on 2017/7/15.
//  Copyright © 2017年 冯里. All rights reserved.
//

#import "FLLiveViewController.h"
#import "FLLivePreview.h"
@interface FLLiveViewController ()

@end

@implementation FLLiveViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    FLLivePreview *preView = [FLLivePreview viewFromXib];
    preView.frame = self.view.bounds;
    preView.LiveUrl = @"rtmp://192.168.0.66:1935/rtmplive/room";
    [self.view addSubview:preView];
    __weak typeof(self) weakSelf = self;
    [preView setExitLive:^{
        
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
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
