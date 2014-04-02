//
//  AddMapViewController.h
//  Ringalevio
//
//  Created by Tim Sexton on 3/13/14.
//
//

#import <UIKit/UIKit.h>
#import "MissionControlViewController.h"
#import "MissionItem.h"

@interface OnlineMapViewController : UIViewController

// current mission item
@property  MissionItem *mi;

// public method to init mission item
- (void)initMissionItem:(MissionItem *)mi_i;

@end
