//
//  LoginViewController.m
//  twitterchat
//
//  Created by wangsh on 14-2-21.
//  Copyright (c) 2014年 wangshuai. All rights reserved.
//

#import "LoginViewController.h"
#import "TwitterChatViewController.h"
#import "MBProgressHUD.h"
#import <arcstreamsdk/STreamUser.h>
#import "TwitterFollower.h"
#import "TwitterFollowing.h"
#import "ImageCache.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    if (!_accountStore)
        _accountStore = [[ACAccountStore alloc] init];
    
    
    [self fetchFellowerAndFollowing:@"15Slogn"];
	// Do any additional setup after loading the view.
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setFrame:CGRectMake(20, self.view.frame.size.height-100, self.view.frame.size.width-40, 60)];
    [loginButton setTitle:@"LOG IN" forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:20.0f];
    [loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [loginButton setBackgroundColor:[UIColor redColor]];
    [loginButton addTarget:self action:@selector(loginUser) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
}
-(void)loginUser{
    STreamUser * user = [[STreamUser alloc]init];
    
    __block MBProgressHUD *HUD = [[MBProgressHUD alloc]init];
    HUD.labelText = @"loading friends...";
    [self.view addSubview:HUD];
    [HUD showAnimated:YES whileExecutingBlock:^{
       [user logIn:@"timslogn@gmail.com" withPassword:@"streamsdk1"];
        NSLog(@"%@",[user errorMessage]);
       /*  error = [user errorMessage];
        if ([[user errorMessage] length] == 0) {
            STreamUser *user = [[STreamUser alloc] init];
            [user loadUserMetadata:userName response:^(BOOL succeed, NSString *error){
                if ([error isEqualToString:userName]){
                
                }
            }];
            
        }*/
        
       

    }completionBlock:^{
        TwitterChatViewController * vc = [TwitterChatViewController alloc];
        [self.navigationController pushViewController:vc animated:YES];
        [HUD removeFromSuperview];
        HUD = nil;
    }];

   
   
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)fetchAccounts:(NSString *)userName{
    
    if ([self userHasAccessToTwitter]) {
        
        ACAccountType *twitterAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        
        NSArray *twitterAccounts = [self.accountStore accountsWithAccountType:twitterAccountType];
        
        for (ACAccount *acc in twitterAccounts){
            
            
            
        }
    }
}

- (BOOL)userHasAccessToTwitter
{
    return [SLComposeViewController
            isAvailableForServiceType:SLServiceTypeTwitter];
}

- (void)fetchFellowerAndFollowing:(NSString *)userName{
    
    ImageCache * imagechache= [ImageCache sharedObject];
     TwitterChatViewController * vc = [TwitterChatViewController alloc];
    //  Step 0: Check that the user has local Twitter accounts
    if ([self userHasAccessToTwitter]) {
        
        //  Step 1:  Obtain access to the user's Twitter accounts
        ACAccountType *twitterAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        
        [self.accountStore requestAccessToAccountsWithType:twitterAccountType options:NULL completion:^(BOOL granted, NSError *error) {
            if (granted) {
                
                NSArray *twitterAccounts = [self.accountStore accountsWithAccountType:twitterAccountType];
                NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/followers/list.json"];
                NSDictionary *params = @{@"screen_name" : userName};
                SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:url parameters:params];
                [request setAccount:[twitterAccounts lastObject]];
                
                [request performRequestWithHandler: ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    
                    if (responseData) {
                        if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300) {
                            
                            NSError *jsonError;
                            NSDictionary *timelineData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&jsonError];
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
                                    
                                    NSLog(@"follower name: %@", name);
                                    NSLog(@"follower screen name: %@", screenName);
                                    NSLog(@"follower user id: %@", userId);
                                    NSLog(@"follower profile url: %@", profileUrl);
                                }
                                [imagechache addTwittersFollower:followerArray];
                                [vc setLoading:YES];
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
                
                
                NSURL *followingUrl = [NSURL URLWithString:@"https://api.twitter.com/1.1/friends/list.json"];
                NSDictionary *followingparams = @{@"screen_name" : userName};
                SLRequest *followingRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:followingUrl parameters:followingparams];
                [followingRequest setAccount:[twitterAccounts lastObject]];
                
                [followingRequest performRequestWithHandler: ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    
                    if (responseData) {
                        if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300) {
                            
                            NSError *jsonError;
                            NSDictionary *timelineData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&jsonError];
                            if (timelineData) {
                                //NSLog(@"Timeline Response: %@\n", timelineData);
                                NSMutableArray *followingArray = [[NSMutableArray alloc]init];
                               
                                
                                NSArray *users = [timelineData objectForKey:@"users"];
                                for (NSDictionary *user in users){
                                    NSString *name = [user objectForKey:@"name"];
                                    NSString *screenName = [user objectForKey:@"screen_name"];
                                    NSString *userId = [user objectForKey:@"id"];
                                    NSString *profileUrl = [user objectForKey:@"profile_image_url"];
                                     TwitterFollower * following = [[TwitterFollower alloc]init];
                                    [following setName:name];
                                    [following setScreenName:screenName];
                                    [following setUserid:userId];
                                    [following setProfileUrl:profileUrl];
                                    
                                    [followingArray addObject:following];
                                    
                                    NSLog(@"following name: %@", name);
                                    NSLog(@"following screen name: %@", screenName);
                                    NSLog(@"following user id: %@", userId);
                                    NSLog(@"following profile url: %@", profileUrl);
                                }
                                [imagechache addTwittersFollowing:followingArray];
                                 [vc setLoading:YES];
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
                }];              }
        }
         ];
        
        
        
    }
    
}

@end
