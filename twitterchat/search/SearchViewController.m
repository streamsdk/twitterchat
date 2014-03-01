//
//  SearchViewController.m
//  twitterchat
//
//  Created by wangsh on 14-3-1.
//  Copyright (c) 2014年 wangshuai. All rights reserved.
//

#import "SearchViewController.h"
#import "ImageCache.h"

@interface SearchViewController ()

@end

@implementation SearchViewController
@synthesize mysearchBar;
@synthesize searchArray;
@synthesize searchTableView;

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
	// Do any additional setup after loading the view.
    
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];

    UINavigationBar *navBar=[[UINavigationBar alloc] initWithFrame:CGRectMake(0,20,self.view.frame.size.width,44)];
    navBar.barStyle = UIBarStyleBlackTranslucent;
    [self.view addSubview:navBar];
    
    mysearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 20.0, self.view.bounds.size.width-75, 44)];
    mysearchBar.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin |UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
    mysearchBar.delegate = self;
    mysearchBar.barStyle=UIBarStyleDefault;
    mysearchBar.placeholder=@"Enter Name";
    mysearchBar.keyboardType=UIKeyboardTypeNamePhonePad;
    UINavigationItem *navItem=[[UINavigationItem alloc] init];
    
    navItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:mysearchBar];
    navItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelClicked)];
    [navBar pushNavigationItem:navItem animated:YES];
    
    
    searchTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    searchTableView.showsVerticalScrollIndicator = NO;
    searchTableView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    searchTableView.dataSource = self;
    searchTableView.delegate = self;
    
   
}

#pragma mark - TableViewdelegate&&TableViewdataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [searchArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellName = @"cate_cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
   
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellName];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        CALayer *l = [cell.imageView layer];
        [l setMasksToBounds:YES];
        [l setCornerRadius:8.0];
    }
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (void)userSearch:(NSString *)userName{
//    ImageCache * imagecache = [ImageCache sharedObject];
//    NSMutableArray * follower = [imagecache getTwittersFollower];

    if (!_accountStore)
        _accountStore = [[ACAccountStore alloc] init];
    ACAccountType *twitterAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [self.accountStore requestAccessToAccountsWithType:twitterAccountType options:NULL completion:^(BOOL granted, NSError *error) {
        if (granted) {
            
            NSURL *searchUrl = [NSURL URLWithString:@"https://api.twitter.com/1.1/users/lookup.json"];
            NSArray *twitterAccounts = [self.accountStore accountsWithAccountType:twitterAccountType];
            NSMutableDictionary *followerparams = [[NSMutableDictionary alloc] init];
            [followerparams setObject:userName forKey:@"screen_name"];
            SLRequest *searchRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:searchUrl parameters:followerparams];
            [searchRequest setAccount:[twitterAccounts lastObject]];
            [searchRequest performRequestWithHandler: ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                
                if (responseData) {
                    if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300) {
                        NSError *jsonError;
                        NSArray *timelineData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&jsonError];
                        if (timelineData && [timelineData count] > 0){
                            NSDictionary *user = [timelineData objectAtIndex:0];
                            if (user) {
                                NSString *screenName = [user objectForKey:@"screen_name"];
                                NSString *userId = [user objectForKey:@"id"];
                                NSString *profileUrl = [user objectForKey:@"profile_image_url"];
                                NSLog(@"%@", screenName);
                                NSLog(@"%@", userId);
                                NSLog(@"%@", profileUrl);
                            }
                        }
                    }
                }
            }];
            
        }
    }];
    
    
}
#pragma mark searchBarDelegate
-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
//    NSString * username= searchBar.text;
//    [self userSearch:username];
    
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"");
}
-(void)cancelClicked
{
    mysearchBar.text = @"";
    mysearchBar.placeholder=@"Enter Name";
    [mysearchBar resignFirstResponder];
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
