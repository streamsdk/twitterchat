//
//  PhotoHandler.m
//  talk
//
//  Created by wangshuai on 13-12-22.
//  Copyright (c) 2013年 wangshuai. All rights reserved.
//

#import "PhotoHandler.h"
#import "NSBubbleData.h"
//#import "UIImageViewController.h"
#import "TalkDB.h"
#import "STreamXMPP.h"
#import <arcstreamsdk/JSONKit.h>
#import <arcstreamsdk/STreamFile.h>
#import "ACKMessageDB.h"
#import "ImageCache.h"
#import "FilesUpload.h"
#import "AppDelegate.h"
//#import "UploadDB.h"
#import "Progress.h"

@interface PhotoHandler()

@end
@implementation PhotoHandler

@synthesize delegate;
@synthesize controller;
@synthesize type;
@synthesize photopath;

-(void)receiveFile:(NSData *)data withPath:(NSString *)path forBubbleDataArray:(NSMutableArray *)bubbleData withTime:(NSString *)time forBubbleOtherData:(NSData *) otherData withSendId:(NSString *)sendID withFromId:(NSString *)fromID{
//    HandlerUserIdAndDateFormater * handler = [HandlerUserIdAndDateFormater sharedObject];
//
//    if ([fromID isEqualToString:sendID]) {
//        UIImage * image = [UIImage imageWithData:data];
//        NSBubbleData * bubble;
//        if (time) {
//             bubble = [NSBubbleData dataWithImage:image withImageTime:time withPath:path date:[handler getDate] withType:BubbleTypeSomeoneElse];
//        }else{
//            bubble = [NSBubbleData dataWithImage:image date:[handler getDate] type:BubbleTypeSomeoneElse path:path];
//        }
//        if (otherData) {
//            bubble.avatar = [UIImage imageWithData:otherData];
//        }
//        [bubbleData addObject:bubble];
//    }
//    
}

-(void) sendPhoto :(NSData *)data forBubbleDataArray:(NSMutableArray *)bubbleData forBubbleMyData:(NSData *) myData withSendId:(NSString *)sendID withTime:(NSString *)time{
    UIImage *image = [UIImage imageWithData:data];
    ImageCache *cache = [ImageCache sharedObject];
    NSString *photoPath = [[cache getPath] stringByAppendingString:@".png"];
    
    long long milliseconds = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
  
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc] init];
    if (time)
        [bodyDic setObject:time forKey:@"duration"];
    [bodyDic setObject:[NSString stringWithFormat:@"%lld", milliseconds] forKey:@"id"];
    [bodyDic setObject:@"photo" forKey:@"type"];
    [bodyDic setObject:@"15slogn" forKey:@"from"];
    

//    NSMutableDictionary *userMetadata = [cache getUserMetadata:sendID];
//    if (userMetadata && [userMetadata objectForKey:@"token"]){
//        [bodyDic setObject:[userMetadata objectForKey:@"token"] forKey:@"token"];
//    }
//    
    NSMutableArray * fileArray = [cache getFileUpload];
    FilesUpload * file = [[FilesUpload alloc]init];
    [file setTime:[NSString stringWithFormat:@"%lld", milliseconds]];
    [file setFilepath:photoPath];
    [file setBodyDict:bodyDic];
    [file setUserId:sendID];
    [file setChatId:[NSString stringWithFormat:@"%lld", milliseconds]];
//
//    if ([type isEqualToString:@"photo"]) {
//        photoPath = photopath;
//         [file setFilepath:photoPath];
//        type = nil;
//        if (fileArray != nil && [fileArray count] != 0) {
//            FilesUpload * f =[fileArray objectAtIndex:0];
//            long long ftime = [f.time longLongValue];
//            if ((milliseconds/1000.0 - ftime/1000.0)<8) {
//                [cache addFileUpload:file];
//                return;
//            }
//        }else{
//             [cache addFileUpload:file];
//        }
//       
//        [super doFileUpload:fileArray];
//    }else{
//         [file setFilepath:photoPath];
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
        NSBubbleData * bubble;
        if (time)
            bubble = [NSBubbleData dataWithImage:image withImageTime:time withPath:photoPath date:date withType:BubbleTypeMine];
        else
            bubble = [NSBubbleData dataWithImage:image date:date type:BubbleTypeMine path:photoPath];
        if (myData) {
            bubble.avatar = [UIImage imageWithData:myData];
        }
        [bubbleData addObject:bubble];
        
        [data writeToFile:photoPath atomically:YES];
        NSMutableDictionary *jsonDic = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *friendDict = [NSMutableDictionary dictionary];
        if (time)
            [friendDict setObject:time forKey:@"time"];
        [friendDict setObject:photoPath forKey:@"photo"];
        [jsonDic setObject:friendDict forKey:sendID];
        NSString  *str = [jsonDic JSONString];
        
        TalkDB * db = [[TalkDB alloc]init];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
        [db insertDBUserID:@"15slogn" fromID:sendID withContent:str withTime:[dateFormatter stringFromDate:date] withIsMine:0];
//
//        UploadDB * uploadDb = [[UploadDB alloc]init];
//        [uploadDb insertUploadDB:[handler getUserID] filePath:photoPath withTime:time withFrom:sendID withType:@"photo"];
//        
//        if (fileArray != nil && [fileArray count] != 0) {
//            FilesUpload * f =[fileArray objectAtIndex:0];
//            long long ftime = [f.time longLongValue];
//            if ((milliseconds/1000.0 - ftime/1000.0)<8) {
//                [cache addFileUpload:file];
//                return;
//            }
//        }
        [cache addFileUpload:file];
        
        [super doFileUpload:fileArray];
    
    [delegate reloadTable];
//    }
//    
}

@end
