//
//  SensorViewController.h
//  Ringalevio
//
//  Created by Kavon Farvardin on 3/15/14.
//

#import <UIKit/UIKit.h>
#import "MissionItem.h"

@interface SensorViewController : UIViewController

// Mission item for recieving URL
@property MissionItem* mi;

- (void)reloadStream;

- (void) setTargetNumber:(uint8_t)targ;

@end
