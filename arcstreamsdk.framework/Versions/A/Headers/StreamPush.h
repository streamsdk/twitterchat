//
//  StreamPush.h
//  StreamObjectsSDK
//
//  Copyright (c) 2012 Stream SDK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STreamQuery.h"

/*!
 Stream SDK needs to know your token in order to send push notification to channels or individual application.
 The token is stored on Stream Server. You also should get a valid certificate from Apple and the certificate needs to be uploaded to stream server from admin cosole.
 */

@interface STreamPush : NSObject{
    
}

/*!
 The token should be stored on stream server side.  The call returns immediately. The call is done asynchronously.
 @param t The token used to send notification.
 */

+ (void) storeToken: (NSString *)t;

/*!
 The channel for the application to register. The application will receive nortification targerted under the registerred channel.
 The call returns immediately. The call is done asynchronously. If the channel does not exist, a new channel will be created.
 @param channel The channel name to subscribe.
 */

+ (void) subscribeChannel: (NSString *)channel;

/*!
 The channel for the application to unregister. The application will not receive nortification targerted under the registerred channel.
 The call returns immediately. The call is done asynchronously.
 @param channel The channel name to unsubscribe.
 */

+ (void) unsubscribeChannel: (NSString *)channel;

/*!
 Send push notification to devices registered under the channel
 @param message The message to sent
 @param toChannel channel name
 @param sound sound file name (optional).
 @param password certificate password.
 */
+ (void) sendMessages: (NSString *)message toChannel: (NSString *)channel withSoundFile: (NSString *)soundFile password: (NSString *)password;

/*!
 Send push notification to device registered with the token
 @param token The device's token
 @param message The message to sent
 @param sound sound file name (optional).
 @param password certificate password.
 */
+ (void) sendMessage: (NSString *)token withmessage: (NSString *)message withSoundFile: (NSString *)soundFile password: (NSString *)password;

/*!
 Send push notification to devices returned from the query.
 @param StreamQuery stream query
 @param message The message to sent
 @param sound sound file name (optional).
 @param password certificate password.
 */
+ (void) sendMessage: (STreamQuery *)query message: (NSString *)message withSoundFile: (NSString *)soundFile password: (NSString *)password;

/*!
 Get token used for push notification.
*/
+ (NSString *) getToken;

/*!
 Get an array of subscribed channels.
*/
+ (NSMutableArray *)getSubscribedChannels;

@end
