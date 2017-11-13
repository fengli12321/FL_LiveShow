//
//  FLLivePreview.m
//  FLLiveShow
//
//  Created by 冯里 on 2017/7/15.
//  Copyright © 2017年 冯里. All rights reserved.
//

#import "FLLivePreview.h"
#import "LFLiveSession.h"

inline static NSString *formatedSpeed(float bytes, float elapsed_milli) {
    
    
    if (elapsed_milli <= 0) {
        return @"N/A";
    }
    
    if (bytes <= 0) {
        return @"0 KB/s";
    }
    
    float bytes_per_sec = ((float)bytes) * 1000.f /  elapsed_milli;
    if (bytes_per_sec >= 1000 * 1000) {
        return [NSString stringWithFormat:@"%.2f MB/s", ((float)bytes_per_sec) / 1000 / 1000];
    } else if (bytes_per_sec >= 1000) {
        return [NSString stringWithFormat:@"%.1f KB/s", ((float)bytes_per_sec) / 1000];
    } else {
        return [NSString stringWithFormat:@"%ld B/s", (long)bytes_per_sec];
    }
}

@interface FLLivePreview () <LFLiveSessionDelegate>

@property (weak, nonatomic) IBOutlet UIView *overlayView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *liveStatusLabel;
@property (weak, nonatomic) IBOutlet UIButton *startLiveBtn;
@property (weak, nonatomic) IBOutlet UIButton *cameraBtn;
@property (weak, nonatomic) IBOutlet UIButton *beautyBtn;
@property (weak, nonatomic) IBOutlet UIButton *lightBtn;
@property (weak, nonatomic) IBOutlet UIButton *mirrorBtn;
@property (weak, nonatomic) IBOutlet UIButton *exitBtn;


/** 来疯直播Session */
@property (nonatomic, strong) LFLiveSession *session;

/** 灯泡状态,默认为关闭 */
@property (nonatomic) AVCaptureTorchMode torchMode;

@property (nonatomic, strong) AVCaptureDevice *captureDevice;

@end
@implementation FLLivePreview

- (LFLiveSession *)session {
    if (!_session) {
        _session = [[LFLiveSession alloc] initWithAudioConfiguration:[LFLiveAudioConfiguration defaultConfiguration] videoConfiguration:[LFLiveVideoConfiguration defaultConfigurationForQuality:LFLiveVideoQuality_Medium3 outputImageOrientation:UIInterfaceOrientationPortrait]];
        _session.delegate = self;
        _session.showDebugInfo = YES;
        _session.preView = self.overlayView;
    }
    return _session;
}

#pragma mark - override
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.autoresizingMask = UIViewAutoresizingNone;
    
    // 灯泡默认关闭
    _captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    _torchMode = AVCaptureTorchModeOff;
    
    // icon
    _iconImageView.layerCornerRadius = _iconImageView.width * 0.5;
    
    
    // 开始直播按钮
    _startLiveBtn.layerCornerRadius = 24;
    _startLiveBtn.exclusiveTouch = YES;
    [_startLiveBtn addTarget:self action:@selector(startOrEndLive:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _exitBtn.layerCornerRadius = 24;
    
    // 美颜按钮
    _beautyBtn.exclusiveTouch = YES;
    
    // 旋转相机按钮
    _cameraBtn.exclusiveTouch = YES;
    
    // 灯泡
    _lightBtn.exclusiveTouch = YES;
    
    // 镜子
    _mirrorBtn.exclusiveTouch = YES;
    
    // 开启摄像头授权
    [self requestAccessForVideo];
    
    // 开启麦克风授权
    [self requestAccessForAudio];
}

#pragma mark - 授权
- (void)requestAccessForVideo{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined: {
            // 许可对话没有出现，发起授权许可
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self.session setRunning:YES];
                    });
                }
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized: {
            // 已经开启授权，可继续
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.session setRunning:YES];
            });
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            // 用户明确地拒绝授权，或者相机设备无法访问
            
            break;
        default:
            break;
    }
}

- (void)requestAccessForAudio {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (status) {
        case AVAuthorizationStatusNotDetermined: {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized: {
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            break;
        default:
            break;
    }
}


#pragma mark - btnEvent
- (IBAction)exitLiveShow:(id)sender {
    [self.session stopLive];

    if (self.exitLive) {
        self.exitLive();
    }
}
- (IBAction)startOrEndLive:(UIButton *)liveBtn {
    
    liveBtn.selected = !liveBtn.selected;
    if (liveBtn.selected) {
        [liveBtn setTitle:@"结束直播" forState:UIControlStateNormal];
        LFLiveStreamInfo *stream = [LFLiveStreamInfo new];
        stream.url = self.LiveUrl;
        [self.session startLive:stream];
    } else {
        [liveBtn setTitle:@"开始直播" forState:UIControlStateNormal];
        [self.session stopLive];
    }
}
- (IBAction)beautify:(UIButton *)sender {
    self.session.beautyFace = !self.session.beautyFace;
    _beautyBtn.selected = !_beautyBtn.selected;
}
- (IBAction)cameraDirection:(UIButton *)sender {
    AVCaptureDevicePosition devicePostion = self.session.captureDevicePosition;
    self.session.captureDevicePosition = devicePostion == AVCaptureDevicePositionBack ? AVCaptureDevicePositionFront : AVCaptureDevicePositionBack;
}
- (IBAction)lightSwitch:(id)sender {
    [self.session setTorch:!self.session.torch];
}
- (IBAction)mirroSwitch:(id)sender {
    
    [self.session setMirror:!self.session.mirror];
    self.mirrorBtn.selected = !self.mirrorBtn.selected;
}

#pragma mark -- LFStreamingSessionDelegate
- (void)liveSession:(LFLiveSession *)session liveStateDidChange:(LFLiveState)state {
    switch (state) {
        case LFLiveReady:
            FLLog(@"未连接");
            self.liveStatusLabel.text = @"未连接";
            break;
        case LFLivePending:
            FLLog(@"连接中");
            self.liveStatusLabel.text = @"正在连接...";
            break;
        case LFLiveStart:
            FLLog(@"已连接");
            self.liveStatusLabel.text = @"正在直播";
            break;
        case LFLiveError:
            FLLog(@"连接错误");
            self.liveStatusLabel.text = @"未连接";
            break;
        case LFLiveStop:
            self.liveStatusLabel.text = @"未连接";
            FLLog(@"未连接");
            break;
        default:
            break;
    }
}


/** 直播debug信息 */
- (void)liveSession:(nullable LFLiveSession *)session debugInfo:(nullable LFLiveDebug *)debugInfo {
    FLLog(@"debugInfo uploadSpeed: %@", formatedSpeed(debugInfo.currentBandwidth, debugInfo.elapsedMilli));
}

/** socket回调错误信息 */
- (void)liveSession:(nullable LFLiveSession *)session errorCode:(LFLiveSocketErrorCode)errorCode {
    FLLog(@"errorCode: %ld", errorCode);
}
- (void)dealloc {
    FLLog(@"直播视图释放");
}

@end
