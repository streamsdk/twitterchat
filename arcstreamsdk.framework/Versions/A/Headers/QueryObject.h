//
//  QueryObject.h
//  streamsdkarc
//
//  Copyright (c) 2013 wang shuai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STreamGeoPoint.h"

@interface QueryObject : NSObject{
    
    NSString *value;
    NSString *key;
    NSString *queryOperator;
    NSMutableArray *valueArray;
    NSNumber *numberValue;
    NSDate *dateValue;
    STreamGeoPoint *geoPoint;
    
}

@property(retain) NSString *value;
@property(retain) NSString *key;
@property(retain) NSString *queryOperator;
@property(retain) NSNumber *numberValue;
@property(retain) NSMutableArray *valueArray;
@property(retain) NSDate *dateValue;
@property(assign) int limit;
@property(retain) STreamGeoPoint *geoPoint;


@end
