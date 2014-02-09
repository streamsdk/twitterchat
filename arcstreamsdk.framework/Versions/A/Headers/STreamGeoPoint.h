//
//  STreamGeoPoint.h
//  arcstreamsdk
//
//  Copyright (c) 2013 wang shuai. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 STreamGeoPoint represents a latitude / longitude point. It is associated with a key in STreamObject. In your application, you could define multiple STreamGeoPoint. These points will be assoicated with multiple StreamObject. One use case is that you might add these STreamObject into STreamCategoryObject so that you could find the neareast points related to one geo points by running a STreamQuery
*/

@interface STreamGeoPoint : NSObject{
    float latitude;
    float longitude;
}
/*!
 Set latitude for the object.
*/
@property(assign) float latitude;

/*!
 Set longitude for the object.
 */
@property(assign) float longitude;

@end
