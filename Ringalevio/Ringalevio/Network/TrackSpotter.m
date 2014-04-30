//
//  LaserController.m
//  Ringalevio
//
//  Created by Kavon Farvardin on 3/1/14.
//
//

#import "TrackSpotter.h"

@implementation TrackSpotter
{
    // Represents the current Laser Control Message.
    uint8_t *track_buf;
    long track_len; // CONST, but can't mark it because obj-c is lame.
}

-(id) init:(NSString *)host :(int)port {
    self = [super init:host :port];
    
    track_len = 18;
    track_buf = calloc(track_len, 1);
    
    track_buf[0] = 0x1;        // Track update message
    track_buf[1] = track_len;   // size of this message
    track_buf[2] = 0x0;         // this is the original message
    track_buf[3] = 0x0;         // TEST SENSOR
    
    return self;
}

-(void) dealloc {
    free(track_buf);
}

-(void)sendTrackUpdateMessage {
    // calculate checksum before sending.
    int checkSum = 0;
    for(int i = 0; i < track_len-1; i++) {
        checkSum += track_buf[i];
    }
    track_buf[track_len-1] = (uint8_t)(checkSum % 256);
    
    [self send: track_buf :track_len];
}

-(void) writeTarget:(uint8_t) targ {
    track_buf[4] = targ;
}

-(uint8_t) lastLaserTarget {
    return track_buf[4];
}

-(void) writePositionX:(int32_t) newX {
    *((int32_t*)(track_buf + 5)) = newX;
}
-(void) writePositionY:(int32_t) newY {
    *((int32_t*)(track_buf + 9)) = newY;
}

-(void) writePositionZ:(int32_t) newZ {
    *((int32_t*)(track_buf + 13)) = newZ;
}




@end
