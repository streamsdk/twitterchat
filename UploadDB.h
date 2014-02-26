//
//  UploadDB.h
//  talk
//
//  Created by wangsh on 14-2-14.
//  Copyright (c) 2014年 wangshuai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface UploadDB : NSObject

-(void) initDB;

-(void) insertUploadDB:(NSString *)userId filePath:(NSString *)filepath withTime:(NSString *)time withFrom:(NSString *)fromID withType:(NSString *)type;

-(NSMutableArray *) readUploadDB;

-(void) deleteUploadDBFromFilepath:(NSString *) filePath;

@end
