//
//  MainViewController.m
//  talk
//
//  Created by wangsh on 13-10-31.
//  Copyright (c) 2013年 wangshuai. All rights reserved.
//

#import "MainController.h"
#import <arcstreamsdk/STreamSession.h>
#import <arcstreamsdk/STreamFile.h>
#import <arcstreamsdk/STreamUser.h>
#import <arcstreamsdk/STreamQuery.h>
#import <MediaPlayer/MediaPlayer.h>
#import "NSBubbleData.h"
#import "STreamXMPP.h"
#import "Voice.h"
#import "CreateUI.h"
#import "XMPPMessage.h"
#import "LoginViewController.h"
#import "MBProgressHUD.h"
#import "ImageCache.h"
#import "PlayerDelegate.h"
#import <arcstreamsdk/JSONKit.h>
#import <arcstreamsdk/STreamQuery.h>
#import "PhotoHandler.h"
#import "VideoHandler.h"
#import "MessageHandler.h"
#import "AudioHandler.h"
#import "ImageViewController.h"
#import "TalkDB.h"
#import "UIImageViewController.h"
#import "TwitterFollower.h"
#import "TwitterFollowing.h"

#define BUTTON_TAG 20000
#define TOOLBARTAG		200
#define TABLEVIEWTAG	300
#define BIG_IMG_WIDTH  300.0
#define BIG_IMG_HEIGHT 340.0
#define INVITBUTTON_TAG 10000
#define LABLE_TAG		30000

@interface MainController () <UIScrollViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,PlayerDelegate,reloadTableDeleage>
{
    NSMutableArray *bubbleData;
    CreateUI * createUI;
    
    UIScrollView *scrollView;//表情滚动视图
    UIPageControl *pageControl;
    UIButton *sendButton;
    
    BOOL keyboardIsShow;//键盘是否显示
    BOOL isFace;
    
    NSData *myData;
    NSData * otherData;

    PhotoHandler *photoHandler;
    VideoHandler *videoHandler;
    MessageHandler *messageHandler;
    AudioHandler *audioHandler;
    
    UIImage * sendImage;
    
    BOOL isVideo;
    BOOL isVideoFromGallery;
    BOOL isClearData;
    
    UIImageView * backgroundView;
}

@property(nonatomic,retain) Voice * voice;

@end

@implementation MainController

