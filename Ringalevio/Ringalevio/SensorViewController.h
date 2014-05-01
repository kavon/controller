//
//  SensorViewController.h
//  Ringalevio
//
//  Created by Kavon Farvardin on 3/15/14.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import <Foundation/Foundation.h>
#import "MissionItem.h"
#import "TrackedObject.h"

@interface SensorViewController : UIViewController

// Mission item for recieving URL
@property MissionItem* mi;

// timers
@property NSTimer* updateTimer;
@property NSTimer* messageTimer;

//variables for gyro
@property CMAttitude *attitude;
@property double x;
@property double y;
@property double z;
@property TrackedObject *currentTarget;


// controller for gyro
@property CMMotionManager* motionManager;

- (void)reloadStream;

- (void) setTargetNumber:(TrackedObject*)targ;

-(TrackedObject*) getTargetNumber;

@end
