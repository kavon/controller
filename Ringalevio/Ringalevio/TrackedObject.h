//
//  TrackedObject.h
//  Ringalevio
//
//  Created by Kavon Farvardin on 4/20/14.
//
//

#import <Foundation/Foundation.h>
#import <Mapbox/Mapbox.h>

@interface TrackedObject : NSObject

// 0 should be used for the sensor
-(id)initWithID: (int) ident;

// id will be initialized to -1, since that's invalid.
// be careful because that's 0xFF if casted to a byte.
-(id)initFixedLat: (double) lati andLong: (double) longi andAlt: (double) altidude;

-(int) getID;

-(void) setX:(uint32_t) xPos;

-(void) setY:(uint32_t) yPos;

-(void) setZ:(uint32_t) zPos;

-(uint32_t) getX;

-(uint32_t) getY;

-(uint32_t) getZ;

-(double) getLatitude;

-(double) getLongitude;

-(double) getAltitude;

// must call this to update this track's position if you modify its offsets.
-(void) updatePosition: (TrackedObject*) refPt;

-(void) refreshTimestamp;

-(NSDate*) getTimestamp;

-(void) setAnnotation: (RMAnnotation*) anno;

-(RMAnnotation*) getAnnotation;

// for consistency guarentees in updatePosition, don't touch.

-(void) lock;

-(void) unlock;

@end
