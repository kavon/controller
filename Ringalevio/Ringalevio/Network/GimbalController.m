//
//  GimbalController.m
//  Ringalevio
//
//  Created by Kavon Farvardin on 3/1/14.
//
//

#import "GimbalController.h"

@implementation GimbalController
{
    // Represents the current Gimbal Positioning Message.
    uint8_t *gim_buf;
    long gim_len; // CONST, but can't mark it because obj-c is lame.
}

-(id) init:(NSString *)host :(int)port {
    self = [super init:host :port];
    
    gim_len = 26;
    gim_buf = calloc(1, gim_len);
    
    // Setup Gimbal Positioning Message.
    gim_buf[0] = 0x4;       // Label
    gim_buf[1] = gim_len;   // Message Length
    
    gim_buf[3] = 0x1;       // Controller ID (iOS).
    
    
    return self;
}

-(void) dealloc {
    free(gim_buf);
}

-(void)sendGimbalMessage {
    // calculate checksum before sending.
    int checkSum = 0;
    for(int i = 0; i < gim_len-1; i++) {
        checkSum += gim_buf[i];
    }
    gim_buf[gim_len-1] = (uint8_t)(checkSum % 256);
    
    [self send: gim_buf :gim_len];
}


-(void) writeGimbalXPosition: (uint32_t)x {
    ((uint32_t*)gim_buf)[1] = x;
}

-(void) writeGimbalYPosition: (uint32_t)y {
    ((uint32_t*)gim_buf)[2] = y;
}

-(void) writeGimbalZPosition: (uint32_t)z {
    ((uint32_t*)gim_buf)[3] = z;
}

-(void) writeGimbalAzimuth: (uint32_t)az {
    ((uint32_t*)gim_buf)[4] = az;
}

-(void) writeGimbalElevation:(int32_t)ele {
    ((int32_t*)gim_buf)[5] = ele;
}


-(uint32_t) lastGimbalXPosition {
    return ((uint32_t*)gim_buf)[1];
}

-(uint32_t) lastGimbalYPosition {
    return ((uint32_t*)gim_buf)[2];
}

-(uint32_t) lastGimbalZPosition {
    return ((uint32_t*)gim_buf)[3];
}

-(uint32_t) lastGimbalAzimuth {
    return ((uint32_t*)gim_buf)[4];
}

-(int32_t) lastGimbalElevation {
    return ((int32_t*)gim_buf)[5];;
}




@end
