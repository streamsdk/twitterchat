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
#import "ChineseString.h"
#import "pinyin.h"
#import "MainController.h"

@interface TwitterChatViewController ()
{
    NSMutableArray * followerArray;
}
@end

@implementation TwitterChatViewController
@synthesize loading;
@synthesize sectionHeadsKeys;
@synthesize sortedArrForArrays;
@synthesize segmentedControl;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)settingClicked{
    NSLog(@"");
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBarHidden = NO;
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"settings2.png"] style:UIBarButtonItemStyleDone target:self action:@selector(settingClicked)];
    UISegmentedControl *segmentedTemp = [[UISegmentedControl alloc]initWithFrame: CGRectMake(80.0, 3.0, 160.0, 38.0)];
    segmentedControl = segmentedTemp;
    [segmentedControl insertSegmentWithTitle:@"follower" atIndex:0 animated:YES];
    [segmentedControl insertSegmentWithTitle:@"following" atIndex:1 animated:YES];
    segmentedControl.momentary = YES;
    segmentedControl.multipleTouchEnabled=NO;
    segmentedControl.selectedSegmentIndex= 0;
    [segmentedControl addTarget:self action:@selector(segmentAction:)forControlEvents:UIControlEventValueChanged];
    [ self.navigationController.navigationBar.topItem setTitleView:segmentedControl];
//    [segmentedControl setBackgroundColor:[UIColor lightGrayColor]];

    sectionHeadsKeys=[[NSMutableArray alloc]init];
    
    __block MBProgressHUD *HUD = [[MBProgressHUD alloc] init];
    HUD.labelText = @"loading ...";
    [self.view addSubview:HUD];
    [HUD showAnimated:YES whileExecutingBlock:^{
        [self loadingFollower];
    }completionBlock:^{
        ImageCache * imageCache =[ImageCache sharedObject];
        followerArray = [imageCache getTwittersFollower];
        [HUD removeFromSuperview];
        HUD = nil;
        sortedArrForArrays = [self getChineseStringArr:followerArray];
        [self.tableView reloadData];
    }];
   
}
-(void)loadingFollower{
    while(loading){
        sleep(1);
    }
}
-(void) loadingFollowing{
    while(loading){
        sleep(1);
    }
}
-(void) segmentAction:(UISegmentedControl *)segmented{
    
    sectionHeadsKeys=[[NSMutableArray alloc]init];
    if (segmented.selectedSegmentIndex == 0) {
       
        
        __block MBProgressHUD *HUD = [[MBProgressHUD alloc] init];
        HUD.labelText = @"loading ...";
        [self.view addSubview:HUD];
        [HUD showAnimated:YES whileExecutingBlock:^{
            [self loadingFollower];
        }completionBlock:^{
            ImageCache * imageCache =[ImageCache sharedObject];
            followerArray = [imageCache getTwittersFollower];
            [HUD removeFromSuperview];
            HUD = nil;
            sortedArrForArrays = [self getChineseStringArr:followerArray];
            [self.tableView reloadData];
        }];

    }else{
        __block MBProgressHUD *HUD = [[MBProgressHUD alloc] init];
        HUD.labelText = @"loading ...";
        [self.view addSubview:HUD];
        [HUD showAnimated:YES whileExecutingBlock:^{
            [self loadingFollowing];
        }completionBlock:^{
            ImageCache * imageCache =[ImageCache sharedObject];
            followerArray = [imageCache getTwittersFollowing];
            [HUD removeFromSuperview];
            HUD = nil;
            sortedArrForArrays = [self getChineseStringArr:followerArray];
            [self.tableView reloadData];
        }];

    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  [[sortedArrForArrays objectAtIndex:section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [sortedArrForArrays count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [sectionHeadsKeys objectAtIndex:section];
}
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return  nil;
    }
    
    UILabel * label = [[UILabel alloc] init];
    label.frame = CGRectMake(10, 0, 320, 24);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font=[UIFont fontWithName:@"Arial" size:19.0f];
    label.text = sectionTitle;
    
    UIView * sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 24)] ;
    [sectionView setBackgroundColor:[UIColor blackColor]];
    [sectionView addSubview:label];
    return sectionView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        CALayer *l = [cell.imageView layer];
        [l setMasksToBounds:YES];
        [l setCornerRadius:8.0];
    }
    NSArray *arr = [sortedArrForArrays objectAtIndex:indexPath.section];
     ChineseString *str = (ChineseString *) [arr objectAtIndex:indexPath.row];
    if (segmentedControl.selectedSegmentIndex == 0) {
        for (TwitterFollower *f in followerArray) {
            if ([f.screenName isEqualToString:str.string]) {
                cell.imageView.image = [UIImage imageNamed:@"noavatar.png"];
                [self loadFollowerProfileId:f withCell:cell];
            }
        }

    }else{
        for (TwitterFollowing *f in followerArray) {
            if ([f.screenName isEqualToString:str.string]) {
                cell.imageView.image = [UIImage imageNamed:@"noavatar.png"];
                [self loadFollowingProfileId:f withCell:cell];
            }
        }

    }
    
    cell.textLabel.text = str.string;
    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:18.0f];
    
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