@synthesize bubbleTableView,toolBar,messageText,iconButton ,recordButton,recordOrKeyboardButton,keyBoardButton,faceButton;
@synthesize voice;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)initWithToolBar{
    
    //初始化为NO added
    keyboardIsShow=NO;
    isFace = NO;
    isVideoFromGallery = NO;
    recordOrKeyboardButton = [createUI setButtonFrame:CGRectMake(toolBar.frame.size.width-33, 3,30, 34) withTitle:(@"nil")];
    [recordOrKeyboardButton setImage:[UIImage imageNamed:@"microphonefat.png"] forState:UIControlStateNormal];
    [recordOrKeyboardButton addTarget:self action:@selector(KeyboardTorecordClicked) forControlEvents:UIControlEventTouchUpInside];
   
    iconButton = [createUI setButtonFrame:CGRectMake(0, 5, 30, 30) withTitle:@"nil"];
    [iconButton setImage:[UIImage imageNamed:@"plus256.png"] forState:UIControlStateNormal];
    [iconButton addTarget:self action:@selector(photoClicked) forControlEvents:UIControlEventTouchUpInside];
    
    messageText = [createUI setTextFrame:CGRectMake(33, 3, toolBar.frame.size.width-65, 34)];
    messageText.delegate = self;
    messageText.returnKeyType = UIReturnKeySend;
    messageText.autocapitalizationType = UITextAutocapitalizationTypeNone;
//    faceButton = [createUI setButtonFrame:CGRectMake(toolBar.frame.size.width-33, 3,30, 34) withTitle:@"nil"];
//    [faceButton setImage:[UIImage imageNamed:@"face512.png"] forState:UIControlStateNormal];
//    [faceButton addTarget:self action:@selector(faceClicked) forControlEvents:UIControlEventTouchUpInside];

    [toolBar addSubview:recordOrKeyboardButton];
    [toolBar addSubview:iconButton];
    [toolBar addSubview:messageText];
//    [toolBar addSubview:faceButton];
    
}
-(NSData *)getProfileAvatar{
    NSData *avatarData;
    ImageCache * imageCache =  [ImageCache sharedObject];
    NSString *sendToID = [imageCache getFriendID];
    NSMutableArray * followerArray = [imageCache getTwittersFollower];
    for (TwitterFollower *f in followerArray) {
        
        f.userid = [NSString stringWithFormat:@"%@",f.userid];
        if ([f.userid isEqualToString:sendToID]) {
            avatarData = [NSData dataWithContentsOfFile:f.profilePath];
        }
    }
    NSMutableArray * followingArray = [imageCache getTwittersFollowing];
    for (TwitterFollowing *f in followingArray) {
        
        f.userid = [NSString stringWithFormat:@"%@",f.userid];
        if ([f.userid isEqualToString:sendToID]) {
            
            avatarData = [NSData dataWithContentsOfFile:f.profilePath];
        }
    }
    return avatarData;
}
-(void)viewWillAppear:(BOOL)animated{
    
     [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    ImageCache * imageCache =  [ImageCache sharedObject];
    NSString *sendToID = [imageCache getFriendID];
    
    self.title = [NSString stringWithFormat:@"chat to %@",sendToID];
  
    bubbleData = [[NSMutableArray alloc]init];
    TalkDB * talk =[[TalkDB alloc]init];
    bubbleData = [talk readInitDB:[imageCache getUserID] withOtherID:sendToID];
    for (NSBubbleData * data in bubbleData) {
        data.delegate = self;
    }
    otherData = [self getProfileAvatar];
   //
//    NSMutableDictionary *userMetaData = [imageCache getUserMetadata:userID];
//    NSString *pImageId = [userMetaData objectForKey:@"profileImageId"];
//    myData = [imageCache getImage:pImageId];
//    
//    NSMutableDictionary *metaData = [imageCache getUserMetadata:sendToID];
//    NSString *pImageId2 = [metaData objectForKey:@"profileImageId"];
//    otherData = [imageCache getImage:pImageId2];
//    
//    BackData *data = [BackData sharedObject];
//    UIImage *bgImage =[data getImage];
//    
//    ChatBackGround * chat = [[ChatBackGround alloc]init];
//    NSString *path = [chat readChatBackGround:[handler getUserID] withFriendID:[imageCache getFriendID]];
//    if (bgImage) {
//        [backgroundView setImage:bgImage];
//
//    }else{
//        [backgroundView setBackgroundColor:[UIColor whiteColor]];
//        [backgroundView setImage:[UIImage imageNamed:@""]];
//    }
//    if (path) {
//        NSData * data = [NSData dataWithContentsOfFile:path];
//        [backgroundView setImage:[UIImage imageWithData:data]];
//    }
    UIButton * invite = (UIButton *)[self.view viewWithTag:INVITBUTTON_TAG];
    UILabel * label = (UILabel *)[self.view viewWithTag:LABLE_TAG];
    NSMutableSet * alluserId = [imageCache getAllUserId];
    if (![alluserId containsObject:[imageCache getFriendID]]) {
        STreamQuery *sq = [[STreamQuery alloc] initWithCategory:@"alluser"];
        
        [sq addLimitId:[imageCache getFriendID]];
        NSMutableArray *array = [sq find];
       
        if (array==nil || [array count]==0) {
            invite.hidden  = NO;
            label.hidden = NO;
          
        }else{
            invite.hidden  = YES;
            label.hidden = YES;
            [imageCache saveAllUserId:[imageCache getFriendID]];
        }

    }else{
        invite.hidden  = YES;
        label.hidden = YES;
    }
    
    [bubbleTableView reloadData];
    [self dismissKeyBoard];
    [self scrollBubbleViewToBottomAnimated:YES];
}
-(void)SetBackground{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"set chat background", @"clear history data",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
//    ChatSettingViewController * chat = [[ChatSettingViewController alloc]init];
//    [self.navigationController pushViewController:chat animated:YES];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (isVideo) {
       /* CGFloat _time = [self getVideoDuration:videoPath];
        NSString * time = [NSString stringWithFormat:@"%f",_time];
        if (buttonIndex == 0) {
            [self sendVideo:time];
        }else{
            [self sendVideo:nil];
        }*/
        isVideo = NO;
    }else{
        if (buttonIndex ==0) {
//            BackgroundImgViewController * bgView = [[BackgroundImgViewController alloc]init];
//            bgView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//            [self presentViewController:bgView animated:YES completion:nil];
            
        }else if (buttonIndex ==1){
            isClearData = YES;
            UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"" message:@"Are you sure clear data?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"YES", nil];
            view .delegate = self;
            [view show];
        }
    }
   
}
-(void)invite {
    NSLog(@"");
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view
    
    isVideo=NO;
    isClearData = NO;
    
    createUI = [[CreateUI alloc]init];
    self.voice = [[Voice alloc] init];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(SetBackground)];

    backgroundView = [[UIImageView alloc]initWithFrame:self.view.frame];
    backgroundView.userInteractionEnabled = YES;
    [self.view addSubview:backgroundView];
    
    UIImageView * backView = [[UIImageView alloc]initWithFrame:self.view.frame];
    backView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [backView addGestureRecognizer:singleTouch];
    [backView setBackgroundColor:[UIColor clearColor]];
    [backgroundView addSubview:backView];
    //bubbleTableView
    bubbleTableView = [[UIBubbleTableView alloc]initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height-44-40)];
    bubbleTableView .bubbleDataSource = self;
    bubbleTableView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin |UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
    [backView addSubview:bubbleTableView];
    
    NSString * text =@"Please Keep message clean and positive. Inappropriate content can be reported.";
    UIFont *font = [UIFont systemFontOfSize:20];;
    CGSize size = [(text ? text : @"") boundingRectWithSize:CGSizeMake(305, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(12, 100, size.width, size.height)];
    label.text = text;
    label.textColor = [UIColor grayColor];
    label.backgroundColor = [UIColor lightGrayColor];
    label.layer.cornerRadius = 6;
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:label];
    label.hidden = YES;
    label.tag = LABLE_TAG;

    UIButton *inviteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [inviteButton setFrame:CGRectMake(10, 64, self.view.frame.size.width-20, 34)];
    [inviteButton setTitle:@"INVITATION" forState:UIControlStateNormal];
    inviteButton.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    [[inviteButton layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[inviteButton layer] setBorderWidth:1];
    [[inviteButton layer] setCornerRadius:4];
    [inviteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [inviteButton addTarget:self action:@selector(invite) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:inviteButton];
    inviteButton .tag = INVITBUTTON_TAG;
    inviteButton.hidden = YES;
    

    toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-40, self.view.frame.size.width, 40)];
    toolBar.tag = TOOLBARTAG;
    toolBar.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin |UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
    [backView addSubview:toolBar];
    [toolBar setTintColor:[UIColor blackColor]];
    [self initWithToolBar];
    
    bubbleTableView.tag = TABLEVIEWTAG;
    bubbleTableView.snapInterval = 120;
    bubbleTableView.showAvatars = YES;
    //给键盘注册通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //handler
    photoHandler = [[PhotoHandler alloc] init];
    
    videoHandler = [[VideoHandler alloc]init];
    
    messageHandler = [[MessageHandler alloc] init];
    
    audioHandler = [[AudioHandler alloc]init];

