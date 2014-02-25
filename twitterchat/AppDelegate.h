//
//  AppDelegate.h
//  twitterchat
//
//  Created by wangshuai on 05/01/2014.
//  Copyright (c) 2014 wangshuai. All rights reserved.
//

#import <UIKit/UIKit.h>
#define APPDELEGATE ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,strong) UIProgressView * progressView;
@property (nonatomic,retain) NSMutableDictionary *progressDict;
@end
