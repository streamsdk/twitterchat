//
//  StreamSession.h
//  streamsdk
//
//  Copyright (c) 2012 Stream SDK. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 StreamSession is used by developer to authenticate with stream sdk service
 */

@interface STreamSession : NSObject{
}

+ (void) setUpUrl: (NSString *)clientK;

+(NSString *) getClientAuthKey;

+(void) setUserName: (NSString *)name;

+(void) setUpServerUrl: (NSString *)serverUrl;

+(NSString *) getUserName;

/*!
 Developer needs to use this functuin to authenticate with stream sdk
 @param applicationId application id
 @param secretKey secret key
 @param clientKey client key
 @param block The block should have the following argument signature:(BOOL succeed, NSString *response)
 
 */
+(void) authenticate: (NSString *)applicationId secretKey:(NSString *)secretKey clientKey: (NSString *)clientKey response:(void(^)(BOOL succeed, NSString *response))doStaff;

+ (NSString *) authenticate:(NSString *)appId secretKey:(NSString *)secretKey clientKey:(NSString *)clientKey;

+ (NSMutableString *)getListKeyFreUrl;

+(NSMutableString *) getStoreObjectUrl;

+(NSMutableString *) getObjectUrl: (NSString *)objectId;

+(NSMutableString *) getUserSignUpUrl;

+(NSMutableString *) getUserLoginUrl;

+(NSMutableString *) getStoreCategoryObjectUrl;

+(NSMutableString *) getObjectCategoryUrl: (NSString *)categoryName;

+(NSMutableString *) getStoreFileUrl;

+(NSMutableString *) getPostMetaDataUrl: (NSString *)fileId;

+(NSMutableString *) getFileObjectDownloadUrl: (NSString *)fileId;

+(NSMutableString *) getIncUrl: (NSString *)objectId;

+(NSMutableString *) getUpdateStreamCaUrl;

+(NSMutableString *) getDeleteSteamCategoryObject;

+(NSMutableString *) getFileMetadataUrl: (NSString *)fileId;

+(NSMutableString *) getObjectUpdateUrl: (NSString *)objectId;

+(NSMutableString *) getObjectDeleteUrl: (NSString *)objectId;

+(NSMutableString *) getDeleteSteamCategoryObjectUrl: (NSString *)category;

+(NSMutableString *) getQueryUrl;

+(NSMutableString *) getRemoveStreamObjectKeyUrl;

+(NSMutableString *) getStoreTokenUrl;

+(NSMutableString *) getChannelSubscribeUrl;

+(NSMutableString *) getChannelUnsubscribeUrl;

+(NSMutableString *) getPushSendUrl;

+(NSMutableString *) getPushSendToChannelUrl;

+(NSMutableString *) getDeleteStreamObjectKeyUrl:(NSString *)objectId;

+(NSMutableString *) getUserExistsUrl;

+(NSMutableString *) loadUserMetadataUrl:(NSString *)userName;

+(NSMutableString *) listSortedObjectUrl;

+(NSMutableString *) getUpdateUserMetadataUrl;

@end