//    ImageCache * imageCache =  [ImageCache sharedObject];
    
}

#pragma mark - UIBubbleTableViewDataSource implementation

- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView
{
    return [bubbleData count];
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row
{
    return [bubbleData objectAtIndex:row];
}

-(void)getFiles:(NSData *)data withFromID:(NSString *)fromID withBody:(NSString *)body withPath:(NSString *)path{
    
    ImageCache *imageCache = [ImageCache sharedObject];
    NSString *sendToID =[imageCache getFriendID];
//    
//    NSMutableDictionary *userMetaData = [imageCache getUserMetadata:[handler getUserID]];
//    NSString *pImageId = [userMetaData objectForKey:@"profileImageId"];
//    myData = [imageCache getImage:pImageId];

//    NSMutableDictionary *metaData = [imageCache getUserMetadata:sendToID];
//    NSString *pImageId2 = [metaData objectForKey:@"profileImageId"];
//    otherData = [imageCache getImage:pImageId2];
    otherData = [self getProfileAvatar];
    
    NSData *jsonData = [body dataUsingEncoding:NSUTF8StringEncoding];
    JSONDecoder *decoder = [[JSONDecoder alloc] initWithParseOptions:JKParseOptionNone];
    NSDictionary *json = [decoder objectWithData:jsonData];
    NSString *type = [json objectForKey:@"type"];
     NSString * time = [json objectForKey:@"duration"];
    if ([path isEqualToString:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]]) {
//        [photoHandler receiveFile:data withPath:path forBubbleDataArray:bubbleData withTime:time forBubbleOtherData:otherData withSendId:sendToID withFromId:fromID];
//        if ([bubbleData count]!=0) {
//            NSBubbleData * bubble = [bubbleData lastObject];
//            [imageCache saveBubbleData:bubble withKey:body];
//        }
      
        
    }else{
        if ([type isEqualToString:@"photo"]) {
            [photoHandler setController:self];
            [photoHandler receiveFile:data withPath:path forBubbleDataArray:bubbleData withTime:time forBubbleOtherData:otherData withSendId:sendToID withFromId:fromID];

        }else if ([type isEqualToString:@"video"]){

            [videoHandler setController:self];
            [videoHandler receiveVideoFile:data forBubbleDataArray:bubbleData forBubbleOtherData:otherData withVideoTime:time withSendId:sendToID withFromId:fromID withJsonBody:body];

           
        }else if ([type isEqualToString:@"voice"]){
            [audioHandler receiveAudioFile:data withBody:time forBubbleDataArray:bubbleData forBubbleOtherData:otherData withSendId:sendToID withFromId:fromID];
        }
        NSBubbleData * bubble = [bubbleData lastObject];
        bubble.delegate = self;

    }
    [bubbleTableView reloadData];
    [self scrollBubbleViewToBottomAnimated:YES];
    

}
-(void)getMessages:(NSString *)messages withFromID:(NSString *)fromID{
    ImageCache *imageCache = [ImageCache sharedObject];
    NSString *sendToID =[imageCache getFriendID];
    [messageHandler receiveMessage:messages forBubbleDataArray:bubbleData forBubbleOtherData:otherData withSendId:sendToID withFromId:fromID];
    [bubbleTableView reloadData];
    [self scrollBubbleViewToBottomAnimated:YES];

}
#pragma mark - Actions

