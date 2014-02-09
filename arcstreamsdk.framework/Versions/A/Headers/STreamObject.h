//
//  StreamObject.h
//  streamsdk
//
//  Copyright (c) 2012 Stream SDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STreamAccessControl.h"

/*!
 StreamObject represents a single object that can be saved and retrieved from Stream Cloud.
 A streamObject is uniquely identified by its id. On creation of a streamObject, an id is automatically assigned to an unique value.
 The id can also be assigned by using setObjectId. It is not allowed to create a streamObject with the same ID.
 */

@interface STreamObject : NSObject{
    NSMutableDictionary *data;
    NSString *objectId;
    NSString *category;
    NSNumber *lastModified;
    STreamAccessControl *accessControl;
    BOOL userObject;
    NSMutableString *errorMessage;
}

@property(retain) NSMutableDictionary *data;
@property(retain) NSString *objectId;
@property(retain) NSString *category;
@property(retain) STreamAccessControl *accessControl;
@property(retain) NSNumber *lastModified;
@property(retain) NSMutableString *errorMessage;
@property BOOL userObject;

/*!
 Add objects for creating/updating a stream object.
 @param key   the object's key.
 @param value the supported value type includes NSString, NSNumber, NSMutableDictionary, NSMutableArray and StreamFile.
 */
- (void)addStaff:(NSString *)key withObject:(id)value;

/*!
 Get object value based on the key. It is assumed the stream object is loaded.
 */
- (id)getValue:(NSString *)key;

/*!
 Saves a collection of objects all at once asynchronously and calls the block when done.
 @param doStaff The block to execute. The block should have the following argument signature: (BOOL succeed, NSString *response). If succeed is true, response is the object ID. Otherwise response is the error message.
 */
- (void)createNewObject: (void(^)(BOOL succeed, NSString *objectId))doStaff;

/*!
 Update current loaded stream object asynchronously.
 */
- (void)updateInBackground;

/*!
 Update current loaded stream object synchronously.
 */
- (NSString *)update;

/*!
 Delete stream object in background. The object is permanently removed from storage.
 */
- (void)deleteObjectInBackground;

/*!
 Increment value from an object's key field. The type of the value must be NSNumber.
 @param key The object's key.
 @param count The amount to be added for the value.
 @param response The block to execute.  The block should have the following argument signature: (NSNumber *). The response is a NSNumber represents the current value.
 */
- (void)incrementWithCallback : (NSString *)key withCounts:(int)count response: (void (^)(NSNumber *))doStaff;

/*!
 Increment value from an object's key field asynchronously without block. The type of the value must be NSNumber.
 @param key The object's key.
 @param count The amount to be added for the value.
 */
- (void)incrementInbackground: (NSString *)key withCounts:(int)count;

/*!
 Populate all values of the stream object based on the object ID asynchronously.
 @param oId The object's ID.
 @param response The block to execute. The response is a NSString that represents the status of this call.
 */
- (void)getObject: (NSString *)oId response: (void (^)(NSString *))doStaff;

/*!
 Populate all values of the stream object based on the object ID synchronously.
 @param oId The object's ID.
*/
- (void)loadAll: (NSString *)oId;

/*!
  Get an array of keys from the object.
 */
- (NSArray *)getAllKeys;

- (void)convertJsonToMap: (NSArray *)jsonData;

- (NSString *)convertToJsonString: (NSString *)catgoryObjectId;

/*!
  Get total object's size
*/
- (int)size;

/*!
 Remove object's key fields in background permanently from storage. Similar to update call, the object needs to be loaded (getObject) before calling this method.
 @param key The object's key field.
 @param objectId The object's ID.
 */
- (void) removeKey: (NSString *)key forObjectId:(NSString *)objectId;

- (void) removeKeyInBackground: (NSString *)key forObjectId:(NSString *)streamObjectId;

- (void)resetErrorMessage;


@end
