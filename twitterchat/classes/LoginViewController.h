//
//  LoginViewController.h
//  twitterchat
//
//  Created by wangsh on 14-2-21.
//  Copyright (c) 2014年 wangshuai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@protocol  RequestCompletionDelegate <NSObject>

-(void)requestCompletion;

-(void)requestFailed;

@end

@interface LoginViewController : UIViewController

@property (nonatomic) ACAccountStore *accountStore;

@property (nonatomic,assign) id <RequestCompletionDelegate>requestCompletionDelegate;

@end

