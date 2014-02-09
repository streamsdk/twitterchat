//
//  STreamXMPPProtocol.h
//  xstreamsdk
//
//  Created by wang shuai on 06/07/2013.
//  Copyright (c) 2013 streamsdk. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSXMLElement+XMPP.h"
#import "XMPPMessage.h"
#import "XMPPPresence.h"

@protocol STreamXMPPProtocol <NSObject>

typedef void (^DelegateCall)(float);
typedef void (^FinishCall)(NSString *);

- (void)didAuthenticate;

- (void)didNotAuthenticate:(NSXMLElement *)error;

- (void)didReceiveMessage:(NSString *)message withFrom:(NSString *)fromID;

- (void)didReceivePresence:(XMPPPresence *)presence;

- (void)didReceiveFile:(NSString *)fileId withBody:(NSString *)body withFrom:(NSString *)fromID;

@end