#pragma mark send  message
-(void)sendMessages {
    ImageCache *imageCache = [ImageCache sharedObject];
    NSString *sendToID =[imageCache getFriendID];  
    if (sendToID) {
        
        NSString * messages = messageText.text;
        if ([messages length]!=0) {
            [messageHandler sendMessage:messages forBubbleDataArray:bubbleData forBubbleMyData:myData withSendId:sendToID];
            messageText.text = @"";
            [self dismissKeyBoard];
            [messageText resignFirstResponder];
            [bubbleTableView reloadData];
            [self scrollBubbleViewToBottomAnimated:YES];
        }else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"" message:@"please input chat Contents" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }else{
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"" message:@"you are waiting..." delegate:self cancelButtonTitle:@"YES" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    
    [self dismissKeyBoard];
    
}
#pragma mark send photo

-(UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
-(void) sendPhoto :(NSData *)data withTime:(NSString *)time{
    [self dismissKeyBoard];
    ImageCache *imageCache = [ImageCache sharedObject];
    
//    HandlerUserIdAndDateFormater *handler = [HandlerUserIdAndDateFormater sharedObject];
//    NSMutableDictionary *userMetaData = [imageCache getUserMetadata:[handler getUserID]];
//    NSString *pImageId = [userMetaData objectForKey:@"profileImageId"];
//    myData = [imageCache getImage:pImageId];
    NSString *sendToID =[imageCache getFriendID];
    NSMutableArray * dataArray = [[NSMutableArray alloc]init];
    TalkDB * talk =[[TalkDB alloc]init];
    dataArray = [talk readInitDB:[imageCache getUserID] withOtherID:sendToID];
    bubbleData = dataArray;
    for (NSBubbleData * data in bubbleData) {
        data.delegate = self;
    }
    if (sendToID) {
        [photoHandler setController:self];
        [photoHandler sendPhoto:data forBubbleDataArray:bubbleData forBubbleMyData:myData withSendId:sendToID withTime:time];
    }
//
    [bubbleTableView reloadData];
    [self scrollBubbleViewToBottomAnimated:YES];
}

-(void) sendVideo:(NSString *)time {
    ImageCache *imageCache = [ImageCache sharedObject];
    NSString *sendToID =[imageCache getFriendID];
    if (sendToID) {
        [videoHandler setController:self];
        [videoHandler setVideoPath:videoPath];
        [videoHandler sendVideoforBubbleDataArray:bubbleData withVideoTime:time forBubbleMyData:myData withSendId:sendToID];
        NSBubbleData * last = [bubbleData lastObject];
        last.delegate = self;
         videoHandler.delegate = self;
    }
   
    [self dismissKeyBoard];
    [bubbleTableView reloadData];
    [self scrollBubbleViewToBottomAnimated:YES];
}
#pragma mark send audio
-(void) sendRecordAudio {
    ImageCache *imageCache = [ImageCache sharedObject];
    NSString *sendToID =[imageCache getFriendID];
    if (self.voice.recordTime >= 0.5f) {
        [audioHandler sendAudio:voice forBubbleDataArray:bubbleData forBubbleMyData:myData withSendId:sendToID];
        [bubbleTableView reloadData];
        [self scrollBubbleViewToBottomAnimated:YES];
        
    }else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Send Failed" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"", nil];
        [alert show];
    }

}

-(void) recordStart
{
    [self.voice startRecordWithPath];
}
-(void) recordEnd
{
    [self.voice stopRecordWithCompletionBlock:^{
        
        if (self.voice.recordTime >= 0.5f) {
            
            [self sendRecordAudio];
        }
    }];
}
-(void) recordCancel
{
    [self.voice cancelled];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"Deleted" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [alert show];
}


//recordToKeyboardClicked
-(void) recordToKeyboardClicked {
    [keyBoardButton removeFromSuperview];
    [recordButton removeFromSuperview];
    [self initWithToolBar];
}
// KeyboardTorecordClicked
-(void) KeyboardTorecordClicked {
    
    [self dismissKeyBoard];
    [scrollView removeFromSuperview];
    [recordOrKeyboardButton removeFromSuperview];
    [messageText removeFromSuperview];
    [iconButton removeFromSuperview];
    [faceButton removeFromSuperview];
    CGRect frame = CGRectMake(5, 2, 30, 36);
     keyBoardButton = [createUI setButtonFrame:frame withTitle:@"nil"];
    [keyBoardButton setImage:[UIImage imageNamed:@"keyboard512.png"] forState:UIControlStateNormal];
    
    [[recordButton layer] setBorderColor:[[UIColor blackColor] CGColor]];
    [[recordButton layer] setBorderWidth:1];
    [[recordButton layer] setCornerRadius:4];
    [keyBoardButton addTarget:self action:@selector(recordToKeyboardClicked) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *title =@"Hold to Talk";
    CGRect frame2 = CGRectMake(46, 2, toolBar.frame.size.width-60, 36);
    recordButton = [createUI setButtonFrame:frame2 withTitle:title];
    [[recordButton layer] setBorderColor:[[UIColor blackColor] CGColor]];
    [[recordButton layer] setBorderWidth:1];
    [[recordButton layer] setCornerRadius:4];
    [recordButton setBackgroundColor:[UIColor lightGrayColor]];
    [recordButton addTarget:self action:@selector(recordStart) forControlEvents:UIControlEventTouchDown];
    [recordButton addTarget:self action:@selector(recordEnd) forControlEvents:UIControlEventTouchUpInside];
    [recordButton addTarget:self action:@selector(recordCancel) forControlEvents:UIControlEventTouchUpOutside];
    
    [toolBar addSubview:keyBoardButton];
    [toolBar addSubview:recordButton];
}

#pragma MARK Icon button 表情事件
-(void) disIconKeyboard {
    [self scrollBubbleViewToBottomAnimated:YES];
    //如果直接点击，通过toolbar的位置来判断
    if (toolBar.frame.origin.y== self.view.bounds.size.height - toolBarHeight&&toolBar.frame.size.height==toolBarHeight) {
        [UIView animateWithDuration:Time animations:^{
            toolBar.frame = CGRectMake(0, self.view.frame.size.height-ICONHEIGHT-toolBarHeight,  self.view.bounds.size.width,toolBarHeight);
            UIBubbleTableView *tableView = (UIBubbleTableView *)[self.view viewWithTag:TABLEVIEWTAG];
            tableView.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width,(float)(self.view.frame.size.height-ICONHEIGHT-40.0));
            
        }];
        [UIView animateWithDuration:Time animations:^{
            [scrollView setFrame:CGRectMake(0, self.view.frame.size.height-ICONHEIGHT,self.view.frame.size.width, ICONHEIGHT)];
        }];
         return;
    }
    //如果键盘没有显示
    if (isFace) {
        [UIView animateWithDuration:Time animations:^{
            [scrollView setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, TABLEVIEWTAG)];
        }];
        [messageText becomeFirstResponder];
        
    }else{
        
        //键盘显示的时候，toolbar需要还原到正常位置
        [UIView animateWithDuration:Time animations:^{
            toolBar.frame = CGRectMake(0, self.view.frame.size.height-ICONHEIGHT-toolBar.frame.size.height,  self.view.bounds.size.width,toolBar.frame.size.height);
            UIBubbleTableView *tableView = (UIBubbleTableView *)[self.view viewWithTag:TABLEVIEWTAG];
            tableView.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width,(float)(self.view.frame.size.height-ICONHEIGHT-40.0));
            
        }];
        
        [UIView animateWithDuration:Time animations:^{
            [scrollView setFrame:CGRectMake(0, self.view.frame.size.height-ICONHEIGHT  ,self.view.frame.size.width, ICONHEIGHT)];
        }];
        [messageText resignFirstResponder];
    }

}
#pragma MARK face button 表情事件
-(void)disFaceKeyboard{
    //如果直接点击表情，通过toolbar的位置来判断
    if (toolBar.frame.origin.y== self.view.bounds.size.height - toolBarHeight&&toolBar.frame.size.height==toolBarHeight) {
        [UIView animateWithDuration:Time animations:^{
            toolBar.frame = CGRectMake(0, self.view.frame.size.height-keyboardHeight-toolBarHeight,  self.view.bounds.size.width,toolBarHeight);
            UIBubbleTableView *tableView = (UIBubbleTableView *)[self.view viewWithTag:TABLEVIEWTAG];
            tableView.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width,(float)(self.view.frame.size.height-keyboardHeight-40.0));
            
        }];
        [UIView animateWithDuration:Time animations:^{
            [scrollView setFrame:CGRectMake(0, self.view.frame.size.height-keyboardHeight,self.view.frame.size.width, keyboardHeight)];
        }];
        [self scrollBubbleViewToBottomAnimated:YES];
        [faceButton setImage:[UIImage imageNamed:@"keyboard512.png"] forState:UIControlStateNormal];
        [pageControl setHidden:NO];
        return;
    }
    //如果键盘没有显示，点击表情了，隐藏表情，显示键盘
    if (!keyboardIsShow) {
        [UIView animateWithDuration:Time animations:^{
            [scrollView setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, keyboardHeight)];
        }];
        [messageText becomeFirstResponder];
        [pageControl setHidden:YES];
        [sendButton removeFromSuperview];


    }else{
        [self scrollBubbleViewToBottomAnimated:YES];
        //键盘显示的时候，toolbar需要还原到正常位置，并显示表情
        [UIView animateWithDuration:Time animations:^{
            toolBar.frame = CGRectMake(0, self.view.frame.size.height-keyboardHeight-toolBar.frame.size.height,  self.view.bounds.size.width,toolBar.frame.size.height);
            UIBubbleTableView *tableView = (UIBubbleTableView *)[self.view viewWithTag:TABLEVIEWTAG];
            tableView.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width,(float)(self.view.frame.size.height-keyboardHeight-40.0));
            
        }];
        
        [UIView animateWithDuration:Time animations:^{
            [scrollView setFrame:CGRectMake(0, self.view.frame.size.height-keyboardHeight,self.view.frame.size.width, keyboardHeight)];
        }];
        [pageControl setHidden:NO];
        [messageText resignFirstResponder];
    }
}
#pragma mark 隐藏键盘

