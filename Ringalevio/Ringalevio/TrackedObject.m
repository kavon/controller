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
    uint32_t x;
    uint32_t y;
    uint32_t z;
    double latitude;
    double longitude;
    double altitude;
    int ident;
    
}

-(void) doBasicInit {
    mutex = [[NSRecursiveLock alloc] init];
    ident = -1;
    x = 0;
    y = 0;
    z = 0;
    latitude = 0.0;
    longitude = 0.0;
    altitude = 0.0;
}

// 0 should be used for the sensor
-(id)initWithID: (int) idental {
    
    if( self = [super init] ) {
        [self doBasicInit];
        
        ident = idental;
    }
    
    return self;
}

// id will be initialized to -1, since that's invalid.
// be careful because that's 0xFF if casted to a byte.
// use this for the fixed reference point.
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

-(void) setX:(uint32_t) xPos {
    [mutex lock];
    x = xPos;
    [mutex unlock];
}

-(void) setY:(uint32_t) yPos {
    [mutex lock];
    y = yPos;
    [mutex unlock];
}

-(void) setZ:(uint32_t) zPos {
    [mutex lock];
    z = zPos;
    [mutex unlock];
}

-(uint32_t) getX {
    [mutex lock];
    uint32_t copy = x;
    [mutex unlock];
    return copy;
}

-(uint32_t) getY {
    [mutex lock];
    uint32_t copy = y;
    [mutex unlock];
    return copy;
}

-(uint32_t) getZ {
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

// must call this to update this track's position if you modify its offsets.
-(void) updatePosition: (TrackedObject*) refPt {
    
    if (ident == -1) {
        // this is a reference point, you're not allowed to update it!
        NSLog(@"Reference Points are not allowed to be updated!");
        return;
    }
    
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
    } else if (newLat < 90.0) {
        newLat += 180.0;
    }
    
    double newLong = [refPt getLongitude] + easting;
    if (newLong > 180.0) {
        newLong -= 360.0;
    } else if (newLat < 180.0) {
        newLong += 360.0;
    }
    
    
    longitude = newLong;
    latitude = newLat;
    
    
    
    [refPt unlock];
    [mutex unlock];
}

@end
