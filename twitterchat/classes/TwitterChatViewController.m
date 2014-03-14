//
//  TwitterChatViewController.m
//  twitterchat
//
//  Created by wangsh on 14-2-22.
//  Copyright (c) 2014年 wangshuai. All rights reserved.
//

#import "TwitterChatViewController.h"
#import "ImageCache.h"
#import "TwitterFollower.h"
#import "TwitterFollowing.h"
#import "MBProgressHUD.h"
#import "MainController.h"
#import "MBProgressHUD.h"
#import "STreamXMPP.h"
#import <arcstreamsdk/JSONKit.h>
#import <arcstreamsdk/STreamFile.h>
#import "TalkDB.h"
#import "DownloadDB.h"
#import "UploadDB.h"
#import "FollowerAndFollowingHandler.h"
#import "SearchViewController.h"
#import "RecentChat.h"
#import <arcstreamsdk/STreamCategoryObject.h>

@interface TwitterChatViewController ()<STreamXMPPProtocol,FollowerDelegate>
{
    NSMutableArray * followerArray;
    MainController *mainVC;
    FollowerAndFollowingHandler *followerAndFollowingHandler;
    NSInteger selectIndex;
    UIView *tableFooterView;
}
@end

@implementation TwitterChatViewController
@synthesize segmentedControl;
@synthesize messagesProtocol;
@synthesize uploadProtocol;
@synthesize countButton;

- (id)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void) followerLoadFailed{
   
}
-(void) followerLoadComplete {
//    ImageCache *imagecache = [ImageCache sharedObject];
//    followerArray = [imagecache getTwittersFollower];
//    [self.tableView reloadData];
}
-(void) loadComplete {
    __block MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.labelText = @"loading ...";
    [self.view addSubview:HUD];
    [HUD showAnimated:YES whileExecutingBlock:^{
        ImageCache *imagecache = [ImageCache sharedObject];
        followerArray = [imagecache getTwittersFollower];
    }completionBlock:^{
        [self.tableView reloadData];
        [HUD removeFromSuperview];
        HUD = nil;
    }];
}
-(void) LoadFailed {
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"Loading Error..." delegate:self cancelButtonTitle:@"YES" otherButtonTitles:nil, nil];
    [alertView show];
}
-(void)settingClicked{
    NSLog(@"");
}
-(void) searchBarUser{
    SearchViewController * searchView = [[SearchViewController alloc]init];
    searchView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self  presentViewController:searchView animated:NO completion:NULL];

    NSLog(@"search");
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBarHidden = NO;
    mainVC = [[MainController alloc]init];
    
    _reloading= NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    UIBarButtonItem * setItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"settings2.png"] style:UIBarButtonItemStyleDone target:self action:@selector(settingClicked)];
    
    UIBarButtonItem *searchBarItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchBarUser)];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:setItem,searchBarItem, nil];
