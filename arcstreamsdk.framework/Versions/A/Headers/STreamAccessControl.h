
#import <Foundation/Foundation.h>

/*!
 StreamAccessControl includes read access list and write access list. Each list contains a list of strings. The actual values of the string are determined by the application. For example, the list may include user names so that the read and write permissions for an object can be defined by if a specific user is allowed to read or write on an object. The objects can be assigned by StreamAccessControl include StreamObject, StreamCategoryObject and StreamFile. StreamAccessControl values are populated after the object associated with it is loaded In the example below, we create a new stream access control that include a read list and write list. The two list contain the user names that are allowed to read or modify the current object. Recall from last section, the object by default is created as non user object. So all users from the application are allowed to view and modify the object. By assigning the access control list, we can restrict the users to read or modify the object.
 
*/ 

@interface STreamAccessControl : NSObject{
    NSMutableArray *readAccess;
    NSMutableArray *writeAccess;
    BOOL publicAcess;
}

/*!
 Set read access list.
*/
@property(retain) NSMutableArray *readAccess;

/*!
 Set write access list.
*/
@property(retain) NSMutableArray *writeAccess;

/*!
 Set public access to TRUE/FALSE 
*/
@property(assign) BOOL publicAccess;


@end