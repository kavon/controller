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
 * Saves the value to the buffer.
 */
-(void) writeGimbalXPosition: (uint32_t)x;

/**
 * Saves the value to the buffer.
 */
-(void) writeGimbalYPosition: (uint32_t)y;

/**
 * Saves the value to the buffer.
 */
-(void) writeGimbalZPosition: (uint32_t)z;

/**
 * Saves the value to the buffer.
 */
-(void) writeGimbalAzimuth: (uint32_t)az;

/**
 * Saves the value to the buffer.
 */
-(void) writeGimbalElevation: (int32_t)ele;

/**
 * Last value written to the buffer (whether sent or not).
 */
-(uint32_t) lastGimbalXPosition;

/**
 * Last value written to the buffer (whether sent or not).
 */
-(uint32_t) lastGimbalYPosition;

/**
 * Last value written to the buffer (whether sent or not).
 */
-(uint32_t) lastGimbalZPosition;

/**
 * Last value written to the buffer (whether sent or not).
 */
-(uint32_t) lastGimbalAzimuth;

/**
 * Last value written to the buffer (whether sent or not).
 */
-(int32_t) lastGimbalElevation;

@end
