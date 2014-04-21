//
//  TrackedObject.h
//  Ringalevio
//
//  Created by Kavon Farvardin on 4/20/14.
//
//

#import <Foundation/Foundation.h>

@interface TrackedObject : NSObject

// 0 should be used for the sensor
-(id)initWithID: (int) ident;

// id will be initialized to -1, since that's invalid.
// be careful because that's 0xFF if casted to a byte.
-(id)initFixedLat: (double) latitude andLong: (double) longi;

-(int) getID;

-(void) setX:(uint32_t) x;

-(void) setY:(uint32_t) y;

-(void) setZ:(uint32_t) z;

-(double) getLatitude;

-(double) getLongitude;

// must call this to update this track's position if you modify its offsets.
-(void) updatePosition: (TrackedObject*) usingReferencePoint;

@end
