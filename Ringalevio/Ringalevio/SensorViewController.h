//
//  SensorViewController.h
//  Ringalevio
//
//  Created by Kavon Farvardin on 3/15/14.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import "MissionItem.h"

@interface SensorViewController : UIViewController

// Mission item for recieving URL
@property MissionItem* mi;

//variables for gyro
@property NSString *x;
@property NSString *y;
@property NSString *z;

// controller for gyro
@property CMMotionManager* motionManager;

- (void)reloadStream;

- (void) setTargetNumber:(uint8_t)targ;

@end