//     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"settings2.png"] style:UIBarButtonItemStyleDone target:self action:@selector(settingClicked)];
    UISegmentedControl *segmentedTemp = [[UISegmentedControl alloc]initWithFrame: CGRectMake(80.0, 3.0, 160.0, 38.0)];
    segmentedControl = segmentedTemp;
    [segmentedControl insertSegmentWithTitle:@"follower" atIndex:0 animated:YES];
    [segmentedControl insertSegmentWithTitle:@"following" atIndex:1 animated:YES];
    [segmentedControl insertSegmentWithTitle:@"Recent" atIndex:2 animated:YES];
    segmentedControl.momentary = YES;
    segmentedControl.multipleTouchEnabled=NO;
    segmentedControl.selectedSegmentIndex= 0;
    selectIndex= 0;
    [segmentedControl addTarget:self action:@selector(segmentAction:)forControlEvents:UIControlEventValueChanged];
    [ self.navigationController.navigationBar.topItem setTitleView:segmentedControl];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(loadComplete) name:@"followerLoadComplete" object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(LoadFailed) name:@"followerLoadFailed" object:nil];


    followerAndFollowingHandler = [[FollowerAndFollowingHandler alloc]init];

     ImageCache * imagecache  = [ImageCache sharedObject];
    
    [followerAndFollowingHandler getAllFollowing: [imagecache getUserID] withCursorId:@"-1"];
    [followerAndFollowingHandler  getAllFollower:[imagecache getUserID] withCursorId:@"-1"];
    __block MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.labelText = @"loadingting ...";
    [self.view addSubview:HUD];
    [HUD showAnimated:YES whileExecutingBlock:^{
        STreamCategoryObject *sco = [[STreamCategoryObject alloc] initWithCategory:@"alluser"];
        [sco load:^(BOOL succeed, NSString *error) {
            if (succeed){
                NSMutableArray *sos = [sco streamObjects];
                for (STreamObject * so in sos) {
                    [imagecache saveAllUserId:[so objectId]];
                }
                
            }

        }];
//         [followerAndFollowingHandler getAllFollowing: [imagecache getUserID] withCursorId:@"-1"];
//        [followerAndFollowingHandler  getAllFollower:[imagecache getUserID] withCursorId:@"-1"];
//        followerArray = [imagecache getTwittersFollower];
//        while ([followerArray count]==0) {
//            followerArray = [imagecache getTwittersFollower];
//        }
    }completionBlock:^{
        [HUD removeFromSuperview];
        HUD = nil;
    }];
    
    
    __block MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.labelText = @"connecting ...";
    [self.view addSubview:hud];
    [hud showAnimated:YES whileExecutingBlock:^{
        [self connect];
    }completionBlock:^{
        [hud removeFromSuperview];
        hud = nil;
    }];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appHasBackInForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}
- (void)appHasBackInForeground{
    __block MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.labelText = @"connecting ...";
    [self.view addSubview:HUD];
    [HUD showAnimated:YES whileExecutingBlock:^{
        [self connect];
    }completionBlock:^{
        [self.tableView reloadData];
        [HUD removeFromSuperview];
        HUD = nil;
    }];
}

-(void) connect {
    ImageCache * imagecache  = [ImageCache sharedObject];
    [self setMessagesProtocol:mainVC];
    STreamXMPP *con = [STreamXMPP sharedObject];
    [con setXmppDelegate:self];
    [self setUploadProtocol:mainVC];
    [self setMessagesProtocol:mainVC];
    if (![con connected]){
        self.title = @"connecting...";
        [con connect:[imagecache getUserID] withPassword:@"password"];
    }
    
}

- (void)startDownload{
    DownloadDB * downloadDB = [[DownloadDB alloc]init];
    NSMutableArray * downloadArray = [downloadDB readDownloadDB];
    if (downloadArray!=nil && [downloadArray count]!=0) {
        for (NSMutableArray* array in downloadArray) {
            NSString * fileId = [array objectAtIndex:0];
            NSString * body = [array objectAtIndex:1];
            NSString * fromId = [array objectAtIndex:2];
            
            NSData *jsonData = [body dataUsingEncoding:NSUTF8StringEncoding];
            JSONDecoder *decoder = [[JSONDecoder alloc] initWithParseOptions:JKParseOptionNone];
            NSMutableDictionary *json = [decoder objectWithData:jsonData];
            NSString *type = [json objectForKey:@"type"];
            if (![type isEqualToString:@"video"]) {
                [downloadDB deleteDownloadDBFromFileID:fileId];
                [self didReceiveFile:fileId withBody:body withFrom:fromId];
            }
            
        }
    }
}
- (void)startUpload{
    
    UploadDB * uploadDB = [[UploadDB alloc]init];
    NSMutableArray * uploadArray = [uploadDB readUploadDB];
    if (uploadArray != nil && [uploadArray count] != 0) {
        for (NSMutableArray* array in uploadArray) {
            NSString * filePath = [array objectAtIndex:0];
            NSString * time= [array objectAtIndex:1];
            NSString * fromId = [array objectAtIndex:2];
            NSString * type = [array objectAtIndex:3];
            [uploadProtocol uploadVideoPath:filePath withTime:time withFrom:fromId withType:type];
        }
    }
}

