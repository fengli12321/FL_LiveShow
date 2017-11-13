//
//  FLWatchLiveViewController.m
//  FLLiveShow
//
//  Created by 冯里 on 2017/7/26.
//  Copyright © 2017年 冯里. All rights reserved.
//

#import "FLWatchLiveViewController.h"
#import <IJKMediaFramework/IJKMediaFramework.h>

@interface FLWatchLiveViewController ()

@property (weak, nonatomic) IBOutlet UIButton *watchBtn;
@property (weak, nonatomic) IBOutlet UIButton *exitBtn;
@property (nonatomic, strong) IJKFFMoviePlayerController *player;
@property (nonatomic, strong) IBOutlet UIView *playerView;

@end

@implementation FLWatchLiveViewController
#pragma mark - Lazy
- (IJKFFMoviePlayerController *)player {
    if (!_player) {
        _player = [[IJKFFMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:@"rtmp://192.168.0.66:1935/rtmplive/room"] withOptions:[IJKFFOptions optionsByDefault]];
        
        [self.playerView insertSubview:_player.view atIndex:0];
    }
    return _player;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.watchBtn.layerCornerRadius = 8;
    self.exitBtn.layerCornerRadius = 8;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.player stop];
    [self.player shutdown];
}
- (void)dealloc {
    FLLog(@"页面销毁");
}
- (IBAction)watchAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        
        [self.player prepareToPlay];
    }
    else {
        [self.player stop];
    }
}


- (IBAction)exit:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
