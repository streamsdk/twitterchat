//
//  FilesUpload.h
//  talk
//
//  Created by wangsh on 14-2-8.
//  Copyright (c) 2014年 wangshuai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilesUpload : NSObject

@property (nonatomic,retain) NSString * chatId;
@property (nonatomic,retain) NSString * time;
@property (nonatomic,retain) NSString *filepath;
@property (nonatomic,retain) NSMutableDictionary * bodyDict;
@property (nonatomic,retain) NSString * userId;
@property (nonatomic,retain) NSString * type;
@property (nonatomic,retain) NSString * disappearTime;
@property (nonatomic,retain) NSData *imageData;
@end
