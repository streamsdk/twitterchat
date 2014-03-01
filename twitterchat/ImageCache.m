//
//  ImageCache.m
//  talk
//
//  Created by wangsh on 13-12-14.
//  Copyright (c) 2013年 wangshuai. All rights reserved.
//

#import "ImageCache.h"

static NSMutableDictionary *_userMetaData;

static NSMutableArray * _followerArray;
static NSMutableArray * _followingArray;
static NSString *_friendID;
static NSMutableArray *_fileUpload;
static NSMutableArray *_colors;
static NSMutableDictionary *_messagesDict;
static NSMutableDictionary *_jsonData;
static NSString * _videoPath;
static NSDate * _date;
static NSString * _userId;
static NSMutableSet *allUserId;
static NSString * followerCursor;
static NSString *followingCursor;

@implementation ImageCache


+(ImageCache *)sharedObject {
    static ImageCache *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedInstance = [[ImageCache alloc] init];
        _date =[[NSDate alloc]init];
        _followerArray =[[NSMutableArray alloc]init];
        _followingArray = [[NSMutableArray alloc]init];
        _fileUpload = [[NSMutableArray alloc]init];
        _colors = [[NSMutableArray alloc]init];
        _messagesDict = [[NSMutableDictionary alloc]init];
         _jsonData = [[NSMutableDictionary alloc] init];
        allUserId = [[NSMutableSet alloc]init];
    });
    
    return sharedInstance;

}

-(void)addTwittersFollower:(TwitterFollower *)follower{
    [_followerArray addObject:follower];
}

-(NSMutableArray *)getTwittersFollower{
    return _followerArray;
}

-(void)addTwittersFollowing:(TwitterFollowing *)following{
    [_followingArray addObject:following];
    
}

-(NSMutableArray *)getTwittersFollowing{
    
    return _followingArray;
}
-(void) setFriendID:(NSString *)friendID{
    _friendID = friendID;
}

-(NSString *) getFriendID{
    return _friendID;
}
-(NSString *)getPath {
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss.SSS"];
    NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/out-%@", [formater stringFromDate:[NSDate date]]];
    return path;
}

-(void) addFileUpload:(FilesUpload *)file{
    
    [_fileUpload addObject:file];
}

-(NSMutableArray *)getFileUpload{
    return _fileUpload;
}

-(void)removeFileUpload:(FilesUpload *)file{
    
    [_fileUpload removeObject:file];
}
-(void)removeAllFileUpload {
    [_fileUpload removeAllObjects];
}

-(void) addBrushColor:(UIColor *)color{
    [_colors addObject:color];
}

-(NSMutableArray *)getBrushColor{
    return _colors;
}

-(void) saveMessagesCount:(NSString *)friendId{
    if ([[_messagesDict allKeys] containsObject:friendId]) {
        NSInteger count =[[_messagesDict objectForKey:friendId] integerValue];
        NSString * str = [NSString stringWithFormat:@"%d",count+1];
        [_messagesDict setObject:str forKey:friendId];
    }else{
        [_messagesDict setObject:@"1" forKey:friendId];
    }

}

-(NSInteger)getMessagesCount:(NSString *)friendId{
    NSInteger count =[[_messagesDict objectForKey:friendId] integerValue];
    return  count;
}

-(void) removeFriendID:(NSString *)friendId{
    [_messagesDict removeObjectForKey:friendId];
}
-(void)saveJsonData:(NSString *)jd forFileId:(NSString *)fileId{
    [_jsonData setObject:jd forKey:fileId];
}

-(NSString *)getJsonData:(NSString *)fileId{
    return [_jsonData objectForKey:fileId];
}
-(void) savevideoPath:(NSString *)video{
    
    _videoPath =video;
}

-(NSString *)getVideopath{
    
    return _videoPath;
}

-(void) saveDate:(NSDate *)date{
    _date = date;
}

-(NSDate *)getDate{
    return _date;
}

-(void) saveUserID:(NSString *)userID{
    _userId = userID;
}

-(NSString *)getUserID{
    return _userId;
}

-(void)saveAllUserId:(NSString *)userId{
    
    [allUserId addObject:userId];
}

-(NSMutableSet* )getAllUserId{
    return allUserId;
}
-(void)saveFollowerCoursor:(NSString *)cursor{
    followerCursor = cursor;
}

-(NSString *)getFollowerCoursor{
    return followerCursor;
    
}
-(void)saveFollowingCoursor:(NSString *)cursor{
    followingCursor = cursor;
}

-(NSString *)getFollowingCoursor{
    return followingCursor;
}
@end
