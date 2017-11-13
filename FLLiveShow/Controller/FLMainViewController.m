//
//  FLMainViewController.m
//  FLLiveShow
//
//  Created by 冯里 on 2017/7/15.
//  Copyright © 2017年 冯里. All rights reserved.
//

#import "FLMainViewController.h"
#import "FLLiveViewController.h"
#import "FLWatchLiveViewController.h"

@interface FLMainViewController ()
@property (weak, nonatomic) IBOutlet UIButton *startLiveBtn;
@property (weak, nonatomic) IBOutlet UIButton *watchLiveBtn;

@end

@implementation FLMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
}

- (void)setupUI {
    
    _startLiveBtn.layer.cornerRadius = 15;
    _watchLiveBtn.layer.cornerRadius = 15;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)startLive:(id)sender {
    
    FLLiveViewController *liveVC = [[FLLiveViewController alloc] init];
    [self presentViewController:liveVC animated:YES completion:nil];
}
- (IBAction)watchLive:(id)sender {
    
    FLWatchLiveViewController *watchVC = [[FLWatchLiveViewController alloc] init];
    [self presentViewController:watchVC animated:YES completion:nil];
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
