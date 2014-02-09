//
//  AppDelegate.m
//  twitterchat
//
//  Created by wangshuai on 05/01/2014.
//  Copyright (c) 2014 wangshuai. All rights reserved.
//

#import "AppDelegate.h"
#import <arcstreamsdk/STreamSession.h>
#import <arcstreamsdk/STreamObject.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   
    
    [STreamSession setUpServerUrl:@"http://streamsdk.cn/api/"];
    [STreamSession authenticate:@"D0F265CCCA4B5CD697C95BD5048A7A88" secretKey:@"64163935A44EDEDFD1D19BD12929431A"
                      clientKey:@"A872FAB46994591F3A6CFE6E2F8EC32F" response:^(BOOL succeed, NSString *response){
                          if (succeed){
                              
                          
                          }
                          
    }];
    
    [NSThread sleepForTimeInterval:5];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  }

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    }

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
   
}

@end
