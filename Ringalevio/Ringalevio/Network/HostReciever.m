//
//  HostReciever.m
//  Ringalevio
//
//  Created by Kavon Farvardin on 4/7/14.
//
//

#import "HostReciever.h"
#import "Configuration.h"

@implementation HostReciever
{
    NSLock *mutex;   // protects the list from concurrent access while adding/removing listeners.
    NSMutableArray *listenerList;
    GCDAsyncUdpSocket *socky;
}

+(id) getInstance {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}

-(id) init {
    // initialize and register self with the socket as a delegate
    mutex = [[NSLock alloc] init];
    listenerList = [[NSMutableArray alloc] init];
    socky = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    NSError* __autoreleasing err1 = [NSError errorWithDomain:@"Error binding to port for listening." code:1337 userInfo:nil];
    NSError* __autoreleasing err2 = [NSError errorWithDomain:@"Error with beginRecieving on port." code:1338 userInfo:nil];
    
    [socky bindToPort:LISTEN_PORT error:&err1];
    [socky beginReceiving:&err2];
    
    return self;
}

-(void) registerListener: (id<PacketListener>) p {
    [mutex lock];
    [listenerList addObject:p];
    [mutex unlock];
}

-(void) removeListener: (id<PacketListener>) p {
    [mutex lock];
    [listenerList removeObject:p];
    [mutex unlock];
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
                                            fromAddress:(NSData *)address
                                            withFilterContext:(id)filterContext {
    
    //TODO: drop packet if not from appropriate address (change init to take a host IP).
    
    // verify checksum. if it fails, we drop it like it's hawt
    int sum = 0;
    unsigned long size = [data length];
    uint8_t *packet = malloc(size);
    for(unsigned long i = 0; i < size-1; i++) {
        sum += packet[i];
    }
    
    if((sum % 256) != packet[size-1]) {
        NSLog(@"Corrupt Packet.");
        return; // damaged goods.
    }
    
    if(packet[2] != 0x0) {
        // this is not an original message. NOPE
        return;
    }
    
    NSDictionary *message = [[NSDictionary alloc] init];
    switch(packet[0]) {
        // TRACK SOURCE LOCATION MESSAGE
        case 0x10:
            
            NSLog(@"got TRACK SOURCE LOCATION packet");
            
            [message setValue:[NSNumber numberWithInt:(packet[3])] forKey:@"sensor_id"];
            [message setValue:[NSNumber numberWithInt:(*((int32_t*)(packet+4)))] forKey:@"x_position"];
            [message setValue:[NSNumber numberWithInt:(*((int32_t*)(packet+8)))] forKey:@"y_position"];
            [message setValue:[NSNumber numberWithInt:(*((int32_t*)(packet+12)))] forKey:@"z_position"];
            
            [mutex lock];
            for(int i = 0; i < [listenerList count]; i++) {
                [[listenerList objectAtIndex:i] recievedTrackSourceLocationMessage: message];
            }
            [mutex unlock];
            
            break;
            
        // TRACK UPDATE MESSAGE (SENSOR TRACK MESSAGE)
        case 0x11:
            
            NSLog(@"got TRACK UPDATE packet");
            
            [message setValue:[NSNumber numberWithInt:(packet[3])] forKey:@"sensor_id"];
            [message setValue:[NSNumber numberWithInt:(packet[4])] forKey:@"track_number"];
            [message setValue:[NSNumber numberWithInt:(*((int32_t*)(packet+5)))] forKey:@"x_position"];
            [message setValue:[NSNumber numberWithInt:(*((int32_t*)(packet+9)))] forKey:@"y_position"];
            [message setValue:[NSNumber numberWithInt:(*((int32_t*)(packet+13)))] forKey:@"z_position"];
            
            
            [mutex lock];
            for(int i = 0; i < [listenerList count]; i++) {
                [[listenerList objectAtIndex:i] recievedTrackUpdateMessage: message];
            }
            [mutex unlock];
            
            break;
        
        // TRACK/TARGET DROP MESSAGE
        case 0x12:
            
            NSLog(@"got TRACK DROP packet");
            
            [message setValue:[NSNumber numberWithInt:(packet[3])] forKey:@"sensor_id"];
            [message setValue:[NSNumber numberWithInt:(packet[4])] forKey:@"track_number"];
            
            [mutex lock];
            for(int i = 0; i < [listenerList count]; i++) {
                [[listenerList objectAtIndex:i] recievedTrackDropMessage: message];
            }
            [mutex unlock];
            
            break;
            
        // SENSOR LOCATION MESSAGE
        case 0x20:
            
            NSLog(@"got SENSOR LOCATION packet");
            
            [message setValue:[NSNumber numberWithInt:(packet[3])] forKey:@"sensor_id"];
            [message setValue:[NSNumber numberWithInt:(*((int32_t*)(packet+4)))] forKey:@"x_position"];
            [message setValue:[NSNumber numberWithInt:(*((int32_t*)(packet+8)))] forKey:@"y_position"];
            [message setValue:[NSNumber numberWithInt:(*((int32_t*)(packet+12)))] forKey:@"z_position"];
            
            [mutex lock];
            for(int i = 0; i < [listenerList count]; i++) {
                [[listenerList objectAtIndex:i] recievedSensorLocationMessage: message];
            }
            [mutex unlock];
            
            break;
            
        default:
            // this probably might get flooded. we're just silently dropping it anyway.
            NSLog(@"Invalid message type recieved from host.");
            return;
    }
    
}

@end
