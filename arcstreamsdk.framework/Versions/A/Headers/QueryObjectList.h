#import "QueryObject.h"

@interface QueryObjectList : NSObject{
    NSMutableArray *queryList;
    NSMutableArray *limitIds;
    BOOL logicAnd;
}

@property(copy) NSMutableArray *queryList;
@property BOOL logicAnd;

- (void) addQueryObject: (NSString *)key withObject: (QueryObject *)queryObject;

- (void) addLimitedIds: (NSString *)objectId;

- (NSMutableString *)convertToJson;

- (BOOL)queryAll;

@end