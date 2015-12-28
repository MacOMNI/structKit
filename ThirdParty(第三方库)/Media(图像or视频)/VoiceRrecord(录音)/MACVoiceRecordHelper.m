//
//  MACVoiceRecordHelper.h
//  WeSchoolStudent
//  Created by MacKun on 15/11/10.
#import "MACVoiceRecordHelper.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
@interface MACVoiceRecordHelper () <AVAudioRecorderDelegate> {
    NSTimer *_timer;
    
    BOOL _isPause;
    
#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
    UIBackgroundTaskIdentifier _backgroundIdentifier;
#endif
}

@property (nonatomic, copy, readwrite) NSString *recordPath;
@property (nonatomic, readwrite) NSTimeInterval currentTimeInterval;

@property (nonatomic, strong) AVAudioRecorder *recorder;

@end

@implementation MACVoiceRecordHelper

- (id)init {
    self = [super init];
    if (self) {
        self.maxRecordTime = 60;
        self.recordDuration = @"0";
#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
        _backgroundIdentifier = UIBackgroundTaskInvalid;
#endif
    }
    return self;
}

- (void)dealloc {
    [self stopRecord];
    self.recordPath = nil;
    [self stopBackgroundTask];
}

- (void)startBackgroundTask {
    [self stopBackgroundTask];
    
#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
    _backgroundIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [self stopBackgroundTask];
    }];
#endif
}

- (void)stopBackgroundTask {
#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
    if (_backgroundIdentifier != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:_backgroundIdentifier];
        _backgroundIdentifier = UIBackgroundTaskInvalid;
    }
#endif
}

- (void)resetTimer {
    if (!_timer)
        return;
    
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    
}

- (void)cancelRecording {
    if (!_recorder)
        return;
    
    if (self.recorder.isRecording) {
        [self.recorder stop];
    }
    
    self.recorder = nil;
}

- (void)stopRecord {
    [self cancelRecording];
    [self resetTimer];
}
- (NSString *)getRecorderPath {
    NSString *recorderPath = nil;
    recorderPath = [NSTemporaryDirectory() stringByAppendingString:@"selfRecord.caf"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:recorderPath]) {
        [fileManager removeItemAtPath:recorderPath error:nil];
    }
    return recorderPath;
}

- (void)prepareRecordingWithPath:(NSString *)path prepareRecorderCompletion:(MACPrepareRecorderCompletion)prepareRecorderCompletion {
    path=[self getRecorderPath];
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _isPause = NO;
        
        NSError *error = nil;
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&error];
        if(error) {
            DLog(@"audioSession: %@ %ld %@", [error domain], (long)[error code], [[error userInfo] description]);
            return;
        }
        
        error = nil;
        [audioSession setActive:YES error:&error];
        if(error) {
            DLog(@"audioSession: %@ %ld %@", [error domain], (long)[error code], [[error userInfo] description]);
            return;
        }
//        NSDictionary *recordSetting = @{ AVSampleRateKey        : @11025.0,                      // 采样率
//                                         AVFormatIDKey          : @(kAudioFormatLinearPCM),     // 音频格式
//                                         AVLinearPCMBitDepthKey : @16,                          // 采样位数 默认 16
//                                         AVNumberOfChannelsKey  : @2 ,                          // 通道的数目
//                                         AVEncoderAudioQualityKey:[NSNumber numberWithInt:AVAudioQualityMin],//音频质量,采样质量
//                                         };
        //录音设置
        NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
        //设置录音格式  AVFormatIDKey==kAudioFormatLinearPCM
        [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
        //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）, 采样率必须要设为11025才能使转化成mp3格式后不会失真
        [recordSetting setValue:[NSNumber numberWithFloat:11025.0] forKey:AVSampleRateKey];
        //录音通道数  1 或 2 ，要转换成mp3格式必须为双通道
        [recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
        //线性采样位数  8、16、24、32
        [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        //录音的质量
        [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityLow] forKey:AVEncoderAudioQualityKey];
        
        if (weakSelf) {
            STRONGSELF
            strongSelf.recordPath = path;
            error = nil;
            
            if (strongSelf.recorder) {
                [strongSelf cancelRecording];
            } else {
                strongSelf.recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:strongSelf.recordPath] settings:recordSetting error:&error];
                strongSelf.recorder.delegate = strongSelf;
                [strongSelf.recorder prepareToRecord];
                strongSelf.recorder.meteringEnabled = YES;
                [strongSelf.recorder recordForDuration:(NSTimeInterval) 60];
                [strongSelf startBackgroundTask];
            }
            
            if(error) {
                DLog(@"audioSession: %@ %ld %@", [error domain], (long)[error code], [[error userInfo] description]);
                return;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //上層如果傳會來說已經取消了, 那這邊就做原先取消的動作
                if (!prepareRecorderCompletion()) {
                    [strongSelf cancelledDeleteWithCompletion:^{
                    }];
                }
            });
        }
    });
}

