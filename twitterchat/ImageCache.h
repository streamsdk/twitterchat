//
//  ImageCache.h
//  talk
//
//  Created by wangsh on 13-12-14.
//  Copyright (c) 2013年 wangshuai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageCache : NSObject

+(ImageCache *)sharedObject;

-(void)addTwittersFollower:(NSMutableArray *)follower;

-(NSMutableArray *)getTwittersFollower;

-(void)addTwittersFollowing:(NSMutableArray *)following;

-(NSMutableArray *)getTwittersFollowing;

-(NSString *)getPath;

-(void) setFriendID:(NSString *)friendID;

-(NSString *) getFriendID;

@end
