//
//  Voice.m
//  talk
//
//  Created by wangsh on 13-11-5.
//  Copyright (c) 2013年 wangshuai. All rights reserved.
//

#import "Voice.h"
#import <AVFoundation/AVFoundation.h>
#import "VoiceHud.h"

#pragma mark - <DEFINES>

#define WAVE_UPDATE_FREQUENCY   0.05

#pragma mark - <CLASS> Voice

@interface Voice () <AVAudioRecorderDelegate>
{
    NSTimer * timer;
    
    VoiceHud * voiceHud;
}

@property(nonatomic,retain) AVAudioRecorder * recorder;

@end
@implementation Voice

@synthesize recordPath;
@synthesize recorder = _recorder;
@synthesize recordTime;

#pragma mark - Publick Function

-(NSString*)getCurrentTimeString
{
    NSDateFormatter *dateformat=[[NSDateFormatter  alloc]init];
    [dateformat setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    return [dateformat stringFromDate:[NSDate date]];
}
-(NSString*)getCacheDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
}

-(void)startRecordWithPath
{
    NSError * err = nil;
    NSString* recordName = [self getCurrentTimeString];
    NSString * recordFilePath = [[self getCacheDirectory]stringByAppendingPathComponent:recordName];
    self.recordPath = [recordFilePath stringByAppendingString:@".aac"];
    
	AVAudioSession *audioSession = [AVAudioSession sharedInstance];
	[audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&err];
    [audioSession setActive:YES error:&err];
    
	if(err){
        NSLog(@"audioSession: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        return;
	}
	err = nil;
	if(err){
        NSLog(@"audioSession: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        return;
	}
	
    NSDictionary *recordSetting = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt: kAudioFormatMPEG4AAC], AVFormatIDKey,
                                    [NSNumber numberWithFloat:44100.0], AVSampleRateKey,
                                    [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,
                                    nil];
    
	NSURL *url = [NSURL fileURLWithPath:self.recordPath];
    
   	err = nil;
	
	NSData * audioData = [NSData dataWithContentsOfFile:[url path] options: 0 error:&err];
    
	if(audioData)
	{
		NSFileManager *fm = [NSFileManager defaultManager];
		[fm removeItemAtPath:[url path] error:&err];
	}
	err = nil;
    
    if(self.recorder){
        [self.recorder stop];
        self.recorder = nil;
    }
    
	self.recorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&err];
    
	if(!_recorder){
        NSLog(@"recorder: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Warning"
								   message: [err localizedDescription]
								  delegate: nil
						 cancelButtonTitle:@"OK"
						 otherButtonTitles:nil];
        [alert show];
        return;
	}
    
	[_recorder setDelegate:self];
	[_recorder prepareToRecord];
    [_recorder record];
	_recorder.meteringEnabled = YES;
	
    [self showVoiceHudOrHide:YES];
    
	BOOL audioHWAvailable = audioSession.inputAvailable;
    
	if (! audioHWAvailable) {
        UIAlertView *cantRecordAlert =
        [[UIAlertView alloc] initWithTitle: @"Warning"
                                   message: @"Audio input hardware not available"
								  delegate: nil
						 cancelButtonTitle:@"OK"
						 otherButtonTitles:nil];
        [cantRecordAlert show];
        return;
	}
	
	[_recorder recordForDuration:(NSTimeInterval) 60];
    self.recordTime = 0;
    
    [self resetTimer];
    
	timer= [NSTimer scheduledTimerWithTimeInterval:WAVE_UPDATE_FREQUENCY target:self selector:@selector(updateMeters) userInfo:nil repeats:YES];
}

-(void) stopRecordWithCompletionBlock:(void (^)())completion
{
    dispatch_async(dispatch_get_main_queue(),completion);
    [self resetTimer];
    [self showVoiceHudOrHide:NO];
  
    [self.recorder stop];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    int flags = AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation;
    [session setActive:NO withOptions:flags error:nil];
}

#pragma mark - Timer Update

- (void)updateMeters {
    
    self.recordTime += WAVE_UPDATE_FREQUENCY;
    
    if (voiceHud)
    {
        /*  发送updateMeters消息来刷新平均和峰值功率。
         *  此计数是以对数刻度计量的，-160表示完全安静，
         *  0表示最大输入值
         */
        
        if (_recorder) {
            [_recorder updateMeters];
        }
        
        float peakPower = [_recorder peakPowerForChannel:0];
        double ALPHA = 0.05;
        double peakPowerForChannel = pow(10, (ALPHA * peakPower));
        //jianchashifouyourenchiqi
        if (peakPowerForChannel >=0.1) {
            [voiceHud setProgress:peakPowerForChannel];
        }
    }
}

#pragma mark - show VoicHud Hud

-(void) showVoiceHudOrHide:(BOOL)yesOrNo{
    
    if (voiceHud) {
        [voiceHud hide];
        voiceHud = nil;
    }
    
    if (yesOrNo) {
        
        voiceHud = [[VoiceHud alloc] init];
        [voiceHud show];
        
    }
}

-(void) resetTimer
{
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}

-(void) cancelRecording
{
    if (self.recorder.isRecording) {
        [self.recorder stop];
    }
    
    self.recorder = nil;
}

- (void)cancelled {
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    int flags = AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation;
    [session setActive:NO withOptions:flags error:nil];
    [self showVoiceHudOrHide:NO];
    [self resetTimer];
    [self cancelRecording];
}

@end
