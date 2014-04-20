//
//  Configuration.h
//  Ringalevio
//
//  Created by Kavon Farvardin on 4/20/14.
//
//

#import <Foundation/Foundation.h>

@interface Configuration : NSObject

// address of the server with track data etc.
extern NSString * const SERVER_ADDR;

// address of the video stream server.
extern NSString * const STREAM_ADDR;

// port the server listens for packets from iOS on.
extern int const SERVER_RCV_PORT;

// port the server sends packets to iOS on.
extern int const SERVER_TXMT_PORT;


@end
