//
//  SearchViewController.h
//  twitterchat
//
//  Created by wangsh on 14-3-1.
//  Copyright (c) 2014年 wangshuai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@interface SearchViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (nonatomic,strong) UISearchBar *mysearchBar;

@property (nonatomic,strong) NSMutableArray * searchArray;

@property(nonatomic,strong) UITableView * searchTableView;

@property (nonatomic) ACAccountStore *accountStore;
@end
