//
//  TrackedObject.m
//  Ringalevio
//
//  Created by Kavon Farvardin on 4/20/14.
//
//

#import "TrackedObject.h"

@implementation TrackedObject
{
    // this is needed in case one thread updates this track while another tries to read it
    NSRecursiveLock *mutex;
    int32_t x;
    int32_t y;
    int32_t z;
    double latitude;
    double longitude;
    double altitude;
    int ident;
    NSDate *lastUpdate;
    RMAnnotation *annotation;
}

-(void) doBasicInit {
    mutex = [[NSRecursiveLock alloc] init];
    x = 0;
    y = 0;
    z = 0;
    latitude = 0.0;
    longitude = 0.0;
    altitude = 0.0;
    ident = 0;
    annotation = nil;
}

// negative values should be used for the sensor/track src
-(id)initWithID: (int) idental {
    
    if( self = [super init] ) {
        [self doBasicInit];
        
        ident = idental;
    }
    
    return self;
}

// use this for the fixed reference point.
// do not use the id
-(id)initFixedLat: (double) lati andLong: (double) longi andAlt: (double) altidude {
    
    if( self = [super init] ) {
        [self doBasicInit];
        
        latitude = lati;
        longitude = longi;
        
    }
    
    return self;
}

-(int) getID {
    return ident;
}

-(void) setX:(int32_t) xPos {
    [mutex lock];
    x = xPos;
    [mutex unlock];
}

-(void) setY:(int32_t) yPos {
    [mutex lock];
    y = yPos;
    [mutex unlock];
}

-(void) setZ:(int32_t) zPos {
    [mutex lock];
    z = zPos;
    [mutex unlock];
}

-(int32_t) getX {
    [mutex lock];
    uint32_t copy = x;
    [mutex unlock];
    return copy;
}

-(int32_t) getY {
    [mutex lock];
    uint32_t copy = y;
    [mutex unlock];
    return copy;
}

-(int32_t) getZ {
    [mutex lock];
    uint32_t copy = z;
    [mutex unlock];
    return copy;
}

-(double) getLatitude {
    [mutex lock];
    double copy = latitude;
    [mutex unlock];
    return copy;
}

-(double) getLongitude {
    [mutex lock];
    double copy = longitude;
    [mutex unlock];
    return copy;
}

-(double) getAltitude {
    [mutex lock];
    double copy = altitude;
    [mutex unlock];
    return copy;
}

-(void) lock {
    [mutex lock];
}

-(void) unlock {
    [mutex unlock];
}

-(void) refreshTimestamp {
    [mutex lock];
    lastUpdate = [NSDate date];
    [mutex unlock];
}

-(NSDate*) getTimestamp {
    [mutex lock];
    NSDate *copy = lastUpdate;
    [mutex unlock];
    return copy;
}

-(void) setAnnotation: (RMAnnotation*) anno {
    [mutex lock];
    annotation = anno;
    [mutex unlock];
}

-(RMAnnotation*) getAnnotation {
    [mutex lock];
    RMAnnotation *copy = annotation;
    [mutex unlock];
    return copy;
}

// must call this to update this track's position if you modify its offsets.
-(void) updatePosition: (TrackedObject*) refPt {
    [mutex lock];
    
    // We're manually aquiring a full object lock during this update on the refPt.
    [refPt lock];
    
    // X - Northing
    // Y - Easting
    // Z - Altitude
    
    altitude = (z - [refPt getAltitude]);
    
    // number of meters per degree
    double unit = (1.0 / 111319.9);
    
    // > 0 => north
    double northing = (x - [refPt getX]) * unit;
    
    // > 0 => east
    double easting = (y - [refPt getY]) * unit;
    
    //           pos/neg
    // lat is north/south, +- 90
    // long is east/west, +- 180
    
    double newLat = [refPt getLatitude] + northing;
    if (newLat > 90.0) {
         newLat -= 180.0;
    } else if (newLat < -90.0) {
        newLat += 180.0;
    }
    
    double newLong = [refPt getLongitude] + easting;
    if (newLong > 180.0) {
        newLong -= 360.0;
    } else if (newLat < -180.0) {
        newLong += 360.0;
    }
    
    
    longitude = newLong;
    latitude = newLat;
    
    
    
    [refPt unlock];
    [mutex unlock];
}

@end