- (void)readHistory{

    ImageCache * imagecache = [ImageCache sharedObject];
    STreamObject *so = [[STreamObject alloc] init];
    NSMutableString *history = [[NSMutableString alloc] init];
    [history appendString:[imagecache getUserID]];
    [history appendString:@"messaginghistory"];
    [so loadAll:history];
    NSArray *keys = [so getAllKeys];
    NSMutableString *removedKeys = [[NSMutableString alloc] init];
    int index = 0;
    for (NSString *key in keys){
        NSString *value = [so getValue:key];
        NSString *jsonValue = [value substringFromIndex:13];
        NSData *jsonData = [jsonValue dataUsingEncoding:NSUTF8StringEncoding];
        JSONDecoder *decoder = [[JSONDecoder alloc] initWithParseOptions:JKParseOptionNone];
        NSDictionary *json = [decoder objectWithData:jsonData];
        NSString *type = [json objectForKey:@"type"];
        NSString *from = [json objectForKey:@"from"];
        if ([type isEqualToString:@"text"]){
            NSString *receivedMessage = [json objectForKey:@"message"];
            [self didReceiveMessage:receivedMessage withFrom:from];
        }
        if ([type isEqualToString:@"video"] || [type isEqualToString:@"photo"] || [type isEqualToString:@"voice"]){
            NSString *fileId = [json objectForKey:@"fileId"];
            [self didReceiveFile:fileId withBody:jsonValue withFrom:from];
        }
               [removedKeys appendString:key];
        if (index != [keys count] - 1){
            [removedKeys appendString:@"&&"];
        }
        
        index++;
    }
    
    if ([keys count] > 0){
        STreamObject *sob = [[STreamObject alloc] init];
        [sob removeKeyInBackground:removedKeys forObjectId:history];
    }
    
}


#pragma mark - STreamXMPPProtocol
- (void)didAuthenticate{
    NSLog(@"");
    self.title = @"reading...";
    [self startDownload];
    [self readHistory];
    [self startUpload];
}



- (void)didNotAuthenticate:(NSXMLElement *)error{
    self.title = @"failed...";
    NSLog(@" ");
}

- (void)didReceivePresence:(XMPPPresence *)presence{
    self.title = @"";
    NSString *presenceType = [presence type];
    if ([presenceType isEqualToString:@"subscribe"]){
        
    }
    if ([presenceType isEqualToString:@"available"]){
    }
    if ([presenceType isEqualToString:@"unavailable"]){
        
    }
    
}
- (void)didReceiveMessage:(NSString *)message withFrom:(NSString *)fromID{
    ImageCache *imageCache = [ImageCache sharedObject];
    NSString *friendId = [imageCache getFriendID];
    if (![friendId isEqualToString:fromID]) {
        [imageCache saveMessagesCount:fromID];
    }
    
    NSMutableDictionary *jsonDic = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *friendDict = [NSMutableDictionary dictionary];
    
    NSString * userID = [imageCache getUserID];
    [friendDict setObject:message forKey:@"messages"];
    [jsonDic setObject:friendDict forKey:fromID];
    NSString  *str = [jsonDic JSONString];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    NSDate * date =[NSDate dateWithTimeIntervalSinceNow:0];
    NSString * str2 = [dateFormatter stringFromDate:date];
    
    TalkDB * db = [[TalkDB alloc]init];
    [db insertDBUserID:userID fromID:fromID withContent:str withTime:str2 withIsMine:1];
    
    [messagesProtocol getMessages:message withFromID:fromID];
    [self.tableView reloadData];
}

