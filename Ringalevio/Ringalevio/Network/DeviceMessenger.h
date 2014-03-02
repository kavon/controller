//
//  DeviceMessenger.h
//  Ringalevio
//
//  Created by Kavon Farvardin on 3/1/14.
//
//

#import <Foundation/Foundation.h>
#import "GCDAsyncUdpSocket.h"

@interface DeviceMessenger : NSObject

@property (strong) id <GCDAsyncUdpSocketDelegate> sockDelegate;

/**
 * Initialize to for sending.
 */
- (id)init :(NSString*) host :(int) port;

/**
 *
 * PRIVATE, DO NOT CALL UNLESS IF YOU'RE A SUBCLASS OF THIS CLASS.
 *
 */
-(void) send :(void*) message :(long) numBytes;

@end
