//
//  PlayerDelegate.h
//  talk
//
//  Created by wangshuai on 13-12-22.
//  Copyright (c) 2013年 wangshuai. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PlayerDelegate <NSObject>

-(void) playerVideo:(NSString *)path withTime:(NSString *)time withDate:(NSDate *)date;

-(void)bigImage:(UIImage *)image;

-(void) disappearImage:(UIImage *)image withDissapearTime:(NSString *)time withDissapearPath:(NSString *)path withSendOrReceiveTime:(NSDate *)date;

@end
