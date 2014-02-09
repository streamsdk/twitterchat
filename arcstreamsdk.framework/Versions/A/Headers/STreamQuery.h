//
//  StreamQuery.h
//  streamsdk
//
//  Copyright (c) 2012 Stream SDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QueryObject.h"
#import "QueryObjectList.h"

/*!
 StreamQuery can be used to find stream objects from a category based on the query constraints.
 */

@interface STreamQuery : NSObject{
    NSMutableString *category;
    NSString *errorMessage;
    QueryObjectList *list;
}

@property(copy) NSMutableString *category;
@property(copy) NSString *errorMessage;
@property(copy) QueryObjectList *list;

/*!
 Initialize the stream query object with a unique category name
 @param categoryName category name
 */
- (id) initWithCategory:(NSString *)categoryName;

/*!
 Set query constraints to OR
 @param queryLogic Query constraints are AND by defaut. Update this to OR by passing false parameter.
 */
- (void)setQueryLogicAnd: (BOOL)queryLogic;

/*!
 Add a constraint to the query that requires a particular key's value and the value to be equal to the provided value
 @param key the key to check.
 @param value the value to check.
 */
- (void)whereEqualsTo: (NSString *)key forValue:(NSString *)value;

- (void)whereKeyExists: (NSString *)key;

- (void)whereMatches: (NSString *)key forValue:(NSString *)value;

- (NSMutableArray *)listSortedStreamObjectsBasedOnKeySize:(int)limited;

- (NSMutableArray *)listSortedStreamObjectsKeyFre:(int)limited;

/*!
 Add a constraint to the query that requires a particular key's value and the values that are included in the provided values array
 @param key the key to check.
 @param values the values that are included
 */
- (void)containedIn: (NSString *)key forValues:(NSMutableArray *)valueArray;

/*!
 Add a constraint to the query that requires a particular key's value and the value is greater than the provided value
 @param key the key to check
 @param value the value to check
 */
- (void)whereGreaterThan: (NSString *)key greaterThanValue:(NSNumber *)valueNum;

/*!
 Add a constraint to the query that requires a particular key's value and the value is less than the provided value
 @param key the key to check
 @param value the value to check
 */
- (void)whereLessThan: (NSString *)key lessThanValue:(NSNumber *)valueNum;

/*!
 Add a constraint to the query that requires a particular key's value and the value is near to the geo point
 @param key the key to check
 @param geoPoint the STreamGeoPoint object
 @param the result is sorted based on the distance. Developers can set a limit for the results
 
*/
- (void)whereNear: (NSString *)key geo:(STreamGeoPoint *)geoPoint limit:(int)l;

/*!
 Add a constraint to the query that requires a particular key's value and the date value is before the provided date
 @param key the key to check
 @param value the value to check
 */
- (void)beforeDate: (NSString *)key before: (NSDate *)date;

/*!
 Add a constraint to the query that requires a particular key's value and the date value is after the provided date
 @param key the key to check
 @param value the value to check
 */
- (void)afterDate: (NSString *)key after: (NSDate *)date;

/*!
 Reset all previous queries.
 */
- (void)resetQuery;

/*!
 Finds objects asynchronously and calls the given block with the results.
 @param block The block should have the following argument signature:(NSMutableArray objects). the objects include a list of StreamObject
 */
- (void)find: (void (^)(NSMutableArray *))doStaff;

/*!
 Finds objects synchronously based on the query constraint
*/
- (NSMutableArray *)find;

/*!
 Add object ids to the query that find the objects with the limited ids
 @param objectId the id that the object's id is equal to
 */
- (void)addLimitId: (NSString *)objectId;



@end
