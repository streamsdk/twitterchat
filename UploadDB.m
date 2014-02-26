//
//  UploadDB.m
//  talk
//
//  Created by wangsh on 14-2-14.
//  Copyright (c) 2014年 wangshuai. All rights reserved.
//

#import "UploadDB.h"

@implementation UploadDB

-(NSString *) dataFilePath {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"upload.sqlite"];
    
}
-(void)initDB {
    sqlite3 * database ;
    if (sqlite3_open([[self dataFilePath] UTF8String], &database) != SQLITE_OK) {
        
        sqlite3_close(database);
        NSLog(@"Failed to open database");
    }
    
    NSString *createSQL = @"CREATE TABLE IF NOT EXISTS UPLOAD (ROW INTEGER PRIMARY KEY AUTOINCREMENT, USERID TEXT, FILEPATH TEXT, TIME TEXT, FROMID TEXT, TYPE TEXT);";
    char *errorMsg;
    if (sqlite3_exec (database, [createSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
        sqlite3_close(database);
        NSLog(@"Error creating table: %s", errorMsg);
    }
    
}
-(void) insertUploadDB:(NSString *)userId filePath:(NSString *)filepath withTime:(NSString *)time withFrom:(NSString *)fromID withType:(NSString *)type{
    sqlite3 *database;
    if (sqlite3_open([[self dataFilePath] UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSLog(@"Failed to open database");
    }
    
    char *update = "INSERT INTO UPLOAD (USERID, FILEPATH, TIME, FROMID, TYPE) VALUES (?, ?, ?, ?, ?);";
    
    char *errorMsg = NULL;
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(database, update, -1, &stmt, nil) == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, [userId UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 2, [filepath UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 3, [time UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 4, [fromID UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 5, [type UTF8String], -1, NULL);
    }
    if (sqlite3_step(stmt) != SQLITE_DONE)
        NSLog( @"Error updating table: %s", errorMsg);
    sqlite3_finalize(stmt);
    sqlite3_close(database);

}

-(NSMutableArray *) readUploadDB{
    NSMutableArray *uploadArray = [[NSMutableArray alloc]init];
    sqlite3 *database;
    
    if (sqlite3_open([[self dataFilePath] UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
    }
    
    NSString *sqlQuery = @"SELECT FILEPATH, TIME, FROMID, TYPE FROM UPLOAD";
    sqlite3_stmt * statement;
    if (sqlite3_prepare_v2(database, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *_filePath = (char*)sqlite3_column_text(statement,0);
            char *_time= (char*)sqlite3_column_text(statement,1);
            char *_fromId= (char*)sqlite3_column_text(statement,2);
            char *_type= (char*)sqlite3_column_text(statement,3);
            NSString * filePath= [[NSString alloc]initWithUTF8String:_filePath];
            NSString * time;
            if (_time) {
                time = [[NSString alloc]initWithUTF8String:_time];
            }else{
                time = @"nil";
            }
           
            NSString *fromId = [[NSString alloc]initWithUTF8String:_fromId];
            NSString *type = [[NSString alloc]initWithUTF8String:_type];
            
            NSMutableArray *singleArray = [[NSMutableArray alloc]initWithObjects:filePath,time,fromId,type, nil];
            
            [uploadArray addObject:singleArray];
        }
    }
    
    return uploadArray;

}
-(void) deleteUploadDBFromFilepath:(NSString *) filePath{
    sqlite3 *database;
    if (sqlite3_open([[self dataFilePath] UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
    }
    //    select distinct * from ADDFRIENDS
    NSString * sql = [NSString stringWithFormat:@"DELETE FROM UPLOAD WHERE FILEPATH='%@'",filePath];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
        
        NSLog(@"delete");
    }
    sqlite3_step(statement);
    sqlite3_finalize(statement);
    sqlite3_close(database);

}
@end
