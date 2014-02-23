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

@implementation ImageCache


+(ImageCache *)sharedObject {
    static ImageCache *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedInstance = [[ImageCache alloc] init];
       
        _followerArray =[[NSMutableArray alloc]init];
        _followingArray = [[NSMutableArray alloc]init];
        
    });
    
    return sharedInstance;

}

-(void)addTwittersFollower:(NSMutableArray *)follower{
    _followerArray = follower;
}

-(NSMutableArray *)getTwittersFollower{
    return _followerArray;
}

-(void)addTwittersFollowing:(NSMutableArray *)following{
    _followingArray = following;
    
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
@end
