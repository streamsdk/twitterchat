//
//  UploadProtocol.h
//  talk
//
//  Created by wangsh on 14-2-14.
//  Copyright (c) 2014年 wangshuai. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UploadProtocol <NSObject>

-(void) uploadVideoPath:(NSString *)filePath withTime:(NSString *)time withFrom:(NSString *)fromID withType:(NSString *)type;

@end
