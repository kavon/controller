//
//  PacketListener.h
//  Ringalevio
//
//  Created by Kavon Farvardin on 4/7/14.
//
//

#import <Foundation/Foundation.h>

@protocol PacketListener <NSObject>

-(void) recievedSensorLocationMessage: (NSDictionary*) data;

-(void) recievedTrackSourceLocationMessage: (NSDictionary*) data;

-(void) recievedTrackUpdateMessage: (NSDictionary*) data;

-(void) recievedTrackDropMessage: (NSDictionary*) data;

@end
