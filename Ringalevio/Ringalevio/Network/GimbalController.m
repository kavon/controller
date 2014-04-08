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
    
    gim_len = 11;
    gim_buf = calloc(gim_len, 1);
    
    // Setup Gimbal Positioning Message.
    gim_buf[0] = 0x30;       // Label
    gim_buf[1] = gim_len;   // Message Length
    gim_buf[2] = 0x0;       // original message.
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

-(void) writeAzimuthSpeed: (int16_t)az {
    *((int16_t*)(gim_buf + 4)) = az;
}

-(void) writeElevationSpeed: (int16_t)az {
    *((int16_t*)(gim_buf + 6)) = az;
}

-(void) writeEnableTrackingMode: (BOOL)az {
    gim_buf[8] = (az ? 1 : 0);
}


-(int16_t) lastAzimuthSpeed {
    return *((int16_t*)(gim_buf + 4));
}

-(int16_t) lastElevationSpeed {
    return *((int16_t*)(gim_buf + 6));
}

-(BOOL) lastTrackingModeEnabled {
    return gim_buf[8] == 1;
}




@end