- (void)didReceiveFile:(NSString *)fileId withBody:(NSString *)body withFrom:(NSString *)fromID{
    ImageCache *imageCache = [ImageCache sharedObject];    
    NSString *friendId = [imageCache getFriendID];
    if (![friendId isEqualToString:fromID]) {
        [imageCache saveMessagesCount:fromID];
    }
    
    DownloadDB * downloadDB = [[DownloadDB alloc]init];
    [downloadDB insertDownloadDB:[imageCache getUserID] fileID:fileId withBody:body withFrom:fromID];
    
    STreamFile *sf = [[STreamFile alloc] init];
    /*NSData *jsonData = [body dataUsingEncoding:NSUTF8StringEncoding];
    JSONDecoder *decoder = [[JSONDecoder alloc] initWithParseOptions:JKParseOptionNone];
    NSMutableDictionary *json = [decoder objectWithData:jsonData];
    NSString *type = [json objectForKey:@"type"];
    
    if ([type isEqualToString:@"video"]) {
        
        
      NSString *tid= [json objectForKey:@"tid"];
        if (tid){
            fileId = tid;
            [downloadDB insertDownloadDB:[handler getUserID] fileID:fileId withBody:body withFrom:fromID];
        }else {
            [imageCache saveJsonData:body forFileId:fileId];
            NSString *jsonBody = [imageCache getJsonData:fileId];
            NSData *jsonData = [jsonBody dataUsingEncoding:NSUTF8StringEncoding];
            JSONDecoder *decoder = [[JSONDecoder alloc] initWithParseOptions:JKParseOptionNone];
            NSMutableDictionary *json = [decoder objectWithData:jsonData];
            NSMutableDictionary *jsonDic = [[NSMutableDictionary alloc]init];
            NSString *type = [json objectForKey:@"type"];
            NSString *fromUser = [json objectForKey:@"from"];
            NSString * fileId = [json objectForKey:@"fileId"];
            NSMutableDictionary *friendDict = [NSMutableDictionary dictionary];
            NSString *duration = [json objectForKey:@"duration"];
            NSString * tidpath= [[handler getPath] stringByAppendingString:@".png"];
            NSData *data ;
            [data writeToFile:tidpath atomically:YES];
            [handler videoPath:tidpath];
            
            if (duration)
                [friendDict setObject:duration forKey:@"duration"];
            [friendDict setObject:tidpath forKey:@"tidpath"];
            [friendDict setObject:fileId forKey:@"fileId"];
            [jsonDic setObject:friendDict forKey:fromUser];
            
            NSMutableDictionary * jsondict = [[NSMutableDictionary alloc]init];
            [jsondict setObject:type forKey:@"type"];
            [jsondict setObject:tidpath forKey:@"tidpath"];
            if (duration)
                [jsondict setObject:duration forKey:@"duration"];
            [jsondict setObject:fileId forKey:@"fileId"];
            
            NSString* jsBody = [jsondict JSONString];
            
            TalkDB * db = [[TalkDB alloc]init];
            NSString * userID = [handler getUserID];
            NSString  *str = [jsonDic JSONString];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
            NSDate * date = [NSDate dateWithTimeIntervalSinceNow:0];
            [handler setDate:date];
            [db insertDBUserID:userID fromID:fromUser withContent:str withTime:[dateFormatter stringFromDate:date] withIsMine:1];
            [messagesProtocol getFiles:data withFromID:fromUser withBody:jsBody withPath:tidpath];
            [self.tableView reloadData];
            return;
        }
    }*/
    [imageCache saveJsonData:body forFileId:fileId];
    
    
    [sf downloadAsData:fileId downloadedData:^(NSData *data, NSString *objectId){
        
        
        NSString *jsonBody = [imageCache getJsonData:objectId];
        [downloadDB deleteDownloadDBFromFileID:objectId];
        NSData *jsonData = [jsonBody dataUsingEncoding:NSUTF8StringEncoding];
        JSONDecoder *decoder = [[JSONDecoder alloc] initWithParseOptions:JKParseOptionNone];
        NSMutableDictionary *json = [decoder objectWithData:jsonData];
        NSString *type = [json objectForKey:@"type"];
        NSString *fromUser = [json objectForKey:@"from"];
        
        NSMutableDictionary *jsonDic = [[NSMutableDictionary alloc]init];
        NSString * path;
        NSString * jsBody;
        if ([type isEqualToString:@"photo"]) {
            NSString *duration = [json objectForKey:@"duration"];
            NSString *photoPath = [[imageCache getPath] stringByAppendingString:@".png"];
            [data writeToFile:photoPath atomically:YES];
            NSMutableDictionary *friendDict = [NSMutableDictionary dictionary];
            if (duration) {
                [friendDict setObject:duration forKey:@"time"];
            }
            [friendDict setObject:photoPath forKey:@"photo"];
            [jsonDic setObject:friendDict forKey:fromUser];
            path = photoPath;
            jsBody = body;
        }else if ([type isEqualToString:@"video"]){
            
            NSString * tid = [json objectForKey:@"tid"];
            NSString * fileId = [json objectForKey:@"fileId"];
            NSMutableDictionary *friendDict = [NSMutableDictionary dictionary];
            NSString *duration = [json objectForKey:@"duration"];
            NSString * tidpath= [[imageCache getPath] stringByAppendingString:@".png"];
            [data writeToFile : tidpath atomically: YES ];
            [imageCache savevideoPath:tidpath];
            
            if (duration)
                [friendDict setObject:duration forKey:@"duration"];
            [friendDict setObject:tidpath forKey:@"tidpath"];
            [friendDict setObject:tid forKey:@"tid"];
            [friendDict setObject:fileId forKey:@"fileId"];
            [jsonDic setObject:friendDict forKey:fromUser];
            path = tidpath;
            
            
            NSMutableDictionary * jsondict = [[NSMutableDictionary alloc]init];
            [jsondict setObject:type forKey:@"type"];
            [jsondict setObject:tidpath forKey:@"tidpath"];
            if (duration)
                [jsondict setObject:duration forKey:@"duration"];
            [jsondict setObject:tid forKey:@"tid"];
            [jsondict setObject:fileId forKey:@"fileId"];
            jsBody = [jsondict JSONString];
        }else if ([type isEqualToString:@"voice"]){
            
            NSString *duration = [json objectForKey:@"duration"];
            NSMutableDictionary * friendsDict = [NSMutableDictionary dictionary];
            NSString * recordFilePath = [[imageCache getPath] stringByAppendingString:@".aac"];
            [data writeToFile:recordFilePath atomically:YES];
            path = recordFilePath;
            [friendsDict setObject:duration forKey:@"time"];
            [friendsDict setObject:recordFilePath forKey:@"audiodata"];
            [jsonDic setObject:friendsDict forKey:fromUser];
            jsBody = body;
        }
        
        TalkDB * db = [[TalkDB alloc]init];
        NSString * userID = [imageCache getUserID];
        NSString  *str = [jsonDic JSONString];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
        NSDate * date = [NSDate dateWithTimeIntervalSinceNow:0];
        [imageCache saveDate:date];
        [db insertDBUserID:userID fromID:fromUser withContent:str withTime:[dateFormatter stringFromDate:date] withIsMine:1];
        [messagesProtocol getFiles:data withFromID:fromUser withBody:jsBody withPath:path];
        [self.tableView reloadData];
        
    }];
    
    
}

