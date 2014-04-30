//
//  LaserController.h
//  Ringalevio
//
//  Created by Kavon Farvardin on 3/1/14.
//
//

#import "GimbalController.h"

@interface TrackSpotter : DeviceMessenger

/**
 * Send the message in the buffer.
 */
-(void)sendTrackUpdateMessage;

-(void) writeTarget:(uint8_t) targ;

/**
 * This should be a valid track number.
 * Valid range is 0x01-0xFF.
 */
-(void) writeTarget:(uint8_t) targ;

/**
 * Last target written to internal buffer (sent or not).
 */
-(uint8_t) lastLaserTarget;

-(void) writePositionZ:(int32_t) newZ;

-(void) writePositionX:(int32_t) newX;

-(void) writePositionY:(int32_t) newY;


@end