-(void)dismissKeyBoard{
    
    //键盘显示的时候，toolbar需要还原到正常位置，并显示表情
    [UIView animateWithDuration:Time animations:^{
        toolBar.frame = CGRectMake(0, self.view.frame.size.height-toolBar.frame.size.height,  self.view.bounds.size.width,toolBar.frame.size.height);
        bubbleTableView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64-toolBarHeight);
    }];
    
    [UIView animateWithDuration:Time animations:^{
        [scrollView setFrame:CGRectMake(0, self.view.frame.size.height,self.view.frame.size.width, keyboardHeight)];
    }];
    [faceButton setImage:[UIImage imageNamed:@"face512.png"] forState:UIControlStateNormal];
    [messageText resignFirstResponder];
//    UIButton *button = (UIButton *)[self.view viewWithTag:BUTTON_TAG];
    [sendButton removeFromSuperview];
    [pageControl setHidden:YES];
}


#pragma mark 监听键盘的显示与隐藏

-(void) autoMovekeyBoard: (float) h{
    
    UIToolbar *toolbar = (UIToolbar *)[self.view viewWithTag:TOOLBARTAG];
    toolbar.frame = CGRectMake(0.0f, (float)(self.view.frame.size.height-h-40.0), self.view.frame.size.width, 40.0f);
    UIBubbleTableView *tableView = (UIBubbleTableView *)[self.view viewWithTag:TABLEVIEWTAG];
    tableView.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width,(float)(self.view.frame.size.height-h-40.0));
    [self scrollBubbleViewToBottomAnimated:YES];
}
-(void)inputKeyboardWillShow:(NSNotification *)notification{
    //键盘显示，设置toolbar的frame跟随键盘的frame
   CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:animationTime animations:^{
        CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        NSValue *animationDurationValue = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSTimeInterval animationDuration;
        [animationDurationValue getValue:&animationDuration];
    
        //NSLog(@"键盘即将出现：%@", NSStringFromCGRect(keyBoardFrame));
        if (toolBar.frame.size.height>40) {
            toolBar.frame = CGRectMake(0, keyBoardFrame.origin.y-20-toolBar.frame.size.height,  self.view.bounds.size.width,toolBar.frame.size.height);
        }else{
            keyBoardFrame.size.height = keyBoardFrame.size.height< keyBoardFrame.size.width ?keyBoardFrame.size.height:keyBoardFrame.size.width;
            [self autoMovekeyBoard:keyBoardFrame.size.height];
        }
    }];
    [self scrollBubbleViewToBottomAnimated:YES];
    [faceButton setImage:[UIImage imageNamed:@"face512.png"] forState:UIControlStateNormal];
    [pageControl setHidden:YES];
    keyboardIsShow=YES;
    
}
-(void)inputKeyboardWillHide:(NSNotification *)notification{
    NSDictionary* userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [faceButton setImage:[UIImage imageNamed:@"keyboard512.png"] forState:UIControlStateNormal];
    [pageControl setHidden:NO];
    keyboardIsShow=NO;
    [messageText resignFirstResponder];
}

