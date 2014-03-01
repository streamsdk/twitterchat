//
//  TwitterChatViewController.h
//  twitterchat
//
//  Created by wangsh on 14-2-22.
//  Copyright (c) 2014年 wangshuai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetAllMessagesProtocol.h"
#import "UploadProtocol.h"

@interface TwitterChatViewController : UITableViewController

{
	
    UIActivityIndicatorView *activityIndicator;
	BOOL _reloading;
}
@property (nonatomic, retain) NSMutableArray *sortedArrForArrays;
@property (nonatomic, retain) NSMutableArray *sectionHeadsKeys;
@property (nonatomic,strong) UISegmentedControl *segmentedControl;
@property (assign,nonatomic) id<GetAllMessagesProtocol> messagesProtocol;
@property (assign,nonatomic) id<UploadProtocol> uploadProtocol;
@property(nonatomic,strong) UIButton * countButton;


@end
