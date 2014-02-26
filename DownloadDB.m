//
//  DownloadDB.m
//  talk
//
//  Created by wangsh on 14-2-14.
//  Copyright (c) 2014年 wangshuai. All rights reserved.
//

#import "DownloadDB.h"

@implementation DownloadDB

-(NSString *) dataFilePath {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"download.sqlite"];
    
}
-(void)initDB {
    sqlite3 * database ;
    if (sqlite3_open([[self dataFilePath] UTF8String], &database) != SQLITE_OK) {
        
        sqlite3_close(database);
        NSLog(@"Failed to open database");
    }
    
    NSString *createSQL = @"CREATE TABLE IF NOT EXISTS DOWNLOAD (ROW INTEGER PRIMARY KEY AUTOINCREMENT, USERID TEXT, FILEID TEXT, BODY TEXT, FROMID TEXT);";
    char *errorMsg;
    if (sqlite3_exec (database, [createSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
        sqlite3_close(database);
        NSLog(@"Error creating table: %s", errorMsg);
    }
    
}
-(void) insertDownloadDB:(NSString *)userId fileID:(NSString *)fileId withBody:(NSString *)body withFrom:(NSString *)fromID{
    sqlite3 *database;
    if (sqlite3_open([[self dataFilePath] UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSLog(@"Failed to open database");
    }
    
    char *update = "INSERT INTO DOWNLOAD (USERID, FILEID, BODY, FROMID) VALUES (?, ?, ?, ?);";
    
    char *errorMsg = NULL;
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(database, update, -1, &stmt, nil) == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, [userId UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 2, [fileId UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 3, [body UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 4, [fromID UTF8String], -1, NULL);
    }
    if (sqlite3_step(stmt) != SQLITE_DONE)
        NSLog( @"Error updating table: %s", errorMsg);
    sqlite3_finalize(stmt);
    sqlite3_close(database);

}
-(NSMutableArray *) readDownloadDB{
    NSMutableArray *downloadArray = [[NSMutableArray alloc]init];
    sqlite3 *database;
    
    if (sqlite3_open([[self dataFilePath] UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
    }
    
    NSString *sqlQuery = @"SELECT FILEID, BODY, FROMID FROM DOWNLOAD";
    sqlite3_stmt * statement;
    if (sqlite3_prepare_v2(database, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *_fileId = (char*)sqlite3_column_text(statement,0);
            char *_body= (char*)sqlite3_column_text(statement,1);
            char *_fromId= (char*)sqlite3_column_text(statement,2);
            NSString * fileId = [[NSString alloc]initWithUTF8String:_fileId];
            NSString * jsonBody = [[NSString alloc]initWithUTF8String:_body];
            NSString *fromId = [[NSString alloc]initWithUTF8String:_fromId];
            
            NSMutableArray *singleArray = [[NSMutableArray alloc]initWithObjects:fileId,jsonBody,fromId, nil];

            [downloadArray addObject:singleArray];
        }
    }

    return downloadArray;
}
-(NSString *)readDownloadDBFromFileID:(NSString *) fileID{
    NSString * fromId;
    sqlite3 *database;
    
    if (sqlite3_open([[self dataFilePath] UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
    }
    
    NSString *sqlQuery =[NSString stringWithFormat:@"SELECT FROMID FROM DOWNLOAD WHERE FILEID='%@'",fileID];
    sqlite3_stmt * statement;
    if (sqlite3_prepare_v2(database, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *_fromId= (char*)sqlite3_column_text(statement,0);
            NSString *fId = [[NSString alloc]initWithUTF8String:_fromId];
            fromId =fId;
        }
    }
    return fromId;
}
-(void) deleteDownloadDBFromFileID:(NSString *) fileID{
    sqlite3 *database;
    if (sqlite3_open([[self dataFilePath] UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
    }
    //    select distinct * from ADDFRIENDS
    NSString * sql = [NSString stringWithFormat:@"DELETE FROM DOWNLOAD WHERE FILEID='%@'",fileID];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
        
        NSLog(@"delete");
    }
    sqlite3_step(statement);
    sqlite3_finalize(statement);
    sqlite3_close(database);
}
@end