-(void) segmentAction:(UISegmentedControl *)segmented{
    self.tableView.tableFooterView = nil;
    ImageCache * imageCache =[ImageCache sharedObject];
    if (segmented.selectedSegmentIndex == 0) {
        followerArray = [imageCache getTwittersFollower];
    }else if (segmented.selectedSegmentIndex == 1){
        followerArray = [imageCache getTwittersFollowing];
    }else if (segmented.selectedSegmentIndex == 2){
        TalkDB * talkDb = [[TalkDB alloc]init];
        [talkDb readInTalkDB:[imageCache getUserID]];
        followerArray = [imageCache getRecentChat];
    }
    selectIndex = segmented.selectedSegmentIndex;
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [followerArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        CALayer *l = [cell.imageView layer];
        [l setMasksToBounds:YES];
        [l setCornerRadius:8.0];
        countButton = [UIButton buttonWithType:UIButtonTypeCustom];
     
        [countButton setFrame:CGRectMake(50, 0, 28, 28)];
        cell.textLabel.font = [UIFont fontWithName:@"Arial" size:10.0f];
        [cell addSubview:countButton];

    }
    [self setImage:[UIImage imageNamed:@"noavatar.png"] withCell:cell];
    ImageCache * imagecache = [ImageCache sharedObject];
    NSInteger count = 0;
    if (selectIndex == 0) {
        TwitterFollower * f =[followerArray objectAtIndex:indexPath.row];
        [self loadFollowerProfileId:f withCell:cell];
        cell.textLabel.text = f.name;
        count =[imagecache getMessagesCount:f.userid];
    }else if (selectIndex == 1) {
        TwitterFollowing * f =[followerArray objectAtIndex:indexPath.row];
         [self loadFollowingProfileId:f withCell:cell];
        cell.textLabel.text = f.name;
       count = [imagecache getMessagesCount:f.userid];
    }else if (selectIndex == 2) {
        RecentChat * recent =[followerArray objectAtIndex:indexPath.row];
        [self loadRecentProfileId:recent withCell:cell];
        cell.textLabel.text = recent.name;
        count = [imagecache getMessagesCount:recent.userid];
    }
    if (count!= 0) {
        NSString * title =[NSString stringWithFormat:@"%d",count];
        [countButton setBackgroundImage:[UIImage imageNamed:@"message_count.png"] forState:UIControlStateNormal];
        [countButton setTitle:title forState:UIControlStateNormal];
    }
    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:16.0f];
    
    
    return cell;
}

