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
#import <arcstreamsdk/STreamCategoryObject.h>
#import <arcstreamsdk/STreamUser.h>
#import <arcstreamsdk/STreamObject.h>
#import "TwitterFollower.h"
#import "TwitterFollowing.h"
#import "ImageCache.h"

@interface LoginViewController ()<UIActionSheetDelegate>
{
    TwitterChatViewController * twitterVC;
    NSMutableDictionary * loginTwitter;
    NSMutableSet *twitter;
}
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
    twitter= [[NSMutableSet alloc]init];
    loginTwitter = [[NSMutableDictionary alloc]init];
    if (!_accountStore)
        _accountStore = [[ACAccountStore alloc] init];
    
    twitterVC = [[TwitterChatViewController alloc]init];
    
//    [self fetchFellowerAndFollowing:@"@robguy16"];
//
  /*  ImageCache * imagechache= [ImageCache sharedObject];
    [imagechache saveUserID:@"1344650912"];
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
//    [follower2 setName:@"wang shuai"];
//    [follower2 setScreenName:@"wangshuaichen"];
//    [follower2 setUserid:@"97532178"];
//    [follower2 setProfileUrl:@"http://pbs.twimg.com/profile_images/579697246/Desert_Landscape_normal.jpg"];
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

    [imagechache addTwittersFollowing:followingArray];*/
    

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * username= [userDefaults objectForKey:@"username"];
    if (username!=nil && ![username isEqualToString:@""]) {
        ImageCache * imagechache= [ImageCache sharedObject];
        [imagechache saveUserID:username];
        [self.navigationController pushViewController:twitterVC animated:YES];
    }else{
        UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [loginButton setFrame:CGRectMake(20, self.view.frame.size.height-100, self.view.frame.size.width-40, 60)];
        [loginButton setTitle:@"LOG IN" forState:UIControlStateNormal];
        loginButton.titleLabel.font = [UIFont systemFontOfSize:20.0f];
        [loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [loginButton setBackgroundColor:[UIColor redColor]];
        [loginButton addTarget:self action:@selector(loginUser) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:loginButton];
    }

   
}
-(void)loginUser{
//    __block MBProgressHUD *HUD = [[MBProgressHUD alloc]init];
//    HUD.labelText = @"loading friends...";
//    [self.view addSubview:HUD];
//    [HUD showAnimated:YES whileExecutingBlock:^{
//         [self fetchAccounts];
    
//    }completionBlock:^{
//         [HUD removeFromSuperview];
//        HUD = nil;
//    }];

//   [self.navigationController pushViewController:twitterVC animated:YES];
    [self fetchAccounts];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)fetchAccounts{
    
    if ([self userHasAccessToTwitter]) {
        
        ACAccountType *twitterAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        
        NSArray *twitterAccounts = [self.accountStore accountsWithAccountType:twitterAccountType];
        
        NSString *userid = nil;
        for (ACAccount *acc in twitterAccounts){
            
            NSLog(@"account name: %@", [acc username]);
            id  tData = [acc valueForKey:@"properties"];
            NSString *userId = [tData valueForKey:@"user_id"];
            NSMutableDictionary *metadata = [[NSMutableDictionary alloc]init];
            [metadata setObject:userId forKey:@"userid"];
            [metadata setObject:[acc username] forKey:@"username"];
            [loginTwitter setObject:metadata forKey:userId];
            [twitter addObject:userId];
            userid = userId;
        }
        if ([twitterAccounts count]>1) {
            
            UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                          initWithTitle:nil
                                          delegate:self
                                          cancelButtonTitle:nil
                                          destructiveButtonTitle:nil
                                          otherButtonTitles:nil];
            NSArray * array = [twitter allObjects];
            for (int i = 0; i < [array count]; i++) {
                NSString * userid = [array objectAtIndex:i];
                NSMutableDictionary * metaData = [loginTwitter objectForKey:userid];
                NSString * username = [metaData objectForKey:@"username"];
                 [actionSheet addButtonWithTitle:username];
            }
            
            [actionSheet addButtonWithTitle:@"取消"];
            actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            [actionSheet showInView:self.view];
            
        }else{
            [self loginUserAndSignUpUser:userid];
        }
        
    }
}

- (BOOL)userHasAccessToTwitter
{
    return [SLComposeViewController
            isAvailableForServiceType:SLServiceTypeTwitter];
}


-(void)getAllFollowing:(NSString *)userName withCursorId:(NSString *)cursor{
    
      
    
}

- (void)fetchFellowerAndFollowing:(NSString *)userName{
    
        
}
-(void) loginUserAndSignUpUser:(NSString *)userId{
    
    ImageCache * imagecache = [ImageCache sharedObject];
    [imagecache saveUserID:userId];
    NSMutableDictionary * metadata = [loginTwitter objectForKey:userId];
    STreamUser * user = [[STreamUser alloc]init];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * username= [userDefaults objectForKey:@"username"];
    
    __block NSString * error;
    
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"user or password error" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:nil, nil];
    __block MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.labelText = @"log you in, Please wait...";
    [self.view addSubview:HUD];
    [HUD showAnimated:YES whileExecutingBlock:^{
        if (username!=nil && ![username isEqualToString:@""]) {
            [user logIn:username withPassword:@"password"];
            error = [user errorMessage];
            
        }else{
            [user signUp:userId withPassword:@"password" withMetadata:metadata];
            NSLog(@"%@",[user errorMessage]);
            error = [user errorMessage];
            if ([[user errorMessage] isEqualToString:@""]) {
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:userId forKey:@"username"];
                
                STreamObject * history = [[STreamObject alloc]init];
                [history setObjectId:[userId stringByAppendingString:@"messaginghistory"]];
                [history createNewObject:^(BOOL succeed, NSString *objectId) {
                    if (succeed)
                        NSLog(@"succeed");
                    else
                        NSLog(@"failed");
                }];
                STreamCategoryObject * sto = [[STreamCategoryObject alloc]initWithCategory:@"alluser"];
            
                STreamObject *so = [[STreamObject alloc] init] ;
                
                [so setObjectId:userId];
                
                [so addStaff:[metadata objectForKey:@"username"] withObject:@"username"];
                [sto addStreamObject:so];
                NSMutableArray * updateArray = [[NSMutableArray alloc]init];
                [updateArray addObject:so];
                [sto updateStreamCategoryObjectsInBackground:updateArray];
                
            }else{
                [user logIn:userId withPassword:@"password"];
                error = [user errorMessage];
                if ([[user errorMessage] isEqualToString:@""]) {
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:userId forKey:@"username"];
                }
                
            }
            
        }

    }completionBlock:^{
        if ([error isEqualToString:@""]) {
           [self.navigationController pushViewController:twitterVC animated:YES];
        }else{
            [alertView show];
        }
        
        [HUD removeFromSuperview];
        HUD = nil;
    }];
    
    //[self fetchFellowerAndFollowing:userId];
//           [self getAllFollowing:userId withCursorId:@"-1"];
 

}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex != [twitter count]) {
         NSArray * array = [twitter allObjects];
        NSString * userid = [array objectAtIndex:buttonIndex];
        [self loginUserAndSignUpUser:userid];
        NSLog(@"%@",userid);
    }
}

@end