- (void)startRecordingWithStartRecorderCompletion:(MACStartRecorderCompletion)startRecorderCompletion {
    if ([_recorder record]) {
        [self resetTimer];
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(updateMeters) userInfo:nil repeats:YES];
        if (startRecorderCompletion)
            dispatch_async(dispatch_get_main_queue(), ^{
                startRecorderCompletion();
            });
    }
}

- (void)resumeRecordingWithResumeRecorderCompletion:(MACResumeRecorderCompletion)resumeRecorderCompletion {
    _isPause = NO;
    if (_recorder) {
        if ([_recorder record]) {
            dispatch_async(dispatch_get_main_queue(), resumeRecorderCompletion);
        }
    }
}

- (void)pauseRecordingWithPauseRecorderCompletion:(MACPauseRecorderCompletion)pauseRecorderCompletion {
    _isPause = YES;
    if (_recorder) {
        [_recorder pause];
    }
    if (!_recorder.isRecording)
        dispatch_async(dispatch_get_main_queue(), pauseRecorderCompletion);
}

- (void)stopRecordingWithStopRecorderCompletion:(MACStopRecorderCompletion)stopRecorderCompletion {
    _isPause = NO;
    [self stopBackgroundTask];
    [self stopRecord];
    [self getVoiceDuration:_recordPath];
    dispatch_async(dispatch_get_main_queue(), stopRecorderCompletion);
}

- (void)cancelledDeleteWithCompletion:(MACCancellRecorderDeleteFileCompletion)cancelledDeleteCompletion {
    
    _isPause = NO;
    [self stopBackgroundTask];
    [self stopRecord];
    
    if (self.recordPath) {
        // 删除目录下的文件
        NSFileManager *fileManeger = [NSFileManager defaultManager];
        if ([fileManeger fileExistsAtPath:self.recordPath]) {
            NSError *error = nil;
            [fileManeger removeItemAtPath:self.recordPath error:&error];
            if (error) {
                DLog(@"error :%@", error.description);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                cancelledDeleteCompletion(error);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                cancelledDeleteCompletion(nil);
            });
        }
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            cancelledDeleteCompletion(nil);
        });
    }
}

- (void)updateMeters {
    if (!_recorder)
        return;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [_recorder updateMeters];
        
        self.currentTimeInterval = _recorder.currentTime;
        
        if (!_isPause) {
            float progress = self.currentTimeInterval / self.maxRecordTime * 1.0;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_recordProgress) {
                    _recordProgress(progress);
                }
            });
        }
        
        float peakPower = [_recorder averagePowerForChannel:0];
        double ALPHA = 0.015;
        _peakSoundValue=pow(10, (ALPHA * peakPower));
        double peakPowerForChannel = pow(10, (ALPHA * peakPower));
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新扬声器
            if (_peakPowerForChannel) {
                _peakPowerForChannel(peakPowerForChannel);
               // DLog(@"peakPowerForChannel   %f",peakPowerForChannel);
            }
        });
        
        if (self.currentTimeInterval > self.maxRecordTime) {
            [self stopRecord];
            dispatch_async(dispatch_get_main_queue(), ^{
                _maxTimeStopRecorderCompletion();
            });
        }
    });
}

- (void)getVoiceDuration:(NSString*)recordPath {
    NSError *error = nil;
    AVAudioPlayer *play = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:recordPath] error:&error];
    if (error) {
        DLog(@"recordPath：%@ error：%@", recordPath, error);
        self.recordDuration = @"";
    } else {
        DLog(@"时长:%f", play.duration);
        self.recordDuration = [NSString stringWithFormat:@"%.f", play.duration];
    }
}

@end

