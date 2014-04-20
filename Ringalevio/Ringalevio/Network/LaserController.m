//
//  LaserController.m
//  Ringalevio
//
//  Created by Kavon Farvardin on 3/1/14.
//
//

#import "LaserController.h"

@implementation LaserController
{
    // Represents the current Laser Control Message.
    uint8_t *laser_buf;
    long laser_len; // CONST, but can't mark it because obj-c is lame.
}

-(id) init:(NSString *)host :(int)port {
    self = [super init:host :port];
    
    laser_len = 7;
    laser_buf = calloc(laser_len, 1);
    
    laser_buf[0] = 0x40;        // Laser control message
    laser_buf[1] = laser_len;   // size of this message
    laser_buf[2] = 0x0;         // this is the original message
    laser_buf[3] = 0x0;         // TEST SENSOR
    
    return self;
}

-(void) dealloc {
    free(laser_buf);
}

-(void)sendLaserMessage {
    // calculate checksum before sending.
    int checkSum = 0;
    for(int i = 0; i < laser_len-1; i++) {
        checkSum += laser_buf[i];
    }
    laser_buf[laser_len-1] = (uint8_t)(checkSum % 256);
    
    [super send: laser_buf :laser_len];
}

-(void) writeLaserMode:(uint8_t) mode {
    // TODO: Placeholder.
    switch (mode) {
        case 1:
            // Standby
            laser_buf[5] = 0x01;
            break;
            
        case 2:
            // initate laser warning
            laser_buf[5] = 0x11;
            break;
            
        default:
            // OFF
            laser_buf[5] = 0x0;
            break;
    }
}

-(void) writeTarget:(uint8_t) targ {
    laser_buf[4] = targ;
}


-(uint8_t)lastLaserMode {
    if(laser_buf[5] == 0x11) {
        return 2;
    } else if(laser_buf[5] == 0x01) {
        return 1;
    } else {
        return 0;
    }
}

-(uint8_t) lastLaserTarget {
    return laser_buf[4];
}




@end