#pragma mark -
#pragma mark facialView delegate 点击表情键盘上的文字
-(void)selectedFacialView:(NSString*)str
{
    
    NSString *newStr;
    if ([str isEqualToString:@"删除"]) {
        if (messageText.text.length>0) {
            if ([[Emoji allEmoji] containsObject:[messageText.text substringFromIndex:messageText.text.length-2]]) {
                newStr=[messageText.text substringToIndex:messageText.text.length-2];
            }else{
                NSLog(@"删除文字%@",[messageText.text substringFromIndex:messageText.text.length-1]);
                newStr=[messageText.text substringToIndex:messageText.text.length-1];
            }
            messageText.text=newStr;
        }
    }else{
        NSString *newStr=[NSString stringWithFormat:@"%@%@",messageText.text,str];
        [messageText setText:newStr];
    }
}
#pragma mark PhotoButton clicked
-(void) photoClicked {
    isFace = NO;
    [scrollView removeFromSuperview];
    [pageControl removeFromSuperview];
    scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, ICONHEIGHT)];
    [scrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"facesBack.png"]]];
    for (int i=0; i<5; i++) {
        IconView *fview=[[IconView alloc] initWithFrame:CGRectMake(320*i, 15, self.view.frame.size.width, facialViewHeight)];
        [fview setBackgroundColor:[UIColor clearColor]];
        [fview loadIconView:i size:CGSizeMake(40, 40)];
        fview.delegate=self;
        [scrollView addSubview:fview];
    }
    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    scrollView.contentSize=CGSizeMake(320, ICONHEIGHT);
    scrollView.pagingEnabled=YES;
    scrollView.delegate=self;
    [self.view addSubview:scrollView];
    [self disIconKeyboard];
}
#pragma mark Face button 
-(void) faceClicked {
    [scrollView removeFromSuperview];
    [pageControl removeFromSuperview];
    [sendButton removeFromSuperview];
    //创建表情键盘
    scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, keyboardHeight)];
    [scrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"facesBack"]]];
    for (int i=0; i<9; i++) {
        FacialView *fview=[[FacialView alloc] initWithFrame:CGRectMake(12+320*i, 15, facialViewWidth, facialViewHeight)];
        [fview setBackgroundColor:[UIColor clearColor]];
        [fview loadFacialView:i size:CGSizeMake(33, 43)];
        fview.delegate=self;
        [scrollView addSubview:fview];
    }

    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    scrollView.contentSize=CGSizeMake(320*9, keyboardHeight);
    scrollView.pagingEnabled=YES;
    scrollView.delegate=self;
    [self.view addSubview:scrollView];
    isFace = YES;
    pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(84, self.view.frame.size.height-35, 150, 30)];
    [pageControl setCurrentPage:0];
    pageControl.pageIndicatorTintColor=RGBACOLOR(195, 179, 163, 1);
    pageControl.currentPageIndicatorTintColor=RGBACOLOR(132, 104, 77, 1);
    pageControl.numberOfPages = 9;//指定页面个数
    [pageControl setBackgroundColor:[UIColor clearColor]];
    pageControl.hidden=YES;
    [pageControl addTarget:self action:@selector(changePage:)forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:pageControl];
    
     sendButton= [createUI setButtonFrame:CGRectMake(260, self.view.frame.size.height-35, 50, 30) withTitle:@"send"];
    [sendButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [[sendButton layer] setBorderColor:[[UIColor blackColor] CGColor]];
    [[sendButton layer] setBorderWidth:1];
    [[sendButton layer] setCornerRadius:4];
    sendButton.tag = BUTTON_TAG;
    [sendButton addTarget:self action:@selector(sendClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendButton];
    [self disFaceKeyboard];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    int page = scrollView.contentOffset.x / 320;//通过滚动的偏移量来判断目前页面所对应的小白点
    pageControl.currentPage = page;//pagecontroll响应值的变化
}
//pagecontroll的委托方法

- (void)changePage:(id)sender {
    int page = pageControl.currentPage;//获取当前pagecontroll的值
    [scrollView setContentOffset:CGPointMake(320 * page, 0)];//根据pagecontroll的值来改变scrollview的滚动位置，以此切换到指定的页面
}

#pragma mark - Tool Methods
- (void)addPhoto
{
    UIImagePickerController * imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.navigationBar.tintColor = [UIColor colorWithRed:72.0/255.0 green:106.0/255.0 blue:154.0/255.0 alpha:1.0];
	imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	imagePickerController.delegate = self;
	imagePickerController.allowsEditing = NO;
    imagePickerController.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
	[self presentViewController:imagePickerController animated:YES completion:NULL];
}
- (void)takePhoto
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"该设备不支持拍照功能"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"好", nil];
        [alert show];
    }else{
        UIImagePickerController * imagePickerController = [[UIImagePickerController alloc]init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.delegate = self;
//        imagePickerController.allowsEditing = NO;
        imagePickerController.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
        [self presentViewController:imagePickerController animated:YES completion:NULL];
    }
}
-(void)addVideo
{
    isVideoFromGallery = YES;
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.navigationBar.tintColor = [UIColor colorWithRed:72.0/255.0 green:106.0/255.0 blue:154.0/255.0 alpha:1.0];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    [self presentViewController:imagePicker animated:YES completion:NULL];
}

