//
//  FollowerAndFollowingHandler.m
//  twitterchat
//
//  Created by wangsh on 14-2-28.
//  Copyright (c) 2014年 wangshuai. All rights reserved.
//

#import "FollowerAndFollowingHandler.h"
#import "ImageCache.h"
#import "TwitterFollower.h"
#import "TwitterFollowing.h"

@implementation FollowerAndFollowingHandler
@synthesize accountStore = _accountStore;
@synthesize follwerDelegate = _follwerDelegate;

-(void)getAllFollower:(NSString *)userName withCursorId:(NSString *)cursor{
    ImageCache * imagechache= [ImageCache sharedObject];
    if (!_accountStore)
        _accountStore = [[ACAccountStore alloc] init];

    ACAccountType *twitterAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"request Failed" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:nil, nil];
    
    [self.accountStore requestAccessToAccountsWithType:twitterAccountType options:NULL completion:^(BOOL granted, NSError *error) {
        if (granted) {
            
            NSArray *twitterAccounts = [self.accountStore accountsWithAccountType:twitterAccountType];
            NSURL *followerUrl = [NSURL URLWithString:@"https://api.twitter.com/1.1/followers/list.json"];
//            NSDictionary *params = @{@"user_id" : userName};
            NSMutableDictionary *followerparams = [[NSMutableDictionary alloc] init];
            [followerparams setObject:userName forKey:@"user_id"];
            [followerparams setObject:cursor forKey:@"cursor"];
            SLRequest *followerRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:followerUrl parameters:followerparams];
            [followerRequest setAccount:[twitterAccounts lastObject]];
            
            [followerRequest performRequestWithHandler: ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                
                if (responseData) {
                    if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300) {
                        
                        NSError *jsonError;
                        NSDictionary *timelineData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&jsonError];
                        
                        NSString *cur = [timelineData objectForKey:@"next_cursor_str"];
                        [imagechache saveFollowerCoursor:cur];
                        if (timelineData) {
                            //NSLog(@"Timeline Response: %@\n", timelineData);
                            NSMutableArray *followerArray = [[NSMutableArray alloc]init];
                            
                            
                            NSArray *users = [timelineData objectForKey:@"users"];
                            for (NSDictionary *user in users){
                                NSString *name = [user objectForKey:@"name"];
                                NSString *screenName = [user objectForKey:@"screen_name"];
                                NSString *userId = [user objectForKey:@"id"];
                                NSString *profileUrl = [user objectForKey:@"profile_image_url"];
                                TwitterFollower * follower = [[TwitterFollower alloc]init];
                                [follower setName:name];
                                [follower setScreenName:screenName];
                                [follower setUserid:userId];
                                [follower setProfileUrl:profileUrl];
                                [followerArray addObject:follower];
                                
                                [imagechache addTwittersFollower:follower];
                                NSLog(@"follower name: %@", name);
                                NSLog(@"follower screen name: %@", screenName);
                                NSLog(@"follower user id: %@", userId);
                                NSLog(@"follower profile url: %@", profileUrl);
                            }
                            [_follwerDelegate followerLoadComplete];
                            
//                            [imagechache addTwittersFollower:followerArray];
//                            if (![cur isEqualToString:@"0"]){
//                                [self getAllFollowing:userName withCursorId:cur];
//                            }
                        }
                        else {
                            // Our JSON deserialization went awry
                            NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                            
                            [alertView  show];
                        }
                    }
                    else {
                        // The server did not respond ... were we rate-limited?
                        NSLog(@"The response status code is %d", urlResponse.statusCode);
                        [_follwerDelegate followerLoadFailed];
                        
                    }
                }
            }];
            
        }
    }];
    
}

-(void)getAllFollowing:(NSString *)userName withCursorId:(NSString *)cursor{
    
    ImageCache * imagechache= [ImageCache sharedObject];
    if (!_accountStore)
        _accountStore = [[ACAccountStore alloc] init];
    
    ACAccountType *twitterAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    NSArray *twitterAccounts = [self.accountStore accountsWithAccountType:twitterAccountType];
    NSURL *followingUrl = [NSURL URLWithString:@"https://api.twitter.com/1.1/friends/list.json"];
    //NSDictionary *followingparams = @{@"user_id" : userName, @"cursor" : cursor};
    NSMutableDictionary *followingparams = [[NSMutableDictionary alloc] init];
    [followingparams setObject:userName forKey:@"user_id"];
    [followingparams setObject:cursor forKey:@"cursor"];
    SLRequest *followingRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:followingUrl parameters:followingparams];
    [followingRequest setAccount:[twitterAccounts lastObject]];
    [self.accountStore requestAccessToAccountsWithType:twitterAccountType options:NULL completion:^(BOOL granted, NSError *error) {
        if (granted) {
            [followingRequest performRequestWithHandler: ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                
                if (responseData) {
                    if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300) {
                        
                        NSError *jsonError;
                        NSDictionary *timelineData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&jsonError];
                        NSString *cur = [timelineData objectForKey:@"next_cursor_str"];
                        [imagechache saveFollowingCoursor:cur];
                        if (timelineData) {
                            //NSLog(@"Timeline Response: %@\n", timelineData);
                            NSMutableArray *followingArray = [[NSMutableArray alloc]init];
                            
                            
                            NSArray *users = [timelineData objectForKey:@"users"];
                            for (NSDictionary *user in users){
                                NSString *name = [user objectForKey:@"name"];
                                NSString *screenName = [user objectForKey:@"screen_name"];
                                NSString *userId = [user objectForKey:@"id"];
                                NSString *profileUrl = [user objectForKey:@"profile_image_url"];
                                TwitterFollowing * following = [[TwitterFollowing alloc]init];
                                [following setName:name];
                                [following setScreenName:screenName];
                                [following setUserid:userId];
                                [following setProfileUrl:profileUrl];
                                
                                [followingArray addObject:following];
                                [imagechache addTwittersFollowing:following];
                                NSLog(@"following name: %@", name);
                                NSLog(@"following screen name: %@", screenName);
                                NSLog(@"following user id: %@", userId);
                                NSLog(@"following profile url: %@", profileUrl);
                            }
//                             [imagechache addTwittersFollowing:followingArray];
//                            if (![cur isEqualToString:@"0"]){
//                                [self getAllFollowing:userName withCursorId:cur];
//                            }
                           
                            
                        }
                        else {
                            // Our JSON deserialization went awry
                            NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                        }
                    }
                    else {
                        // The server did not respond ... were we rate-limited?
                        NSLog(@"The response status code is %d", urlResponse.statusCode);
                    }
                }
            }];
        }
    }];

    

}

@end
