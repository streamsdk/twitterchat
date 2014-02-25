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
@synthesize accountStore = _accountStore;

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
//    [self fetchFellowerAndFollowing:@"15Slogn"];
    
    ImageCache * imagechache= [ImageCache sharedObject];
    TwitterChatViewController * vc = [TwitterChatViewController alloc];
    [vc setLoading:YES];
     NSMutableArray *followerArray = [[NSMutableArray alloc]init];
    TwitterFollower * follower = [[TwitterFollower alloc]init];
    [follower setName:@"Stream SDK"];
    [follower setScreenName:@"StreamSDK1"];
    [follower setUserid:@"1344682561"];
    [follower setProfileUrl:@"http://abs.twimg.com/sticky/default_profile_images/default_profile_5_normal.png"];
    
    TwitterFollower * follower1 = [[TwitterFollower alloc]init];
    [follower1 setName:@"rob guy"];
    [follower1 setScreenName:@"robguy16"];
    [follower1 setUserid:@"1344650912"];
    [follower1 setProfileUrl:@"http://abs.twimg.com/sticky/default_profile_images/default_profile_3_normal.png"];
    
    TwitterFollower * follower2 = [[TwitterFollower alloc]init];
    [follower2 setName:@"wang shuai"];
    [follower2 setScreenName:@"wangshuaichen"];
    [follower2 setUserid:@"97532178"];
    [follower2 setProfileUrl:@"http://pbs.twimg.com/profile_images/579697246/Desert_Landscape_normal.jpg"];
    
    [followerArray addObject:follower];
    [followerArray addObject:follower1];
    [followerArray addObject:follower2];
    [imagechache addTwittersFollower:followerArray];

    NSMutableArray *followingArray = [[NSMutableArray alloc]init];
    
    TwitterFollower * following = [[TwitterFollower alloc]init];
    [following setName:@"edward yang"];
    [following setScreenName:@"edwardyangey"];
    [following setUserid:@"111616635"];
    [following setProfileUrl:@"http://pbs.twimg.com/profile_images/417354254995951616/jj_ay5lq_normal.jpeg"];
    
    TwitterFollower * following1 = [[TwitterFollower alloc]init];
    [following1 setName:@"Stream SDK"];
    [following1 setScreenName:@"StreamSDK1"];
    [following1 setUserid:@"1344682561"];
    [following1 setProfileUrl:@"http://abs.twimg.com/sticky/default_profile_images/default_profile_5_normal.png"];
    
    TwitterFollower * following2 = [[TwitterFollower alloc]init];
    [following2 setName:@"wang shuai"];
    [following2 setScreenName:@"wangshuaichen"];
    [following2 setUserid:@"97532178"];
    [following2 setProfileUrl:@"http://pbs.twimg.com/profile_images/579697246/Desert_Landscape_normal.jpg"];
    
    [followingArray addObject:following];
    [followingArray addObject:following1];
    [followingArray addObject:following2];

    [imagechache addTwittersFollowing:followingArray];
    

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
     __block NSString * error;
    __block MBProgressHUD *HUD = [[MBProgressHUD alloc]init];
    HUD.labelText = @"loading friends...";
    [self.view addSubview:HUD];
    [HUD showAnimated:YES whileExecutingBlock:^{
        [user signUp:@"" withPassword:@"" withMetadata:nil];
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
