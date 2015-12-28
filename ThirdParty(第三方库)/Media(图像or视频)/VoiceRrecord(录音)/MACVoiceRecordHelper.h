//
//  MACVoiceRecordHelper.h
//  WeSchoolStudent
//
//  Created by MacKun on 15/11/10.
#import <Foundation/Foundation.h>

typedef BOOL(^MACPrepareRecorderCompletion)();
typedef void(^MACStartRecorderCompletion)();
typedef void(^MACStopRecorderCompletion)();
typedef void(^MACPauseRecorderCompletion)();
typedef void(^MACResumeRecorderCompletion)();
typedef void(^MACCancellRecorderDeleteFileCompletion)();
typedef void(^MACRecordProgress)(float progress);
typedef void(^MACPeakPowerForChannel)(float peakPowerForChannel);


@interface MACVoiceRecordHelper : NSObject

@property (nonatomic, copy) MACStopRecorderCompletion maxTimeStopRecorderCompletion;
@property (nonatomic, copy) MACRecordProgress recordProgress;
@property (nonatomic, copy) MACPeakPowerForChannel peakPowerForChannel;
@property (nonatomic, copy, readonly) NSString *recordPath;
@property (nonatomic, copy) NSString *recordDuration;
@property (nonatomic, assign) CGFloat peakSoundValue;
/**
 *   默认 60秒为最大
 */
@property (nonatomic) float maxRecordTime;
/**
 *  目前时间戳
 */
@property (nonatomic, readonly) NSTimeInterval currentTimeInterval;
/**
 *  准备录音
 *
 *  @param path                      录音路径
 *  @param prepareRecorderCompletion 录音block
 */
- (void)prepareRecordingWithPath:(NSString *)path prepareRecorderCompletion:(MACPrepareRecorderCompletion)prepareRecorderCompletion;
/**
 *  开始录音
 *
 *  @param startRecorderCompletion 开始录音block
 */
- (void)startRecordingWithStartRecorderCompletion:(MACStartRecorderCompletion)startRecorderCompletion;
/**
 *  暂停录音
 *
 *  @param pauseRecorderCompletion 暂停block
 */
- (void)pauseRecordingWithPauseRecorderCompletion:(MACPauseRecorderCompletion)pauseRecorderCompletion;
/**
 *  唤醒录音
 *
 *  @param resumeRecorderCompletion 录音block
 */
- (void)resumeRecordingWithResumeRecorderCompletion:(MACResumeRecorderCompletion)resumeRecorderCompletion;

/**
 *  停止录音
 *
 *  @param stopRecorderCompletion 停止录音block
 */
- (void)stopRecordingWithStopRecorderCompletion:(MACStopRecorderCompletion)stopRecorderCompletion;
/**
 *  删除目录下的文件
 *
 *  @param cancelledDeleteCompletion 删除录音的block
 */
- (void)cancelledDeleteWithCompletion:(MACCancellRecorderDeleteFileCompletion)cancelledDeleteCompletion;

@end