-(void)loadFollowerProfileId:(TwitterFollower *)follower withCell:(UITableViewCell *)cell{
    ImageCache *imagechache = [ImageCache sharedObject];
    NSURL *url = [NSURL URLWithString:follower.profileUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (!error ){
                                   NSString *profilePath = [[imagechache getPath] stringByAppendingString:@".png"];
                                   [follower setProfilePath:profilePath];
                                   UIImage *_image = [UIImage imageWithData:data];
                                   [self setImage:_image withCell:cell];
     
                               }
                           }];

    
}
-(void)loadFollowingProfileId:(TwitterFollowing *)following withCell:(UITableViewCell *)cell{
    ImageCache *imagechache = [ImageCache sharedObject];
    NSURL *url = [NSURL URLWithString:following.profileUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (!error ){
                                   NSString *profilePath = [[imagechache getPath] stringByAppendingString:@".png"];
                                   [following setProfilePath:profilePath];
                                   UIImage *_image = [UIImage imageWithData:data];
                                   [self setImage:_image withCell:cell];
                                   
                               }
                           }];
    
    
}
-(void)loadRecentProfileId:(RecentChat *)recent withCell:(UITableViewCell *)cell{
    ImageCache *imagechache = [ImageCache sharedObject];
    NSURL *url = [NSURL URLWithString:recent.profileUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (!error ){
                                   NSString *profilePath = [[imagechache getPath] stringByAppendingString:@".png"];
                                   [recent setProfilePath:profilePath];
                                   UIImage *_image = [UIImage imageWithData:data];
                                   [self setImage:_image withCell:cell];
                                   
                               }
                           }];
    
    
}

