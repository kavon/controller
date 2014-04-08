//
//  GimbalController.h
//  Ringalevio
//
//  Created by Kavon Farvardin on 3/1/14.
//
//

#import "DeviceMessenger.h"

@interface GimbalController : DeviceMessenger

/**
 * Sends the current buffer as a Gimbal Message via a UDP packet.
 */
-(void) sendGimbalMessage;

/**
 * Relative speed of gimbal control (horizontal motion),
 * -64 = max rate to the LEFT,
 * 0 = stop (no motion)
 * +64 = max rate to the RIGHT
 * Legal Range = -64 to + 64
 */
-(void) writeAzimuthSpeed: (int16_t)az;


/**
 * Relative speed of gimbal control (vertical motion),
 * -64 = max rate to the DOWN
 * 0 = stop (no motion)
 * +64 = max rate to the UP
 * Legal Range = -64 to + 64
 */
-(void) writeElevationSpeed: (int16_t)az;


/**
 * Optical Tracking Mode:
 * false = Optical tracking OFF
 * true = optical tracking ON
 */
-(void) writeEnableTrackingMode: (BOOL)az;


-(int16_t) lastAzimuthSpeed;

-(int16_t) lastElevationSpeed;

-(BOOL) lastTrackingModeEnabled;

@end
