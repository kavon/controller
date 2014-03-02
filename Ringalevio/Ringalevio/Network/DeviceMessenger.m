//
//  DeviceMessenger.m
//  Ringalevio
//
//  Created by Kavon Farvardin on 3/1/14.
//
//

#import "DeviceMessenger.h"

@implementation DeviceMessenger
{
    NSString *hostName;
    int portNum;
    GCDAsyncUdpSocket *socky;
    NSMapTable *messageList;
    long lastTag;
    
}

-(id) init :(NSString*) host :(int) port {
    hostName = host;
    portNum = port;
    lastTag = 0;
    
    // we need a dictionary to store all of the messages that need to be freed once they're sent.
    messageList = [NSMapTable mapTableWithKeyOptions:NSMapTableCopyIn valueOptions:NSMapTableStrongMemory];
    
    socky = [[GCDAsyncUdpSocket alloc] init];
    [socky setDelegate:self];
    
    return self;
}

/**
 * GCD Async Delegate methods. Note that they're all optional so not all are implemented.
 */
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag {
    // remove reference in the map, effectively "release"s its last strong reference.
    [messageList removeObjectForKey:[NSNumber numberWithLong:tag]];
}



/**
 * PRIVATE
 *
 * This should never be called from code that is not within a subclass of DeviceMessenger.
 *
 * It is a helper method for all subclasses of DeviceMessenger that sends a raw array of
 * data to the device via a UDP packet.
 *
 */
-(void) send :(void*) message :(long) numBytes {
    NSData *copy = [[NSData alloc] initWithBytes:message length:numBytes];
    [messageList setObject:copy forKey: [NSNumber numberWithLong:lastTag++]];
    
    // sendData requires that you do not modify the buffer until the delegate function
    // indicating it successfully sent the data with the tag specified.
    // our map will retain a strong pointer to the memory until the function is called
    // and then release it.
    
    [socky sendData:copy toHost:hostName port:portNum withTimeout:-1 tag:lastTag];
}


@end