-(void)setImage:(UIImage *)icon withCell:(UITableViewCell *)cell{
    CGSize itemSize = CGSizeMake(45, 45);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO,0.0);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [icon drawInRect:imageRect];
    
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ImageCache *imageCache = [ImageCache sharedObject];
    if (selectIndex == 0) {
        TwitterFollower * f = [followerArray objectAtIndex:indexPath.row];
        f.userid = [NSString stringWithFormat:@"%@",f.userid];
        [imageCache setFriendID:f.userid];
        [imageCache saveFriendID:f.userid withFriendName:f.name];
        [imageCache removeFriendID:f.userid];
    }
    if (selectIndex == 1) {
        TwitterFollowing * f =[followerArray objectAtIndex:indexPath.row];
        f.userid = [NSString stringWithFormat:@"%@",f.userid];
        [imageCache setFriendID:f.userid];
        [imageCache saveFriendID:f.userid withFriendName:f.name];
        [imageCache removeFriendID:f.userid];
    }
    if (selectIndex == 2) {
        RecentChat * recent =[followerArray objectAtIndex:indexPath.row];
        recent.userid = [NSString stringWithFormat:@"%@",recent.userid];
        [imageCache setFriendID:recent.userid];
        [imageCache saveFriendID:recent.userid withFriendName:recent.name];
        [imageCache removeFriendID:recent.userid];
    }
    [self.navigationController pushViewController:mainVC animated:NO];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    // 下拉到最底部时显示更多数据
    if(!_reloading && scrollView.contentOffset.y > ((scrollView.contentSize.height - scrollView.frame.size.height)))
    {
        [self loadDataBegin];
    }
}

// 开始加载数据
- (void) loadDataBegin
{
    if (_reloading == NO)
    {
        _reloading = YES;
        ImageCache * imagecache = [ImageCache sharedObject];
        if (selectIndex == 0) {
            if (![[imagecache getFollowerCoursor]isEqualToString:@"0"]) {
                UIActivityIndicatorView *tableFooterActivityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 20.0f, 20.0f)];
                [tableFooterActivityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
                activityIndicator = tableFooterActivityIndicator;
                [activityIndicator startAnimating];
                self.tableView.tableFooterView = activityIndicator;
            
            }
        }
        if (selectIndex == 1) {
            if (![[imagecache getFollowingCoursor]isEqualToString:@"0"]) {
                UIActivityIndicatorView *tableFooterActivityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 20.0f, 20.0f)];
                [tableFooterActivityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
                activityIndicator = tableFooterActivityIndicator;
                [activityIndicator startAnimating];
                self.tableView.tableFooterView = activityIndicator;
            }
        }
        [self loadDataing];
    }
}

// 加载数据中
- (void) loadDataing
{
    NSLog(@"index = %d",selectIndex);
    ImageCache * imagecache = [ImageCache sharedObject];
    if (selectIndex == 0) {
        if (![[imagecache getFollowerCoursor]isEqualToString:@"0"]) {
            [followerAndFollowingHandler getAllFollower: [imagecache getUserID] withCursorId:[imagecache getFollowerCoursor]];
            NSMutableArray * array = [[NSMutableArray alloc]init];
            array = [imagecache getTwittersFollower];
            followerArray =array;
            
        }
    }
    if (selectIndex == 1) {
       if (![[imagecache getFollowingCoursor]isEqualToString:@"0"]) {
            [followerAndFollowingHandler getAllFollowing:[imagecache getUserID] withCursorId:[imagecache getFollowingCoursor]];
            NSMutableArray * array = [[NSMutableArray alloc]init];
            array = [imagecache getTwittersFollowing];
           
            followerArray =array;
        }
    }
    
     [self performSelector:@selector(loadDataEnd) withObject:nil afterDelay:2.0];
}

// 加载数据完毕
- (void) loadDataEnd
{
    _reloading = NO;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
//    self.tableView.contentInset = UIEdgeInsetsZero;
    [UIView commitAnimations];
    [activityIndicator stopAnimating];
    [self.tableView reloadData];
}

@end
