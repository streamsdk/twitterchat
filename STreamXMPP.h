//
//  STreamXMPP.h
//  xstreamsdk
//
//  Created by wang shuai on 06/07/2013.
//  Copyright (c) 2013 streamsdk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import "STreamXMPPProtocol.h"
#import "XMPPRoster.h"
#import <arcstreamsdk/STreamObject.h>


@interface STreamXMPP : NSObject  <XMPPRosterDelegate>{
    
    XMPPStream *xmppStream;
}
+ (STreamXMPP *)sharedObject;

@property (nonatomic, readonly) XMPPStream *xmppStream;
@property (nonatomic, strong) id<STreamXMPPProtocol> xmppDelegate;



-(BOOL)connect: (NSString *)userName withPassword:(NSString *)password;
-(void)disconnect;
-(BOOL)connected;

-(void)sendMessage:(NSString *)toUser withMessage:(NSString *)message;

-(void)sendFileMessage:(NSString *)toUser withFileId:(NSString *)fileId withMessage:(NSString *)message;

-(void)sendFileInBackground:(NSData *)data toUser:(NSString *)userName finished:(FinishCall)doStaff byteSent:(DelegateCall)call withBodyData:(NSMutableDictionary *)bodyData;

@end
