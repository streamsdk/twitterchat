//
//  FollowerAndFollowingHandler.h
//  twitterchat
//
//  Created by wangsh on 14-2-28.
//  Copyright (c) 2014年 wangshuai. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>


@protocol FollowerDelegate <NSObject>

-(void)followerLoadComplete;

-(void)followerLoadFailed;


@end

@interface FollowerAndFollowingHandler : NSObject{
    
}

@property (nonatomic) ACAccountStore *accountStore;

-(void)getAllFollower:(NSString *)userName withCursorId:(NSString *)cursor;

-(void)getAllFollowing:(NSString *)userName withCursorId:(NSString *)cursor;

@property (nonatomic,assign) id <FollowerDelegate> follwerDelegate;

@end

