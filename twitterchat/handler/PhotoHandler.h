//
//  PhotoHandler.h
//  talk
//
//  Created by wangshuai on 13-12-22.
//  Copyright (c) 2013年 wangshuai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MediaHandler.h"
@protocol reloadTableDeleage <NSObject>

-(void)reloadTable;

@end
@interface PhotoHandler : MediaHandler

@property (nonatomic,retain) NSString  *type;

@property (nonatomic,retain) NSString  *photopath;

@property (assign)id<reloadTableDeleage>delegate;

@property(nonatomic, strong)UIViewController *controller;

- (void)receiveFile:(NSData *)data withPath:(NSString *)path forBubbleDataArray:(NSMutableArray *)bubbleData withTime:(NSString *)time forBubbleOtherData:(NSData *) otherData withSendId:(NSString *)sendID withFromId:(NSString *)fromID ;

-(void) sendPhoto :(NSData *)data forBubbleDataArray:(NSMutableArray *)bubbleData forBubbleMyData:(NSData *) myData withSendId:(NSString *)sendID withTime:(NSString *)time;

@end
