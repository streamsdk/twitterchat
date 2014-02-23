//
//  Voice.h
//  talk
//
//  Created by wangsh on 13-11-5.
//  Copyright (c) 2013年 wangshuai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Voice : NSObject

@property(nonatomic,retain) NSString * recordPath;
@property(nonatomic) float recordTime;

-(NSString*)getCurrentTimeString;

-(NSString*)getCacheDirectory;

-(void) startRecordWithPath;

-(void) stopRecordWithCompletionBlock:(void (^)())completion;

-(void) cancelled;

@end