-(void) takeVideo {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"该设备不支持摄像功能"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"好", nil];
        [alert show];
    }else {
        
        UIImagePickerController *imagePickerController=[[UIImagePickerController alloc] init];
        imagePickerController.sourceType=UIImagePickerControllerSourceTypeCamera;
        imagePickerController.videoQuality = UIImagePickerControllerQualityTypeMedium;
        imagePickerController.delegate = self;
         imagePickerController.mediaTypes = [NSArray arrayWithObjects:(NSString*)kUTTypeImage,(NSString*)kUTTypeMovie,nil];
        imagePickerController.videoMaximumDuration = 30;
        
        [self presentViewController:imagePickerController animated:YES completion:NULL];
        
    }
   
}
#pragma mark 

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString*)kUTTypeImage]) {
        UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self dismissKeyBoard];
        [picker dismissViewControllerAnimated:NO completion:^{
            ImageViewController * imageview = [[ImageViewController alloc]init];
            imageview.image = image;
            imageview.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [self  presentViewController:imageview animated:NO completion:NULL];
        }];

    }else{
//        isVideo = YES;
        videoPath = [info objectForKey:UIImagePickerControllerMediaURL];
        CGFloat time = [self getVideoDuration:videoPath];
        NSData * data = [NSData dataWithContentsOfURL:videoPath];
        NSInteger size = [data length]/1024/1024;
        if (isVideoFromGallery) {
            if (size <= 15) {
               /* [picker dismissViewControllerAnimated:YES completion:^{
                    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                                  initWithTitle:nil
                                                  delegate:self
                                                  cancelButtonTitle:nil
                                                  destructiveButtonTitle:nil
                                                  otherButtonTitles:@"Expire after playing", @"Never Expire",nil];
                    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
                    [actionSheet showInView:self.view];
                }];*/
                [picker dismissViewControllerAnimated:YES completion:^{
                    [self sendVideo:nil];
                }];
                
            }else{
                isVideo = NO;
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Exceed the allowed video size. Maxium size is 15MB" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
                [alert show];
                [picker dismissViewControllerAnimated:YES completion:NULL];
                [self dismissKeyBoard];
                [self scrollBubbleViewToBottomAnimated:YES];

            }
            isVideoFromGallery = NO;
        }else{
            if (time<=30) {
                
                [picker dismissViewControllerAnimated:YES completion:^{
//                    UIActionSheet *actionSheet = [[UIActionSheet alloc]
//                                                  initWithTitle:nil
//                                                  delegate:self
//                                                  cancelButtonTitle:nil
//                                                  destructiveButtonTitle:nil
//                                                  otherButtonTitles:@"Expire after playing", @"Never Expire",nil];
//                    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
//                    [actionSheet showInView:self.view];
                }];
                
                /*UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"" message:@"the video is permanent？" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
                 alert.delegate = self;
                 [alert show];*/
                [self sendVideo:nil];

            }else{
                isVideo = NO;
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Exceed the allowed video size. Maxium size is 10MB" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
                [alert show];
                [picker dismissViewControllerAnimated:YES completion:NULL];
                [self dismissKeyBoard];
                [self scrollBubbleViewToBottomAnimated:YES];
            }

        }
        
    }

}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (isVideo) {
        CGFloat _time = [self getVideoDuration:videoPath];
        NSString * time = [NSString stringWithFormat:@"%f",_time];
        if (buttonIndex == 0) {
            [self sendVideo:time];
        }else{
            [self sendVideo:nil];
        }
        isVideo = NO;
    }
    if(isClearData){
        ImageCache * imagecache = [ImageCache sharedObject];
        TalkDB * talk = [[TalkDB alloc]init];
        if (buttonIndex == 1) {
            [talk deleteDB:[imagecache getUserID] withOtherID:[imagecache getFriendID]];
        }
        bubbleData = [[NSMutableArray alloc]init];
        bubbleData = [talk readInitDB:[imagecache getUserID] withOtherID:[imagecache getFriendID]];
        [bubbleTableView reloadData];
        isClearData = NO;
    }
}
- (CGFloat) getVideoDuration:(NSURL*) URL
{
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                     forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:URL options:opts];
    float second = 0;
    second = urlAsset.duration.value/urlAsset.duration.timescale;
    return second;
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
- (void)errorVideoCheck:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"You have successed!"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

