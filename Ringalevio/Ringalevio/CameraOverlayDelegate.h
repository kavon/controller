//
//  CameraOverlayDelegate.h
//  Ringalevio
//
//  Created by Sean Lane on 4/27/14.
//
//

@protocol CameraOverlayDelegate <NSObject>

// cancel button action to segue back to map (or something else)
-(void)CancelButtonPress:(id)sender;

// could add Add track delegate function here to easily throw code to a net-enabled object

@end
