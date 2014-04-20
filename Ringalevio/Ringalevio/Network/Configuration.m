//
//  Configuration.m
//  Ringalevio
//
//  Created by Kavon Farvardin on 4/20/14.
//
//

#import "Configuration.h"

@implementation Configuration

NSString * const SERVER_ADDR = @"192.168.23.41";

// address of the video stream server.
NSString * const STREAM_ADDR = @"192.168.23.35";

// port the server listens for packets from iOS on.
int const SERVER_RCV_PORT = 8131;

// port the server sends packets to iOS on.
int const SERVER_TXMT_PORT = 8121;

@end
