//
//  OnlineMapViewController.h
//  Ringalevio
//
//  Online Map View Controller is the view controller subclass that dictates how the map operates.
//
//
//  Created by Tim Sexton on 3/13/14.
//
//

#import <UIKit/UIKit.h>
#import "MissionControlViewController.h"
#import "MissionItem.h"
#import "PacketListener.h"

@interface OnlineMapViewController : UIViewController <RMMapViewDelegate>

// current mission item
@property  MissionItem *mi;

// public method to init mission item
- (void)initMissionItem:(MissionItem *)mi_i;

@end
