//
//  ImageCache.h
//  talk
//
//  Created by wangsh on 13-12-14.
//  Copyright (c) 2013年 wangshuai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FilesUpload.h"
@interface ImageCache : NSObject

+(ImageCache *)sharedObject;

-(void)addTwittersFollower:(NSMutableArray *)follower;

-(NSMutableArray *)getTwittersFollower;

-(void)addTwittersFollowing:(NSMutableArray *)following;

-(NSMutableArray *)getTwittersFollowing;

-(NSString *)getPath;

-(void) setFriendID:(NSString *)friendID;

-(NSString *) getFriendID;

-(void) addFileUpload:(FilesUpload *)file;

-(NSMutableArray *)getFileUpload;

-(void)removeFileUpload:(FilesUpload *)file;

-(void)removeAllFileUpload;

-(void)addBrushColor:(UIColor *)color;

-(NSMutableArray *)getBrushColor;

-(void) saveMessagesCount:(NSString *)friendId;

-(NSInteger)getMessagesCount:(NSString *)friendId;

-(void) removeFriendID:(NSString *)friendId;

-(void)saveJsonData:(NSString *)jd forFileId:(NSString *)fileId;

-(NSString *)getJsonData:(NSString *)fileId;

-(void) savevideoPath:(NSString *)video;

-(NSString *)getVideopath;

-(void) saveDate:(NSDate *)date;

-(NSDate *)getDate;
@end
