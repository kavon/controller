//
//  HostReciever.h
//  Ringalevio
//
//  Created by Kavon Farvardin on 4/7/14.
//
//

#import <Foundation/Foundation.h>
#import "PacketListener.h"
#import "GCDAsyncUdpSocket.h"

@interface HostReciever : NSObject

@property (strong) id <GCDAsyncUdpSocketDelegate> sockDelegate;

+(id) getInstance;

/**
 * NEVER CALL THIS HOLY CRAP IT WOULD BE BAD NEWS BEARS.
 * THIS IS A SINGLETON, CALL "GET INSTANCE".
 */
-(id) init;

-(void) registerListener: (id<PacketListener>) p;

-(void) removeListener: (id<PacketListener>) p;

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
                                            fromAddress:(NSData *)address
                                            withFilterContext:(id)filterContext;

@end
