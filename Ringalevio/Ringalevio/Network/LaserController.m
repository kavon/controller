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
    
    laser_len = 0;
    laser_buf = calloc(1, laser_len);
    
    // TODO: initialize Laser Control Message
    
    
    return self;
}

-(void) dealloc {
    free(laser_buf);
}


-(void) writeLaserMode:(uint8_t) mode {
    // TODO: Placeholder.
    switch (mode) {
        case 1:
            // Standby
            break;
            
        case 2:
            // Lase
            break;
            
        default:
            // OFF
            break;
    }
}

-(void) writeLaserTarget:(uint8_t) targ {
    // TODO: Placeholder.
}


-(uint8_t)lastLaserMode {
    // TODO: Placeholder.
    return 0;
}

-(uint8_t) lastLaserTarget {
    // TODO: Placeholder.
    return 0;
}




@end
