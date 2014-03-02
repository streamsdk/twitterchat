//
//  ACKMessageDB.h
//  talk
//
//  Created by wangsh on 14-2-6.
//  Copyright (c) 2014年 wangshuai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface ACKMessageDB : NSObject

-(void) initDB;

-(void)insertDB:(NSString *)id withUserID:(NSString *)userID fromID:(NSString *)fromID withContent:(NSString *)content withTime:(NSString *)time withIsMine: (int)isMine;

-(void) deleteDB:(NSString *) id;

-(NSMutableArray *)readDb;

-(void) deleteDB;

@end
