//
//  TwitterChatViewController.h
//  twitterchat
//
//  Created by wangsh on 14-2-22.
//  Copyright (c) 2014年 wangshuai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwitterChatViewController : UITableViewController
@property (assign)BOOL loading;
@property (nonatomic, retain) NSMutableArray *sortedArrForArrays;
@property (nonatomic, retain) NSMutableArray *sectionHeadsKeys;
@property (nonatomic,strong) UISegmentedControl *segmentedControl;
@end
