//
//  ImageSendProtocol.h
//  talk
//
//  Created by wangsh on 14-1-4.
//  Copyright (c) 2014年 wangshuai. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ImageSendProtocol <NSObject>

-(void)sendImages:(NSData *)data withTime:(NSString *)time;

@end
