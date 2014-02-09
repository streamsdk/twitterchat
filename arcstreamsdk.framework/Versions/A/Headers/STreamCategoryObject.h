//
//  StreamCategoryObject.h
//  streamsdk
//
//  Copyright (c) 2012 Stream SDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STreamObject.h"

/*!
 StreamCategoryObject contains a list of StreamObjects that have the same category. The category name must be unique.
 StreamCategoryObject provides create, update, load and delete stream objects operation. All these data operation are done asynchronously through block functions.
 Each StreamObject added in the StreamCategoryObject can be assigned a different permission control. All data associated with a StreamCategoryObject can be queried  by StreamQuery.
 */

@interface STreamCategoryObject : NSObject{
    NSString *objectId;
    STreamAccessControl *accessControl;
    NSMutableString *errorMessage;
    BOOL userObject;
}
@property(retain) NSString *objectId;
@property(retain) __block NSMutableArray *streamObjects;
@property(retain) NSMutableString *categoryName;
@property(retain) STreamAccessControl *accessControl;
@property(retain) NSMutableString *errorMessage;
@property BOOL userObject;

/*!
 Saves the list of StreamObjects under the category.
 @param doStaff The block to execute. The block should have the following argument signature: (BOOL succeed, NSString *response). If succeed is true, response is the category. Otherwise response is the error message.
 */
-(void)createNewCategoryObject: (void(^)(BOOL succeed, NSString *objectId))doStaff;

/*!
 Loads stream objects under the category into the objects list  asynchronously. You should initialise the category object by initWithCategory before loading the objects list.
 @param doStaff The block to execute. If succeed is false, error message includes the reason for the failure.
 */
-(void) load: (void(^)(BOOL succeed, NSString *error))doStaff;

/*!
 Loads stream objects under the category into the objects list synchronously. You should initialise the category object by initWithCategory before loading the objects list.
 
*/
-(NSMutableArray *) load;

/*!
 Adds a new stream object into memory list for creating a new category object.
 @param streamObject the object added into the category.
 */
-(void) addStreamObject: (STreamObject *)streamObject;

/*!
 Initiate a Stream Categoey Object with category as the paramter.
*/
-(id) initWithCategory:(NSString *)category;

-(NSString *) convertToGroupJsonString;

-(NSString *) convertStreamObjectsToJson: (NSMutableArray *)objects;


/*!
 Update a list of stream objects. The call returns immediately. The update call is done asynchronously.
 @param objects The list of stream objects are needed to update.
 */
-(void) updateStreamCategoryObjects: (NSMutableArray *)objects afterUpdate: (void(^)(BOOL succeed, NSString *objectId))doStaff;

/*!
 Update a list of stream objects. The update call is done asynchronously.
*/
-(void) updateStreamCategoryObjectsInBackground: (NSMutableArray *)objects;

/*!
 Update a list of stream objects. The update call is done synchronously.
 */
-(NSString *) updateStreamCategoryObjects: (NSMutableArray *)objects;

/*!
 Delete a list of stream objects. The call returns immediately. The delete call is done asynchronously.
 @param objects The list of stream objects are needed to delete.
 */
-(void) deleteStreamCategoryObjects: (NSMutableArray *)objects;

-(NSString *) convertListToJson: (NSMutableArray *)ids;

/*!
 Delete the category includes its stream objects permanently from storage.
 */
-(void) deleteCategoryInBackground;

- (void)resetErrorMessage;

@end
