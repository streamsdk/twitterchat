//
//  TalkDB.m
//  talk
//
//  Created by wangsh on 13-11-7.
//  Copyright (c) 2013年 wangshuai. All rights reserved.
//

#import "TalkDB.h"
#import "ImageCache.h"
#import <arcstreamsdk/JSONKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "TwitterFollower.h"
#import "TwitterFollowing.h"
#import "RecentChat.h"
@implementation TalkDB

-(NSString *) dataFilePath {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"talk.sqlite"];
    
}
-(void)initDB {
    
    sqlite3 * database ;
    if (sqlite3_open([[self dataFilePath] UTF8String], &database) != SQLITE_OK) {
        
        sqlite3_close(database);
        NSLog(@"Failed to open database");
    }
    
    NSString *createSQL = @"CREATE TABLE IF NOT EXISTS FILEID (ROW INTEGER PRIMARY KEY AUTOINCREMENT, USERID TEXT, FROMID TEXT,CONTENT TEXT,TIME TEXT,ISMINE INT);";
    char *errorMsg;
    if (sqlite3_exec (database, [createSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
        sqlite3_close(database);
        NSLog(@"Error creating table: %s", errorMsg);
    }

}

-(void) insertDBUserID:(NSString *)userID fromID:(NSString *)fromID withContent:(NSString *)content withTime:(NSString *)time withIsMine:(int)isMine {
    sqlite3 *database;
    if (sqlite3_open([[self dataFilePath] UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSLog(@"Failed to open database");
    }
    
    char *update = "INSERT INTO FILEID (USERID, FROMID, CONTENT, TIME ,ISMINE) VALUES (?, ?, ?, ?, ?);";
    
    char *errorMsg = NULL;
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(database, update, -1, &stmt, nil) == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, [userID UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 2, [fromID UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 3, [content UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 4, [time UTF8String], -1, NULL);
        sqlite3_bind_int(stmt, 5, isMine);
    }
    if (sqlite3_step(stmt) != SQLITE_DONE)
        NSLog( @"Error updating table: %s", errorMsg);
    sqlite3_finalize(stmt);
    sqlite3_close(database);

}

-(NSMutableArray *) readInitDB :(NSString *) _userID withOtherID:(NSString *)_friendID{
    
    ImageCache * imageCache =  [ImageCache sharedObject];
//    NSMutableDictionary *userMetaData = [imageCache getUserMetadata:_userID];
//    NSString *pImageId = [userMetaData objectForKey:@"profileImageId"];
    NSData* myData =nil;
    
//    NSMutableDictionary *metaData = [imageCache getUserMetadata:_friendID];
//    NSString *pImageId2 = [metaData objectForKey:@"profileImageId"];
    NSData *otherData = nil;

    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
    sqlite3 *database;
    
    if (sqlite3_open([[self dataFilePath] UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
    }
    
    NSString *sqlQuery = @"SELECT * FROM FILEID";
    sqlite3_stmt * statement;
    
    if (sqlite3_prepare_v2(database, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *userId = (char*)sqlite3_column_text(statement, 1);
            char *friendId =(char*) sqlite3_column_text(statement, 2);
            char *_content = (char*)sqlite3_column_text(statement, 3);
            char *time1  = (char*)sqlite3_column_text(statement, 4);
            int ismine = sqlite3_column_int(statement, 5);
            
            NSString * userID = [[NSString alloc]initWithUTF8String:userId];
            NSString *friendID = [[NSString alloc]initWithUTF8String:friendId];
            NSString *jsonstring = [[NSString alloc]initWithUTF8String:_content];
            NSString * time2 =[[NSString alloc]initWithUTF8String:time1];
            NSDictionary *ret = [jsonstring objectFromJSONString];
            NSDictionary * chatDic = [ret objectForKey:friendID];
        
//             NSString *nameFilePath = [self getCacheDirectory];
//            NSArray *array = [[NSArray alloc]initWithContentsOfFile:nameFilePath];
//            NSString * _uesrID = nil;
//            if (array && [array count]!= 0) {
//                _uesrID = [array objectAtIndex:0];
//            }
            NSString * _uesrID = nil;
            _uesrID = [imageCache getUserID];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
            NSDate *date = [dateFormatter dateFromString:time2];
            if ([userID isEqualToString:_userID] && [friendID isEqualToString:_friendID]) {
                if (ismine == 0) {
                    NSArray * keys = [chatDic allKeys];
                    for (NSString * key in keys) {
                        if ([key isEqualToString:@"messages"]) {
                            NSBubbleData * data = [[NSBubbleData alloc]initWithText:[chatDic objectForKey:@"messages"] date:date type:BubbleTypeMine];
                            if(myData)
                                data.avatar = [UIImage imageWithData:myData];
                            [dataArray addObject:data];
                        }else if ([key isEqualToString:@"filepath"]) {
                            /*NSURL *url = [NSURL fileURLWithPath:[chatDic objectForKey:@"filepath"]];
                             NSString * time = [chatDic objectForKey:@"duration"];
                            MPMoviePlayerController *player = [[MPMoviePlayerController alloc]initWithContentURL:url];
                            player.shouldAutoplay = NO;
                            UIImage *fileImage = [player thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
//                            NSData * data =[NSData dataWithContentsOfFile:[chatDic objectForKey:@"video"]];;
                            NSBubbleData *bdata = [NSBubbleData dataWithImage:fileImage withTime:time withType:@"video" date:date type:BubbleTypeMine withVidePath:[chatDic objectForKey:@"filepath"] withJsonBody:@""];
                            if(myData)
                                bdata.avatar = [UIImage imageWithData:myData];
                            [dataArray addObject:bdata];*/
                        }else if ([key isEqualToString:@"photo"]) {
                            NSData * data =[NSData dataWithContentsOfFile:[chatDic objectForKey:@"photo"]];
                            NSString * time = [chatDic objectForKey:@"time"];
                            NSBubbleData * bubbledata;
                            if (!time)
                                bubbledata = [NSBubbleData dataWithImage:[UIImage imageWithData:data] date:date type:BubbleTypeMine path:[chatDic objectForKey:@"photo"]];
                            else
                                bubbledata = [NSBubbleData dataWithImage:[UIImage imageWithData:data] withImageTime:time withPath:[chatDic objectForKey:@"photo"]date:date withType:BubbleTypeMine];;
//                                NSBubbleData *bubbledata = [NSBubbleData dataWithImage:[UIImage imageWithData:data] date:date type:BubbleTypeMine]
                            if(myData)
                                bubbledata.avatar = [UIImage imageWithData:myData];
                            [dataArray addObject:bubbledata];
                        }else if ([key isEqualToString:@"audiodata"]){
                            NSError * err = nil;
                            NSString * time = [chatDic objectForKey:@"time"];
                            NSString * dataPath = [chatDic objectForKey:@"audiodata"];
                            NSData * audioData = [NSData dataWithContentsOfFile:dataPath options: 0 error:&err];
                            NSBubbleData *bubble = [NSBubbleData dataWithtimes:time date:date type:BubbleTypeMine withData:audioData];
                            if (myData)
                                bubble.avatar = [UIImage imageWithData:myData];
                            [dataArray addObject:bubble];
                        }

                    }
                   
                }else if(ismine == 1){
                    NSArray * keys = [chatDic allKeys];
                    for (NSString * key in keys) {
                        if ([key isEqualToString:@"messages"]) {
                            NSBubbleData * data = [[NSBubbleData alloc]initWithText:[chatDic objectForKey:@"messages"] date:date type:BubbleTypeSomeoneElse];
                            if(otherData)
                                data.avatar = [UIImage imageWithData:otherData];
                            [dataArray addObject:data];
                        }else if ([key isEqualToString:@"tidpath"]) {
//                            NSURL *url = [NSURL fileURLWithPath:[chatDic objectForKey:@"video"]];
//                            MPMoviePlayerController *player = [[MPMoviePlayerController alloc]initWithContentURL:url];
//                            player.shouldAutoplay = NO;
//                            UIImage *fileImage = [player thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
                            NSData * data =[NSData dataWithContentsOfFile:[chatDic objectForKey:@"tidpath"]];;
                            UIImage *fileImage = [UIImage imageWithData:data];
                            NSString * time = [chatDic objectForKey:@"duration"];
                            NSString * body = [chatDic JSONString];
                            NSBubbleData *bdata = [NSBubbleData dataWithImage:fileImage withTime:time  withType:@"video" date:date type:BubbleTypeSomeoneElse withVidePath:[chatDic objectForKey:@"tidpath"] withJsonBody:body];
                            if(otherData)
                                bdata.avatar = [UIImage imageWithData:otherData];
                            [dataArray addObject:bdata];
                        }if ([key isEqualToString:@"filepath"]) {
                          /*  NSURL *url = [NSURL fileURLWithPath:[chatDic objectForKey:@"filepath"]];
                            MPMoviePlayerController *player = [[MPMoviePlayerController alloc]initWithContentURL:url];
                            player.shouldAutoplay = NO;
                            UIImage *fileImage = [player thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
//                            NSData * data =[NSData dataWithContentsOfFile:[chatDic objectForKey:@"filepath"]];;
//                            UIImage *fileImage = [UIImage imageWithData:data];
                            NSString * time = [chatDic objectForKey:@"duration"];
                            NSString * body = [chatDic JSONString];
                            NSBubbleData *bdata = [NSBubbleData dataWithImage:fileImage withTime:time  withType:@"video" date:date type:BubbleTypeSomeoneElse withVidePath:[chatDic objectForKey:@"filepath"] withJsonBody:body];
                            if(otherData)
                                bdata.avatar = [UIImage imageWithData:otherData];
                            [dataArray addObject:bdata];*/
                        }else if ([key isEqualToString:@"photo"]) {
                            NSData * data =[NSData dataWithContentsOfFile:[chatDic objectForKey:@"photo"]];
                            NSString * time = [chatDic objectForKey:@"time"];
                            NSBubbleData * bubbledata;
                            if (!time)
                                bubbledata = [NSBubbleData dataWithImage:[UIImage imageWithData:data] date:date type:BubbleTypeSomeoneElse path:[chatDic objectForKey:@"photo"]];
                            else
                                bubbledata = [NSBubbleData dataWithImage:[UIImage imageWithData:data] withImageTime:time withPath:[chatDic objectForKey:@"photo"] date:date withType:BubbleTypeSomeoneElse];
                            /*NSBubbleData *bubbledata = [NSBubbleData dataWithImage:[UIImage imageWithData:data] date:date type:BubbleTypeSomeoneElse];*/
                            
                            if(otherData)
                                bubbledata.avatar = [UIImage imageWithData:otherData];
                            [dataArray addObject:bubbledata];

                        }else if ([key isEqualToString:@"audiodata"]) {
                            NSError * err = nil;
                            NSString * time = [chatDic objectForKey:@"time"];
                            NSString * dataPath = [chatDic objectForKey:@"audiodata"];
                            NSData * audioData = [NSData dataWithContentsOfFile:dataPath options: 0 error:&err];
                            NSBubbleData *bubble = [NSBubbleData dataWithtimes:time date:date type:BubbleTypeSomeoneElse withData:audioData];
                            if (otherData)
                                bubble.avatar = [UIImage imageWithData:otherData];
                            [dataArray addObject:bubble];
                            break;
                        }
                        
                
                    }
                }
            }
        }
            
    }
    sqlite3_finalize(statement);
    sqlite3_close(database);
    
    return dataArray;
}
-(void) updateDB:(NSDate*)date withContent:(NSString *)content{
    sqlite3 *database;
    if (sqlite3_open([[self dataFilePath] UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    NSString * time = [dateFormatter stringFromDate:date];
    NSString * update = [NSString stringWithFormat:@"UPDATE FILEID SET CONTENT='%@' WHERE TIME='%@'",content,time];
    
    char *errorMsg = NULL;
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(database, [update UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        
        sqlite3_bind_text(stmt, 1, [content UTF8String], -1, NULL);
        
    }
    if (sqlite3_step(stmt) != SQLITE_DONE)
        NSLog( @"Error updating table: %s", errorMsg);
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
}

-(void) deleteDB :(NSString *) _userID withOtherID:(NSString *)_friendID{
    sqlite3 *database;
    if (sqlite3_open([[self dataFilePath] UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
    }
    NSString * delete = [NSString stringWithFormat:@"DELETE FROM FILEID  WHERE USERID='%@' and FROMID='%@'",_userID,_friendID];
    sqlite3_stmt * statement;
    
    if (sqlite3_prepare_v2(database, [delete UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSLog(@"");
        }
    }

    sqlite3_step(statement);
    sqlite3_finalize(statement);
    sqlite3_close(database);
}

-(void) readInTalkDB:(NSString *)userID{
    NSArray * array = [[NSArray alloc]init];
    NSMutableSet * fromSet = [[NSMutableSet alloc]init];
    sqlite3 *database;
    
    if (sqlite3_open([[self dataFilePath] UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
    }
    
    NSString *sqlQuery =[NSString stringWithFormat:@"SELECT FROMID FROM FILEID WHERE USERID='%@'",userID];
    sqlite3_stmt * statement;
    if (sqlite3_prepare_v2(database, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *_fromId= (char*)sqlite3_column_text(statement,0);
            NSString *fId = [[NSString alloc]initWithUTF8String:_fromId];
            [fromSet addObject:fId];
        }
    }
//    sqlite3_step(statement);
//    sqlite3_finalize(statement);
//    sqlite3_close(database);
    array = [fromSet allObjects];
    [self readRecent:array];
   
}
-(void)readRecent:(NSArray *)array {
    ImageCache *imagecache= [ImageCache sharedObject];
    NSMutableArray * follower = [imagecache getTwittersFollower];
    NSMutableArray * following = [imagecache getTwittersFollowing];
    NSMutableSet * recentset = [[NSMutableSet alloc]init];
    
    for (int i = 0; i < [array count]; i++) {
        NSString * fromID = [array objectAtIndex:i];
        for (TwitterFollower * f in follower) {
            f.userid = [NSString stringWithFormat:@"%@",f.userid];
            if ([f.userid isEqualToString:fromID]) {
                RecentChat * recent = [[RecentChat alloc]init];
                recent.userid= f.userid;
                recent.name = f.name;
                recent.screenName = f.screenName;
                recent.profilePath = f.profilePath;
                recent.profileUrl = f.profileUrl;
                [recentset addObject:recent];
            }
        }
        for (TwitterFollowing * f in following) {
             f.userid = [NSString stringWithFormat:@"%@",f.userid];
            if ([f.userid isEqualToString:fromID]) {
                RecentChat * recent = [[RecentChat alloc]init];
                recent.userid= f.userid;
                recent.name = f.name;
                recent.screenName = f.screenName;
                recent.profilePath = f.profilePath;
                recent.profileUrl = f.profileUrl;
               [recentset addObject:recent];
            }
        }
    }
    NSArray * recentArray = [recentset allObjects];
    [imagecache addRecentChat:recentArray];
    
}
-(NSString*)getCacheDirectory
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:@"userName.text"];
}




@end
