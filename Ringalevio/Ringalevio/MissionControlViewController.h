//
//  MissionControlViewController.h
//  Ringalevio
//
//  Created by Sean Lane on 3/12/14.
//
//

#import <UIKit/UIKit.h>

@interface MissionControlViewController : UITableViewController

// custom unwind command to return from a different view
- (IBAction)unwindToList:(UIStoryboardSegue *)segue;

// save controls
- (void)applicationDidEnterBackground;

@end
