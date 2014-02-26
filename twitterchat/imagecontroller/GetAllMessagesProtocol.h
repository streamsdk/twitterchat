//
//  GetAllMessagesProtocol.h
//  talk
//
//  Created by wangsh on 13-12-26.
//  Copyright (c) 2013年 wangshuai. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GetAllMessagesProtocol <NSObject>

-(void) getMessages:(NSString *)messages withFromID:(NSString *)fromID ;

-(void) getFiles:(NSData *)data withFromID:(NSString *)fromID withBody:(NSString *)body withPath:(NSString *)path;

@end
