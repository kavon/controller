//
//  PacketListener.h
//  Ringalevio
//
//  Created by Kavon Farvardin on 4/7/14.
//
//

#import <Foundation/Foundation.h>

@protocol PacketListener <NSObject>

// For now, check the interface spec doc for what the values mean,
// I'll add more documentation once someone is actually using this. - Kavon

/**
 * Fields: @"sensor_id", @"x_position", @"y_position", "z_position"
 */
-(void) recievedSensorLocationMessage: (NSDictionary*) data;

/**
 * Fields: @"sensor_id", @"x_position", @"y_position", "z_position"
 */
-(void) recievedTrackSourceLocationMessage: (NSDictionary*) data;

/**
 * Fields: @"sensor_id", @"track_number", @"x_position", @"y_position", "z_position"
 */
-(void) recievedTrackUpdateMessage: (NSDictionary*) data;

/**
 * Fields: @"sensor_id", @"track_number"
 */
-(void) recievedTrackDropMessage: (NSDictionary*) data;

@end
