//
//  StreamHttpRequest.h
//  streamsdk
//
//  Copyright (c) 2012 Stream SDK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STreamHttpRequest : NSObject

- (NSData *) sendRequest: (NSString *)method bodyData:(NSString *)data withUrl:(NSString *)url;

- (NSData *) sendRequestData: (NSString *)method withBodyData:(NSData *)data withUrl:(NSString *)url;

- (void) sendRquestWithBlock: (NSString *)method bodyData:(NSString *)data withUrl:(NSString *)url withBlock:(void(^)(NSData *))doStaff;


@end
