//
//  ImageCache.h
//  talk
//
//  Created by wangsh on 13-12-14.
//  Copyright (c) 2013年 wangshuai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FilesUpload.h"
#import "TwitterFollowing.h"
#import "TwitterFollower.h"

@interface ImageCache : NSObject

+(ImageCache *)sharedObject;

-(void)addTwittersFollower:(TwitterFollower *)follower;

-(NSMutableArray *)getTwittersFollower;

-(void)addTwittersFollowing:(TwitterFollowing *)following;

-(NSMutableArray *)getTwittersFollowing;

-(void)addRecentChat:(NSArray *)recent;

-(NSMutableArray *)getRecentChat;

-(NSString *)getPath;

-(void) setFriendID:(NSString *)friendID;

-(NSString *) getFriendID;

-(void) saveFriendID:(NSString *)friendID withFriendName:(NSString *)friendName;

-(NSString *) getFriendName :(NSString *) friendId;

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

-(void) saveUserID:(NSString *)userID;

-(NSString *)getUserID;

-(void)saveAllUserId:(NSString *)userId;

-(NSMutableSet* )getAllUserId;

-(void)saveFollowerCoursor:(NSString *)cursor;

-(NSString *)getFollowerCoursor;

-(void)saveFollowingCoursor:(NSString *)cursor;

-(NSString *)getFollowingCoursor;
@end
