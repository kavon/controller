//
//  AddMissionViewController.h
//  Ringalevio
//
//  Created by Sean Lane on 3/12/14.
//
//

#import <UIKit/UIKit.h>
#import <Mapbox/Mapbox.h>
#import "MissionItem.h"

@interface AddMissionViewController : UIViewController

// method for when cache button is pressed
- (IBAction)cacheButtonPress:(id *)sender;

@property  MissionItem *mi;
@end
