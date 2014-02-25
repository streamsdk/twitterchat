//
//  AudioHandler.h
//  talk
//
//  Created by wangshuai on 13-12-23.
//  Copyright (c) 2013年 wangshuai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Voice.h"
#import "MediaHandler.h"

@interface AudioHandler : MediaHandler

@property (nonatomic,assign) BOOL isAddUploadDB;

- (void)receiveAudioFile:(NSData *)data withBody:(NSString *)body forBubbleDataArray:(NSMutableArray *)bubbleData forBubbleOtherData:(NSData *) otherData withSendId:(NSString *)sendID withFromId:(NSString *)fromID;
-(void) sendAudio :(Voice *)voice  forBubbleDataArray:(NSMutableArray *)bubbleData forBubbleMyData:(NSData *) myData withSendId:(NSString *)sendID;

@end
