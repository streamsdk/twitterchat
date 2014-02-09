//
//  ViewController.h
//  twitterchat
//
//  Created by wangshuai on 05/01/2014.
//  Copyright (c) 2014 wangshuai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>


@interface ViewController : UIViewController


-(void)fetchFellowerAndFollowing:(NSString *)userName;
-(void)fetchAccounts:(NSString *)userName;

@property (nonatomic) ACAccountStore *accountStore;


@end
