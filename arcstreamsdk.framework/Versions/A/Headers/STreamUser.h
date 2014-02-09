//
//  StreamUser.h
//  streamsdk
//
//  Copyright (c) 2012 Stream SDK. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 StreamUser represents a single user in the application. StreamUser is initially created by using signUp method.
 A StreamUser also includes metadata of the user. For example, age, address, phone number, relationship status etc.
 The StreamUser with its metadata are populated by using its signUp method.
 */

@interface STreamUser : NSObject


@property(retain) NSMutableDictionary *userMetadata;
@property long long creationTime;
@property long long loginTime;


- (BOOL)searchUser: (NSString *)userId;

/*!
 A map of user's metadata with signUp details are saved on stream server. The method returns immediately once it is called
 @param userName The userName used for logging in. It should be unique.
 @param password The password used for logging in. It is sent as hashed format.
 @param metaData The user's metadata saved in NSMutableDictionary.
 @param response The block to execute when signUp operation is done.
 */
- (void) signUp: (NSString *)userName withPassword:(NSString *)password withMetadata:(NSMutableDictionary *)metaData response:(void (^)(BOOL succeed, NSString *resposne))doStaff;

- (void) loadUserMetadata: (NSString *)userName response:(void (^)(BOOL succeed, NSString *resposne))doStaff;

- (void) signUp: (NSString *)userName withPassword:(NSString *)password withMetadata:(NSMutableDictionary *)metaData;

- (void) logIn: (NSString *)userName withPassword:(NSString *)password;

- (void)updateUserMetadata:(NSString *)userName withMetadata:(NSMutableDictionary *)metaData;


/*!
 Check if the user exists in the application. The method returns immediately once it is called.
 @param userId userName to check.
 @param response The block to execute when checking in completed. First parameter returns TRUE if the user exists.
*/
- (void)isUserExists: (NSString *)userId response:(void (^)(BOOL exists, NSString *resposne))doStaff;

/*!
 Username and password are required for authenticating the current user for logging in.
 @param userName userName of the user
 @param password password of the user
 @param response The block to execute when the login operation is done.
 */
- (void) logIn: (NSString *)userName withPassword:(NSString *)password  response:(void (^)(BOOL succeed, NSString *response))doStaff;

@property(retain) NSMutableString *errorMessage;

@end
