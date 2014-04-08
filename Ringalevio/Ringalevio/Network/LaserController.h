//
//  LaserController.h
//  Ringalevio
//
//  Created by Kavon Farvardin on 3/1/14.
//
//

#import "GimbalController.h"

@interface LaserController : GimbalController

/**
 * Send the message in the buffer.
 */
-(void)sendLaserMessage;

/**
 * Write to current message.
 * 0 = OFF, 1 = Standby, 2 = LASE!!!
 */
-(void) writeLaserMode:(uint8_t) mode;

/**
 * This should be a valid track number.
 * Valid range is 0x01-0xFF.
 */
-(void) writeTarget:(uint8_t) targ;

/**
 * Last mode written to internal buffer (sent or not).
 *
 * 0 = OFF, 1 = Standby, 2 = LASE!!!
 */
-(uint8_t)lastLaserMode;

/**
 * Last target written to internal buffer (sent or not).
 */
-(uint8_t) lastLaserTarget;


@end