-(void)setImage:(UIImage *)icon withCell:(UITableViewCell *)cell{
    CGSize itemSize = CGSizeMake(50, 50);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO,0.0);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [icon drawInRect:imageRect];
    
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
}

- (NSMutableArray *)getChineseStringArr:(NSMutableArray *)arrToSort {
    NSMutableArray *chineseStringsArray = [[NSMutableArray alloc]init];
    for(int i = 0; i < [arrToSort count]; i++) {
        ChineseString *chineseString=[[ChineseString alloc]init];
        TwitterFollower * f = [arrToSort objectAtIndex:i];
        chineseString.string=[NSString stringWithString:f.screenName];
        
        if(chineseString.string==nil){
            chineseString.string=@"";
        }
        
        if(![chineseString.string isEqualToString:@""]){
            //join the pinYin
            NSString *pinYinResult = [NSString string];
            for(int j = 0;j < chineseString.string.length; j++) {
                NSString *singlePinyinLetter = [[NSString stringWithFormat:@"%c",
                                                 pinyinFirstLetter([chineseString.string characterAtIndex:j])]uppercaseString];
                
                pinYinResult = [pinYinResult stringByAppendingString:singlePinyinLetter];
            }
            chineseString.pinYin = pinYinResult;
        } else {
            chineseString.pinYin = @"";
        }
        [chineseStringsArray addObject:chineseString];
    }
    
    //sort the ChineseStringArr by pinYin
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]];
    [chineseStringsArray sortUsingDescriptors:sortDescriptors];
    
    
    NSMutableArray *arrayForArrays = [[NSMutableArray alloc]init];
    BOOL checkValueAtIndex= NO;  //flag to check
    NSMutableArray *TempArrForGrouping = [[NSMutableArray alloc]init];
    for(int index = 0; index < [chineseStringsArray count]; index++)
    {
        ChineseString *chineseStr = (ChineseString *)[chineseStringsArray objectAtIndex:index];
        NSMutableString *strchar= [NSMutableString stringWithString:chineseStr.pinYin];
        NSString *sr= [strchar substringToIndex:1];
        //        NSLog(@"%@",sr);        //sr containing here the first character of each string
        if(![sectionHeadsKeys containsObject:[sr uppercaseString]])//here I'm checking whether the character already in the selection header keys or not
        {
            [sectionHeadsKeys addObject:[sr uppercaseString]];
            TempArrForGrouping = [[NSMutableArray alloc] initWithObjects:nil];
            checkValueAtIndex = NO;
        }
        if([sectionHeadsKeys containsObject:[sr uppercaseString]])
        {
            [TempArrForGrouping addObject:[chineseStringsArray objectAtIndex:index]];
            if(checkValueAtIndex == NO)
            {
                [arrayForArrays addObject:TempArrForGrouping];
                checkValueAtIndex = YES;
            }
        }
    }
    return arrayForArrays;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ImageCache *imageCache = [ImageCache sharedObject];
    NSMutableArray * keys = [sortedArrForArrays objectAtIndex:indexPath.section];
    ChineseString * userStr = [keys objectAtIndex:indexPath.row];
    NSString *userName = [userStr string];
    
    if (segmentedControl.selectedSegmentIndex == 0) {
        for (TwitterFollower *f in followerArray) {
            if ([f.screenName isEqualToString:userName]) {
                [imageCache setFriendID:f.userid];
            }
        }
        
    }else{
        for (TwitterFollowing *f in followerArray) {
            if ([f.screenName isEqualToString:userName]) {
                 [imageCache setFriendID:f.userid];
            }
        }
        
    }
    MainController * mainVC= [[MainController alloc]init];
    [self.navigationController pushViewController:mainVC animated:NO];
}

@end
