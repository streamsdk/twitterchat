//
//  MediaHandler.m
//  talk
//
//  Created by wangshuai on 15/02/2014.
//  Copyright (c) 2014 wangshuai. All rights reserved.
//

#import "MediaHandler.h"
#import "NSBubbleData.h"
//#import "TalkDB.h"
#import "STreamXMPP.h"
#import <arcstreamsdk/JSONKit.h>
#import "ACKMessageDB.h"
#import "FilesUpload.h"
#import "ImageCache.h"
#import <arcstreamsdk/STreamFile.h>
#import "AppDelegate.h"
#import "Progress.h"

@implementation MediaHandler

- (void)doFileUpload:(NSMutableArray *)files{
    
//    HandlerUserIdAndDateFormater * handler = [HandlerUserIdAndDateFormater sharedObject];
    FilesUpload * f = [files objectAtIndex:0];
    ImageCache * cache  =[ImageCache sharedObject];
    NSData * data = [NSData dataWithContentsOfFile:f.filepath];

    STreamFile *sf = [[STreamFile alloc] init];
    STreamXMPP *con = [STreamXMPP sharedObject];
    [sf postData:data finished:^(NSString *res){
      if ([sf fileId]){
        if ([res isEqualToString:@"ok"]){
            if ([f.type isEqualToString:@"video"]) {
                STreamFile * sfile = [[STreamFile alloc]init];
                [sfile postData:f.imageData];
                sleep(3);
                NSString * tid  = [sfile fileId];
                if (tid) {
                    [f.bodyDict setObject:tid forKey:@"tid"];
                }
            }
            [f.bodyDict setObject:[sf fileId] forKey:@"fileId"];
            NSString *bodyJsonData = [f.bodyDict JSONString];
           // NSLog(@"body json data: %@", bodyJsonData);
            ACKMessageDB *ack = [[ACKMessageDB alloc]init];
            NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
            [ack insertDB:f.chatId withUserID:@"15slogn" fromID:f.userId withContent:bodyJsonData withTime:[dateFormatter stringFromDate:date] withIsMine:0];
//            UploadDB * uploadDb = [[UploadDB alloc]init];
//            [uploadDb deleteUploadDBFromFilepath:f.filepath];
            [con sendFileMessage:f.userId withFileId:[sf fileId] withMessage:bodyJsonData];
        }
        
        NSMutableArray * fileArray = [cache getFileUpload];
        if (fileArray != nil && [fileArray count] != 0) {
            [self doFileUpload:fileArray];
        }
      }else{
          NSLog(@"FILE IS NULL");
      }
        
    }byteSent:^(float bytes){
        long long milliseconds = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
        [f setTime:[NSString stringWithFormat:@"%lld", milliseconds]];
        Progress *p = (Progress *)[APPDELEGATE.progressDict objectForKey:f.filepath];
        UIProgressView *progressView= p.progressView;
        UILabel *label = p.label;
        UIActivityIndicatorView *activityIndicatorView = p.activityIndicatorView;
        progressView.hidden = NO;
        progressView.progress = bytes;
        [activityIndicatorView startAnimating];
        label.hidden = NO;
        label.text = [NSString stringWithFormat:@"%.0f%%",bytes*100];
        if (bytes == 1.000000) {
            progressView.hidden = YES;
            label.hidden = YES;
            [activityIndicatorView stopAnimating];
            [cache removeFileUpload:f];
        }
        
       // NSLog(@"byteSent:%f", bytes);
    }];
 
    
    
    
}


@end