-(void)sendClicked{
    [self sendMessages];
}
#pragma mark textFiledDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self sendMessages];
    return  YES;

}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self scrollBubbleViewToBottomAnimated:YES];
}

-(void) dismissKeyboard:(UITapGestureRecognizer *)estureRecognizer {
    [self dismissKeyBoard];
}

#pragma mark show bubbleview  lastrow
- (void) scrollBubbleViewToBottomAnimated:(BOOL)animated
{
    NSInteger lastSectionIdx = [bubbleTableView numberOfSections] - 1;
    
    if (lastSectionIdx >= 0)
    {
    	[bubbleTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:([bubbleTableView numberOfRowsInSection:lastSectionIdx] - 1) inSection:lastSectionIdx] atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    }
}

-(void)  selectedIconView:(NSInteger) buttonTag{
    
    if(buttonTag == 0){
        [self addPhoto];
        [self scrollBubbleViewToBottomAnimated:YES];
    }
    if (buttonTag == 1) {
        [self takePhoto];
        [self scrollBubbleViewToBottomAnimated:YES];
    }
    if (buttonTag == 2) {
        keyboardIsShow = YES;
        [self faceClicked];
        [self scrollBubbleViewToBottomAnimated:YES];
    }
        
}

-(void)bigImage:(UIImage *)image{
    UIImageViewController * iView = [[UIImageViewController alloc]init];
    iView.image = image;
    iView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:iView animated:YES completion:nil];
}

-(void) playerVideo:(NSString *)path  withTime:(NSString *)time withDate:(NSDate *)date{
    if ([path hasSuffix:@".mp4"]) {


    }else{
         return;
    }
   
}
-(void)disappearImage:(UIImage *)image withDissapearTime:(NSString *)time withDissapearPath:(NSString *)path withSendOrReceiveTime:(NSDate *)date{
    NSLog(@"");
}
-(void)reloadTable{
    NSBubbleData * bubble = [bubbleData lastObject];
    bubble.delegate = self;
    
    [bubbleTableView reloadData];
    [self scrollBubbleViewToBottomAnimated:YES];
}
-(void)sendImages:(NSData *)data withTime:(NSString *)time{
    [self sendPhoto:data withTime:time];

}
-(void) uploadVideoPath:(NSString *)filePath withTime:(NSString *)time withFrom:(NSString *)fromID withType:(NSString *)type{
    [self dismissKeyBoard];
    ImageCache *imageCache = [ImageCache sharedObject];
        NSString *sendToID =[imageCache getFriendID];
    NSMutableArray * dataArray = [[NSMutableArray alloc]init];
    TalkDB * talk =[[TalkDB alloc]init];
    dataArray = [talk readInitDB:[imageCache getUserID] withOtherID:sendToID];
    bubbleData = dataArray;
    for (NSBubbleData * data in bubbleData) {
        data.delegate = self;
    }
    if ([time isEqualToString:@"nil"]) {
        time =nil;
    }
    if ([type isEqualToString:@"video"]) {
        NSURL* _videoPath = [NSURL fileURLWithPath:filePath];
        
        [videoHandler setController:self];
        [videoHandler setVideoPath:_videoPath];
        [videoHandler setType:@"video"];
        [videoHandler sendVideoforBubbleDataArray:bubbleData withVideoTime:time forBubbleMyData:myData withSendId:fromID];
        NSBubbleData * last = [bubbleData lastObject];
        last.delegate = self;
        videoHandler.delegate = self;
    }
    if ([type isEqualToString:@"photo"]) {
        NSData * data = [NSData dataWithContentsOfFile:filePath];
        [photoHandler setController:self];
        [photoHandler setType:@"photo"];
        [photoHandler setPhotopath:filePath];
        [photoHandler sendPhoto:data forBubbleDataArray:bubbleData forBubbleMyData:myData withSendId:fromID withTime:time];
    }
    if ([type isEqualToString:@"voice"]) {
        Voice * v = [[Voice alloc]init];
        [v setRecordPath:filePath];
        [v setRecordTime:[time floatValue]];
        [audioHandler setIsAddUploadDB:YES];
        [audioHandler sendAudio:v forBubbleDataArray:bubbleData forBubbleMyData:myData withSendId:fromID];
    }
    [bubbleTableView reloadData];
    [self scrollBubbleViewToBottomAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
